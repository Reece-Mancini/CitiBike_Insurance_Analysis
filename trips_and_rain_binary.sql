WITH Daily_Trip_Counts AS (
    SELECT
        CAST(started_at AS DATE) AS trip_date,
        COUNT(ride_id) AS total_trips_per_day
    FROM
        citibike_valid_trips
    GROUP BY
        1
),
Daily_Rain_Aggregates AS (
    -- CTE 2: Aggregates the hourly weather data to the Daily level
    SELECT
        CAST(hourly_timestamp AS DATE) AS trip_date,
        SUM(rain_mm) AS total_daily_rain_mm
    FROM
        weather_data
    GROUP BY
        1
)
-- Final Select: Categorize and average based on the Daily aggregates
SELECT
    CASE 
        WHEN dra.total_daily_rain_mm >= 1.0 THEN '1. Rainy Days (>= 1.0 mm)'
        ELSE '2. Non-Rainy Days (< 1.0 mm)'
    END AS rainfall_category,
    
    -- Count the number of unique days in each category
    COUNT(dtc.trip_date) AS total_days_in_category,
    AVG(dtc.total_trips_per_day) AS avg_daily_trip_count  
    
FROM
    Daily_Trip_Counts AS dtc
INNER JOIN
    Daily_Rain_Aggregates AS dra ON dtc.trip_date = dra.trip_date
GROUP BY
    rainfall_category
ORDER BY
    rainfall_category DESC;

