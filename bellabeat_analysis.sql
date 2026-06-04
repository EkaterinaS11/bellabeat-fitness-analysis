##STEP 1. INITIALIZATION AND VARIABLES SETUP
## Define regular expressions for date and timestamp format validation
DECLARE DATE_REGEX STRING DEFAULT r'^\d{1,4}[-/]\d{1,2}[-/]\d{1,4}$';

##Define time boundaries to segment the 24-hour day into logical categories
DECLARE MORNING_START, MORNING_END, AFTERNOON_END, EVENING_END INT64;
SET MORNING_START = 6;
SET MORNING_END = 12;
SET AFTERNOON_END = 18;
SET EVENING_END = 21;


##STEP 2. DATA QUALITY AUDIT (VALIDATION)
## Validate the date format for the first 5 records of the primary activity table
## Note: ActivityDate is stored as DATE type, so we validate the date pattern
SELECT
  ActivityDate,
  REGEXP_CONTAINS(STRING(ActivityDate), DATE_REGEX) AS is_valid_date
FROM
  `fitbit.dailyActivity_merged`
LIMIT 5;


##STEP 3. CONSOLIDATED DAILY ACTIVITY VIEW
##Extract key daily performance metrics. The original script contained heavy 
##LEFT JOIN clauses, but since 'dailyActivity_merged' on Kaggle already includes 
##pre-aggregated steps, calories, and distances, we select them directly 
##to prevent potential row duplication.
SELECT
  Id,
  Calories,
  TotalSteps,
  TotalDistance,
  SedentaryMinutes,
  LightlyActiveMinutes,
  FairlyActiveMinutes,
  VeryActiveMinutes,
  SedentaryActiveDistance,
  LightActiveDistance,
  ModeratelyActiveDistance,
  VeryActiveDistance
FROM
  `fitbit.dailyActivity_merged`
WHERE
  TotalSteps > 0; -- Exclude zero-step days (likely missing device or dead battery)


##STEP 4. ADVANCED ANALYTICS & BUSINESS INSIGHTS
##ANALYTICAL SUB-BLOCK A: Daytime Sleep and Napping Habits
## Identify sleep sessions that start and end on the exact same calendar day (Naps).
SELECT
  Id,
  sleep_start AS sleep_date,
  COUNT(logId) AS number_naps,
  SUM(TIMESTAMP_DIFF(session_end, session_start, MINUTE)) AS total_nap_minutes
FROM (
  SELECT
    Id,
    logId,
    MIN(date) AS session_start,
    MAX(date) AS session_end,
    MIN(DATE(date)) AS sleep_start,
    MAX(DATE(date)) AS sleep_end
  FROM
    `fitbit.minuteSleep_merged`
  WHERE
    value = 1  -- Only count minutes where the user was actually asleep
  GROUP BY
    Id, logId
)
WHERE
  sleep_start = sleep_end
GROUP BY
  Id, sleep_date
ORDER BY
  number_naps DESC;


##ANALYTICAL SUB-BLOCK B: Hourly Intensity Distribution & Population Deciles
##Step B.1: Map user activity to days of the week and specific times of day
WITH user_dow_summary AS (
  SELECT
    Id,
    FORMAT_TIMESTAMP("%w", ActivityHour) AS dow_number,
    FORMAT_TIMESTAMP("%A", ActivityHour) AS day_of_week,
    CASE
      WHEN FORMAT_TIMESTAMP("%A", ActivityHour) IN ("Sunday", "Saturday") THEN "Weekend"
      ELSE "Weekday"
    END AS part_of_week,
    CASE
      WHEN EXTRACT(HOUR FROM ActivityHour) >= MORNING_START
       AND EXTRACT(HOUR FROM ActivityHour) <  MORNING_END   THEN "Morning"
      WHEN EXTRACT(HOUR FROM ActivityHour) >= MORNING_END
       AND EXTRACT(HOUR FROM ActivityHour) <  AFTERNOON_END THEN "Afternoon"
      WHEN EXTRACT(HOUR FROM ActivityHour) >= AFTERNOON_END
       AND EXTRACT(HOUR FROM ActivityHour) <  EVENING_END   THEN "Evening"
      ELSE "Night"
    END AS time_of_day,
    SUM(TotalIntensity) AS total_intensity,
    SUM(AverageIntensity) AS total_average_intensity,
    AVG(AverageIntensity) AS average_intensity,
    MAX(AverageIntensity) AS max_intensity,
    MIN(AverageIntensity) AS min_intensity
  FROM
    `fitbit.hourlyIntensities_merged`
  GROUP BY
    Id, dow_number, day_of_week, part_of_week, time_of_day
),

