SELECT
    station_rank,
    (
        SELECT COALESCE(MAX(daily_trips.start_station_name), MAX(daily_trips.end_station_name))
        FROM citibike_valid_trips AS daily_trips
        WHERE daily_trips.start_station_id = ranked_stations.station_id OR daily_trips.end_station_id = ranked_stations.station_id
    ) AS final_station_name, 
    total_trip_count
FROM
    (
        SELECT
            station_id,
            total_trip_count,
            RANK() OVER (ORDER BY total_trip_count DESC) AS station_rank
        FROM
            (
                SELECT
                    station_id,
                    SUM(trip_count) AS total_trip_count
                FROM
                    (
                        SELECT start_station_id AS station_id, COUNT(ride_id) AS trip_count FROM citibike_valid_trips GROUP BY 1
                        UNION ALL
                        SELECT end_station_id AS station_id, COUNT(ride_id) AS trip_count FROM citibike_valid_trips GROUP BY 1
                    ) AS station_usage_raw
                GROUP BY
                    station_id
            ) AS station_totals
    ) AS ranked_stations
WHERE
    ranked_stations.station_rank <= 5 
ORDER BY
    ranked_stations.station_rank ASC;

