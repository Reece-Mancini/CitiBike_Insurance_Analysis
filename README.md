# CitiBike_Insurance_Analysis 

**How to set up and run the analysis** 

I executed my analysis using DuckDB as the analytical engine. My only use for Python was for data extraction and transformation (ETL). I used a Python script to fetch the last month (September 2025) of trip data, but since the raw file was too large, I sampled 200K rows to create a manageable CSV (100mb). My script also called the Open-Meteo API to pull the hourly temperature, wind, and rainfall data. The resultant CSV files were small enough to upload directly to my BI tool—in this case I used Count—and data cleaning was conducted in that environment. After eyeballing the data, I ran uniqueness and null tests. The trips data had about 500K rows with null station IDs/names. I decided to exclude those rows for now, which was fine since it barely affected my 200K sample. I also enriched the data by adding a day of week column to track trends.

**Approach**

All subsequent analysis was done with SQL in the Count (also DuckDB powered) environment. 

**Key insights**

1. Weather is a Built-In Revenue Hedge

My analysis shows that while adverse weather immediately reduces volume (when rain spikes past 1.0mm, ridership takes a hit, the system's revenue actually holds up because the 20% weather multiplier generates more earnings than the volume we lose. This means the current pricing model has a built-in hedge against bad weather risk.

2. The Member/Casual Premium Gap is Critical

The average premium calculation confirms that covering Casual riders is slightly more expensive (R19.79 per trip) than covering Members (R19.60). This marginal difference is significant for the model:Casuals are the higher-risk group, more likely to use the premium R20 Electric bikes and ride during weather-affected periods, driving their average cost up.The business is smartly using a small, effective premium discount for loyal Members.

3. Strategic Recommendation: Increase Winter Rates

Based on the predictability of the Member base, I should recommend reducing the effective discount for Members by slightly increasing their base premium. This secures more reliable revenue. However, to be $100\%$ sure, I need better data—specifically, trip duration and distance—to calculate the insurer's full exposure time rather than just using a flat premium per trip.

**If I had more time**

I would create a full dates table so that I can easily join it to the sampled data and query the dataset at different levels of data aggregation (date, week, month, year).

I would implement a true Commuter vs. Leisure trip type classification (by analyzing trip start/end times during rush hour vs. midday/weekend) to test the assumption that Members equal commuters.

I would retrieve and analyse data over a long period, i.e. going all the way back to September 2023. It would help me identify trends in seasonality and also see how CitiBike has changed their insurance pricing over time. 

**How we could improve this challenge** 

To improve the challenge, I would use a more disparate set of stations (maybe including areas surrounding Manhattan) to get a broader range of weather patterns for the same day. This would force a more complex correlation between weather and pricing.


**PART A** 

1. SQL is fast, universal and reliable. It's the standard for all relational data and can plug into very major BI tool out there. 

2. First thing I'd do is eyeball the data to check for anomalies and just familiarise myself with it. After that, I'd run some standard uniqueness tests (see that there's no duplicate unique ids like ride_id in this case. I would look for nulls and blanks, and try to ascertain why they may exist and then decide whether to exclude or include them in my analysis. Further than that, I'd do some validity check like looking at trip duration, making sure there are no negative trip durations or a duration that seems too short to be true. 

3. To ensure reproducability, I make sure my SQL is standardised and easy to follow. Commenting in between lines of SQL to explain more complex CTEs and logic is necessary so that others can follow my line of thinking. I'd store all code in Git for version control and make sure I use dynamic logic wherever I can instead of harcoding things like dates. 

4. If my results change, I'd typically default to checking the raw data first — is it up to date, is there anything in my data pipeline that's failing tests of uniqueness or null values. I'd then rerun some of the standard checks I mentioned in question 2. I'd also considered external factors like public holidays, extreme weather or major events in the city. 
   

**PART C**

The premium calculation shows that covering Casual riders is more expensive than covering Members. The average premium for Casuals hits R19.79 per trip, while Members hover just below at R19.60. That marginal difference, while tiny, is huge for our model. It confirms that Casuals—the unpredictable crowd—are more likely to grab those R20 Electric bikes or ride during weather-affected periods, driving their average cost up. For the business, this is gold: we're already giving our loyal Members a small, effective discount, which is smart for locking in steady subscription revenue, all while we correctly charge the higher-risk, less reliable Casual market slightly more per ride. 

The analysis shows adverse weather reduces volume, but a major cash injection for premiums. We found that whenever the rain spikes past 1.0mm, overall ridership immediately takes a hit. However, the system's revenue actually holds up because the 20% weather multiplier generates more earnings than the volume we lose. This means the pricing model has a built-in hedge against bad weather. Looking at seasonal shifts, we should expect the average premium to climb higher in Winter. Why? Because we'll see more frequent bad weather days, constantly triggering that 20% multiplier. Even though overall leisure riding will vanish, the dedicated Member commuters who rely on the service will keep the revenue stable through the cold months. 

Based on typical NYC behavior, here are the smart bets. Summer is all about Casuals—tourists and weekend fun—so we should see lighter demand during the workday. Winter, however, is all about the Members, focusing on reliable, straight-shot commuting. Based on this, we should recommend reducing the discount for Members, or perhaps even increasing their base premium slightly, since their usage is the most predictable and reliable during high-cost weather periods. To be 100% sure about all this, we need better data. We have to ditch the assumption that Members equal commuters and get granular data on Commuter vs. Leisure trip type. We also need to know about work-from-home schedules in NYC to truly understand why trip volume fluctuates on weekdays. Most importantly, getting trip duration and distance would let us actually calculate the insurer's full exposure time, rather than just using a flat premium per trip.


**VISUALISATIONS**

**Weather vs. Volume and Premiums:** 
This chart shows how the 20% multiplier acts as a hedge against volume drops during adverse Weather.
<img width="6976" height="1792" alt="image" src="https://github.com/user-attachments/assets/4c5cd061-1fda-464d-b90f-488e80d0cb58" />

**Rainfall vs. Ridership:**
This plot directly illustrates the inverse relationship: when rain spikes, overall ridership immediately drops.
<img width="5280" height="1120" alt="image" src="https://github.com/user-attachments/assets/313b5ad7-d60b-423a-bdfd-b3dd84c84146" />


