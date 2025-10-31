SELECT
    t.member_casual,
    -- Multiply the final average by 100 for display
    (AVG(t.daily_premium) * 100) AS average_premium_per_trip_cents
FROM
    (
        -- [The inner CTE calculating daily_premium remains unchanged]
        SELECT
            trips.member_casual,
            trips.day_of_week, 
            weather.rain_mm,
            weather.wind_speed_kmh,
            
            CASE
                WHEN trips.rideable_type = 'classic_bike' THEN 0.15 
                WHEN trips.rideable_type = 'electric_bike' THEN 0.20 
                ELSE 0.00
            END AS base_rate,

            CASE
                WHEN weather.rain_mm >= 1.0 OR weather.wind_speed_kmh >= 25.0
                THEN 1.2
                ELSE 1.0
            END AS adjustment_multiplier,

            (base_rate * adjustment_multiplier) AS daily_premium

        FROM
            citibike_valid_trips AS trips
        INNER JOIN
            weather_data AS weather ON CAST(trips.started_at AS DATE) = weather.hourly_timestamp
    ) AS t
GROUP BY
    t.member_casual
ORDER BY
    average_premium_per_trip_cents DESC;
