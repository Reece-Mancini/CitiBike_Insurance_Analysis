SELECT
    CAST(started_at AS DATE) AS trip_date,
    day_of_week, 
    rideable_type,
    COUNT(DISTINCT ride_id) AS insured_trips_count
FROM
    citibike_valid_trips AS daily_trips
GROUP BY
    trip_date,
    day_of_week, 
    rideable_type 
ORDER BY
    trip_date ASC,
    rideable_type;

