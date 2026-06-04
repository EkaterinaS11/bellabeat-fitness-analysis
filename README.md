Case Study: Bellabeat Fitness Tracker Data Analysis
How Can a Smart Wellness Company Play It Smart?
________________________________________
Project Overview
Bellabeat is a high-tech manufacturer of health-focused products designed for women. The goal of this project was to analyze smart device usage data from Fitbit to gain insights into how consumers use their fitness trackers. These insights can help guide Bellabeat's marketing strategies and product development decisions.
This is my capstone project for the Google Data Analytics Professional Certificate (Coursera, 2026).
________________________________________
Repository Structure
bellabeat-analysis/
├── bellabeat_analysis.ipynb   # Python analysis (Jupyter Notebook)
├── bellabeat_analysis.sql     # SQL queries (BigQuery)
└── README.md
________________________________________
Data Source
Dataset: FitBit Fitness Tracker Data (Kaggle)
Personal fitness tracker data from 33 Fitbit users — daily steps, calories burned, active minutes, and minute-level sleep logs.
________________________________________
Tools Used
Tool	Purpose
Excel	Initial exploration, data cleaning, pivot tables
SQL (BigQuery)	Dataset management, filtering, aggregation
Python (Jupyter Notebook)	Sleep analysis, visualizations (pandas, seaborn, matplotlib)
________________________________________
Data Cleaning
Before analysis, the daily activity dataset was cleaned:
•	Removed empty and non-informative columns
•	Checked for missing values
•	Converted data types and formatted date fields
•	Removed zero-step days (likely days when the device was not worn)
Several new features were created to enrich the analysis:
•	DayOfWeek — day of the week extracted from the activity date
•	DayType — weekday or weekend
•	TotalActiveMinutes — sum of Very Active, Fairly Active, and Lightly Active minutes
•	SedentaryRatio — proportion of sedentary time relative to total tracked time
•	CaloriesPerStep — ratio of calories burned to total steps taken
•	ActivityCategory — Low / Normal / High Activity based on daily step count
•	HealthyDay — custom flag based on steps and distance walked
________________________________________
Key Findings
Activity patterns
•	45% of users average between 5,000 and 10,000 steps per day
•	Average daily steps: ~7,600 — below the 10,000-step HealthyDay benchmark
•	Users spend about 81% of tracked time (16.5 hours/day) sedentary
•	No significant difference in activity between weekdays and weekends
Sleep quality
•	Average sleep efficiency: ~91%
•	Some users show poor sleep quality with frequent awakenings
•	Only users with at least 3 tracked sleep sessions were included to avoid skewed results
•	Better sleep quality correlates with higher activity the next day
________________________________________
Business Recommendations
1. Personalized step notifications Send reminders when users are close to their daily goal — for example: "You're only 1,500 steps away! A quick 15-minute walk can get you there."
2. Activity challenges Since activity doesn't naturally increase on weekends, weekly challenges and achievement badges could help keep users engaged. Sundays showed the lowest activity levels — a good target for push campaigns.
3. Sleep coaching Users with low sleep efficiency could benefit from in-app recommendations: wind-down routines, breathing exercises, bedtime reminders.
4. Wellbeing Score Combining step and sleep data into a single score could make progress more visible and shareable — increasing user engagement with the app.
________________________________________
Analyst: Ekaterina S