##Step B.2: Calculate activity deciles (10th, 20th, 50th/Median, and 90th percentiles)
intensity_deciles AS (
  SELECT
    dow_number,
    part_of_week,
    day_of_week,
    time_of_day,
    total_intensity_first_decile,
    total_intensity_second_decile,
    total_intensity_median,
    total_intensity_ninth_decile
  FROM (
    SELECT
      dow_number,
      part_of_week,
      day_of_week,
      time_of_day,
      ROUND(PERCENTILE_CONT(total_intensity, 0.1) OVER (PARTITION BY dow_number, part_of_week, day_of_week, time_of_day), 4) AS total_intensity_first_decile,
      ROUND(PERCENTILE_CONT(total_intensity, 0.2) OVER (PARTITION BY dow_number, part_of_week, day_of_week, time_of_day), 4) AS total_intensity_second_decile,
      ROUND(PERCENTILE_CONT(total_intensity, 0.5) OVER (PARTITION BY dow_number, part_of_week, day_of_week, time_of_day), 4) AS total_intensity_median,
      ROUND(PERCENTILE_CONT(total_intensity, 0.9) OVER (PARTITION BY dow_number, part_of_week, day_of_week, time_of_day), 4) AS total_intensity_ninth_decile,
      ROW_NUMBER() OVER (PARTITION BY dow_number, part_of_week, day_of_week, time_of_day ORDER BY total_intensity) AS rn
    FROM user_dow_summary
  )
  WHERE rn = 1
),

##Step B.3: Compute basic demographic aggregates (totals, averages, bounds)
basic_summary AS (
  SELECT
    part_of_week,
    day_of_week,
    time_of_day,
    dow_number,
    SUM(total_intensity) AS total_intensity,
    AVG(total_intensity) AS average_total_intensity,
    SUM(total_average_intensity) AS total_average_intensity,
    AVG(max_intensity) AS average_max_intensity,
    AVG(min_intensity) AS average_min_intensity
  FROM
    user_dow_summary
  GROUP BY
    part_of_week, day_of_week, time_of_day, dow_number
)

##Step B.4: Consolidate basic statistics and deciles into a sorted final output matrix
SELECT
  basic_summary.part_of_week,
  basic_summary.day_of_week,
  basic_summary.time_of_day,
  basic_summary.dow_number,
  basic_summary.total_intensity,
  basic_summary.average_total_intensity,
  basic_summary.total_average_intensity,
  basic_summary.average_max_intensity,
  basic_summary.average_min_intensity,
  intensity_deciles.total_intensity_first_decile,
  intensity_deciles.total_intensity_second_decile,
  intensity_deciles.total_intensity_median,
  intensity_deciles.total_intensity_ninth_decile
FROM
  basic_summary
LEFT JOIN
  intensity_deciles
ON
  basic_summary.part_of_week = intensity_deciles.part_of_week
  AND basic_summary.day_of_week = intensity_deciles.day_of_week
  AND basic_summary.time_of_day = intensity_deciles.time_of_day
  AND basic_summary.dow_number = intensity_deciles.dow_number
ORDER BY
  basic_summary.part_of_week, 
  basic_summary.dow_number, 
  basic_summary.day_of_week,
  CASE
    WHEN basic_summary.time_of_day = 'Morning' THEN 0
    WHEN basic_summary.time_of_day = 'Afternoon' THEN 1
    WHEN basic_summary.time_of_day = 'Evening' THEN 2
    WHEN basic_summary.time_of_day = 'Night' THEN 3
  END;
