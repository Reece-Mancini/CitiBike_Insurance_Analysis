SELECT
    -- Look up the final station name
    (
        SELECT COALESCE(MAX(t.start_station_name), MAX(t.end_station_name))
        FROM citibike_valid_trips AS t
        WHERE t.start_station_id = trips.start_station_id OR t.end_station_id = trips.start_station_id
    ) AS final_station_name,
    COUNT(CASE WHEN w.rain_mm >= 1.0 OR w.wind_speed_kmh >= 25.0 THEN trips.ride_id ELSE NULL END) AS total_trips_adverse,

    -- 2. Count Total trips for the month during NORMAL Weather
    COUNT(CASE WHEN w.rain_mm < 1.0 AND w.wind_speed_kmh < 25.0 THEN trips.ride_id ELSE NULL END) AS total_trips_normal,

    -- 3. Calculate the percentage drop
    (
        (COUNT(CASE WHEN w.rain_mm < 1.0 AND w.wind_speed_kmh < 25.0 THEN trips.ride_id ELSE NULL END) -
        COUNT(CASE WHEN w.rain_mm >= 1.0 OR w.wind_speed_kmh >= 25.0 THEN trips.ride_id ELSE NULL END))
        * 100 / 
        NULLIF(COUNT(CASE WHEN w.rain_mm < 1.0 AND w.wind_speed_kmh < 25.0 THEN trips.ride_id ELSE NULL END), 0)
    ) AS pct_drop_adverse_weather
    
FROM
    citibike_valid_trips AS trips
INNER JOIN
    weather_data AS w ON DATE_TRUNC('hour', trips.started_at) = w.hourly_timestamp
WHERE
    trips.start_station_id IN (
        SELECT station_id
        FROM (
            SELECT station_id, RANK() OVER (ORDER BY total_trip_count DESC) as rnk
            FROM (
                SELECT station_id, SUM(trip_count) AS total_trip_count
                FROM (
                    SELECT start_station_id AS station_id, COUNT(ride_id) AS trip_count FROM citibike_valid_trips GROUP BY 1
                    UNION ALL
                    SELECT end_station_id AS station_id, COUNT(ride_id) AS trip_count FROM citibike_valid_trips GROUP BY 1
                )
                GROUP BY station_id
            )
        )
        WHERE rnk <= 5
    )
GROUP BY
    trips.start_station_id
ORDER BY
    total_trips_normal DESC;
