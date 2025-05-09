# oilfield_accidents_data_analysis_project
Personal project being developed when I have extra time. Below will be a very rough description of my plans for the project though this description will evlove as the project is developed.

I am taking a dataset from kaggle based on oilfield accident data in the US and doing some data analysis by using queries and data visualization tool such as PowerBI. Data dates range from 2010 to 2017.

First, I cleaned the data and create a new database to store it as well as model and normalize it to 3NF. I will be doing this using DBeaver as my database tool and all coding with be done is Postgresql when using this tool.
  Cleaning was done is excel, which is whyere i removed some uneeded columns that were over 90% empty and standardized the format of some columns.

Second, performed queries on the data to find useful insights. Used PowerBI to make an interactive dashboard that provides the following insights:
  - Shows the break down of cost for each type of accidents primary cause.
  - Shows a pie chart for cost comparision.
  - Displays a bar chart for a count of what are the most common accident causes.
  - Includes a donut chart showing the portion of the total accidents by each cause that were severe (resulted in a pipeline shutdown).
  - Shows a line chart to help understand how many accdients have happened each month over the years 2010-2017.
  - Lastly includes a slicer to check and see what the break down of the above information for different types of pipelines will be.

I will also be learning PowerBI from the Microsoft PL-900 certificate training course to then apply this knowledge to the project for data visualization and continue to add things to it as I learn more.

So far what we can infer from the visulaizations on the dashboard is the following:
  - Overall the most common and most costly cause for accidents is Material/Weld/Equipment Failure. Which accounts for 1435 of the 2795 reported accidents and makes up $1.24bn (53.35%) of the total cost of all accidents in the dataset.
  - What we can infer from the Donut chart is that overall though Excavation Damage is the cause of only 97 recorded accidents, 77.3% of those accidents resulted in a accident severe enough to result in a pipeline shutdown where only 48.6% of the most common accident cause       resulted in a shutdown.
  - From the line chart overall trends that can be observed are:
      1. Most accidents occured the spring months with January being the month with the most accidents.
      2. Dip in reported accidents in the June and October months
      3. Peaks in the August and Novemebr months.

Some further analysis that could be done based on what can be seen in these visuals are:
  1. Doing some statistical tests such as logistic regression to see if accident cause is related to accdient severity.
  2. Doing further invesitgation into what types of accidents and their causes are most frequent at certain times of the year and then test if certain accident and their causes are related to the time of year. 
