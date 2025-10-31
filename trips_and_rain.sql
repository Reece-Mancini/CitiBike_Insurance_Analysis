SELECT
    CAST(daily_trips.started_at AS DATE) AS trip_date,
    daily_trips.day_of_week,
    MAX(w_daily.total_rain_mm) AS total_daily_rain_mm, 
    COUNT(daily_trips.ride_id) AS total_trips_per_day
FROM
    citibike_valid_trips AS daily_trips
INNER JOIN 
    weather_data AS w_hourly ON DATE_TRUNC('hour', daily_trips.started_at) = w_hourly.hourly_timestamp 
INNER JOIN
    (
        SELECT
            CAST(hourly_timestamp AS DATE) AS date,
            SUM(rain_mm) AS total_rain_mm 
        FROM
            weather_data
        GROUP BY 1
    ) AS w_daily ON CAST(daily_trips.started_at AS DATE) = w_daily.date
GROUP BY
    1, 2
ORDER BY
  trip_date;




