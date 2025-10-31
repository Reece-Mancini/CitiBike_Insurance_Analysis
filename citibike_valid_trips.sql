SELECT
    *, 
    -- to get day of the week (relevant due to commuting 'seasonality')
    CASE EXTRACT(DOW FROM CAST(started_at AS DATE))
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS day_of_week
FROM
    citibike_consolidated_200k_sample
WHERE
    start_station_id IS NOT NULL
    AND end_station_id IS NOT NULL
    AND start_lat IS NOT NULL
    AND start_lng IS NOT NULL
    AND end_lat IS NOT NULL
    AND end_lng IS NOT NULL;
