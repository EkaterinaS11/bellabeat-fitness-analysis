# Case Study: Bellabeat Fitness Tracker Data Analysis
How Can a Smart Wellness Company Play It Smart?
## 1. Project Overview & Business Task
Bellabeat is a high-tech manufacturer of health-focused products designed for women. The goal of this project was to analyze smart device usage data from Fitbit in order to gain insights into how consumers use their fitness trackers. These insights can help guide Bellabeat’s marketing strategies and product development decisions.
## 2. Data Sources & Tool Selection
The dataset was sourced from Kaggle (FitBit Fitness Tracker Data). It contains personal fitness tracker data from Fitbit users, including daily steps, calories burned, active minutes, and minute-level sleep logs.
To demonstrate a complete analytical workflow, three tools were used:
•	*Excel*: Used for initial data exploration, data cleaning, and creating prototype pivot tables for daily activity metrics.
•	*SQL (BigQuery)*: Used to manage larger datasets, filter records, and perform data aggregation through SQL queries.
•	*Python* (Jupyter Notebook): Used for advanced analysis of large minute-level sleep datasets and for creating polished, publication-ready visualizations using pandas, seaborn, and matplotlib.
## 3. Data Cleaning and Processing
Step 1: Preparing Daily Activity Data (Excel & SQL)
Before starting the analysis, the daily activity dataset was cleaned to ensure accurate and reliable results:
•	Removed empty and non-informative columns.
•	Checked the dataset for missing values.
•	Retained only the columns relevant to user activity analysis.
•	Converted data types where necessary and ensured that date fields were properly formatted.
Step 2: Creating Engineered Features
To enrich the analysis, several additional metrics were created:
•	ActivityLevel(steps): Evaluated the raw volume of user activity based on step counts.
•	DayOfWeek: Extracted the day of the week from the activity date.
•	DayType: Categorized each date as either a weekday or a weekend.
•	TotalActiveMinutes: Calculated as the sum of Very Active, Fairly Active, and Lightly Active minutes.
•	SedentaryRatio: Measured the proportion of sedentary time relative to total tracked time.
•	CaloriesPerStep: Calculated as the ratio of calories burned to total steps taken.
•	ActivityCategory: Classified users into three distinct activity groups:
1.	Low activity
2.	Normal
3.	Activity
•	HealthyDay: A custom category evaluating whether a day met health criteria based on total steps and total distance.
## 4. Analysis & Insights
Part 1: General Activity Analysis (Excel & SQL)
Metric 1 — Top Users by Steps
Identified the most active users and analyzed the distribution of physical activity across the user base.
Metric 2 — Weekday vs. Weekend Usage
Compared activity patterns between weekdays and weekends.
*Insight:*
The analysis revealed almost no significant difference in step counts or device usage between weekdays and weekends. Users generally maintain consistent activity routines throughout the week.
Metric 3 — User Activity Distribution
Segmented users according to their activity levels.
*Insight:*
Most users fall into the low-to-moderate activity categories. This finding highlights an opportunity for Bellabeat to introduce motivational features aimed at increasing user engagement and physical activity.
Part 2: Advanced Sleep Quality Analysis (Python & SQL)
Because the minute-level sleep dataset (minuteSleep_merged) contained hundreds of thousands of records, Python and SQL were used to efficiently process and analyze the data.
*Methodology:*
•	Aggregated minute-level sleep logs to calculate Sleep Efficiency, defined as the percentage of restful sleep relative to total time spent in bed.
•	To reduce the impact of anomalies and ensure more reliable results, only users with at least three recorded sleep sessions were included in the analysis.
*Visualization:*
Created a sorted distribution chart using Python and seaborn to visualize sleep efficiency across individual users.
*Insight:*
While some users demonstrated highly efficient sleep patterns (above 90% sleep efficiency), a notable segment exhibited poor sleep quality, characterized by frequent awakenings and restless sleep.
## 5. Final Business Recommendations
Based on the findings, Bellabeat could implement the following initiatives to improve user engagement and support healthier habits:
1. Personalized Motivational Notifications
Since most users exhibit low-to-moderate activity levels, the app could send personalized reminders such as:
“You’re only 1,500 steps away from your daily goal! A quick 15-minute walk can get you there.”
2. Gamification and Activity Challenges
Because user activity does not naturally increase on weekends, Bellabeat could introduce features such as:
•	“Weekend Warrior” challenges
•	Achievement badges
•	Social competitions and rewards
These features could encourage users to stay active during their days off.
3. Advanced Sleep Coaching
Integrate sleep efficiency metrics directly into the Bellabeat app and provide personalized recommendations for users with low sleep efficiency, such as:
•	Evening wind-down routines
•	Guided breathing exercises
•	Bedtime reminders
•	Sleep habit improvement tips
This feature could help users improve sleep quality while increasing engagement with the Bellabeat ecosystem.

