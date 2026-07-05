-- Overall satisfaction rate
SELECT satisfaction
  ,COUNT(*) AS passengers
  ,ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM `analytics-project-499406.sql_practice.airline_passenger_satisfaction`
GROUP BY 1;

-- Overall satisfaction rate by customer type (First-time, Returning)
SELECT
    customer_type
    ,COUNT(CASE WHEN satisfaction = 'Satisfied' THEN 1 END) AS satisfied_count
    ,COUNT(*) AS total_count,
    ROUND(
        COUNT(CASE WHEN satisfaction = 'Satisfied' THEN 1 END) * 100
        / COUNT(*), 2
    ) AS satisfaction_rate
FROM `analytics-project-499406.sql_practice.airline_passenger_satisfaction`
GROUP BY customer_type
ORDER BY satisfaction_rate DESC;

-- Overall satisfaction rate by class (Business, Economy Plus, Economy)
SELECT class
  ,COUNT(CASE WHEN satisfaction = 'Satisfied' THEN 1 END) AS satisfied_count
  ,COUNT(*) AS total_count
  ,ROUND(
      COUNT(CASE WHEN satisfaction = 'Satisfied' THEN 1 END) * 100
      / COUNT(*), 2
  ) AS satisfaction_rate
FROM `analytics-project-499406.sql_practice.airline_passenger_satisfaction`
GROUP BY 1
ORDER BY 3 DESC;

--  Overall satisfaction rate by travel type (Business, Personal)
SELECT type_of_travel
  ,COUNT(CASE WHEN satisfaction = 'Satisfied' THEN 1 END) AS satisfied_count
  ,COUNT(*) AS total_count
  ,ROUND(
      COUNT(CASE WHEN satisfaction = 'Satisfied' THEN 1 END) * 100
      / COUNT(*), 2
  ) AS satisfaction_rate
FROM `analytics-project-499406.sql_practice.airline_passenger_satisfaction`
GROUP BY 1
ORDER BY 3 DESC;

-- Customer profile for a repeating airline passenger
SELECT
    customer_type,
    COUNT(*) AS total_count,
    ROUND(COUNT(*) / SUM(COUNT(*)) OVER() * 100, 1) AS pct_of_base,
    ROUND(AVG(age), 0) AS avg_age,
    -- Travel type mix within each customer type
    ROUND(COUNT(CASE WHEN type_of_travel = 'Business' THEN 1 END) * 100.0
        / COUNT(*), 1) AS pct_business_travel,
    ROUND(COUNT(CASE WHEN type_of_travel = 'Personal' THEN 1 END) * 100.0
        / COUNT(*), 1) AS pct_personal_travel,
    -- Class mix within each customer type
    ROUND(COUNT(CASE WHEN class = 'Business' THEN 1 END) * 100.0
        / COUNT(*), 1) AS pct_business_class,
    ROUND(COUNT(CASE WHEN class = 'Economy' THEN 1 END) * 100.0
        / COUNT(*), 1) AS pct_economy_class,
    ROUND(COUNT(CASE WHEN class = 'Economy Plus' OR class = 'Economy' THEN 1 END) * 100.0
        / COUNT(*), 1) AS pct_general_economy_class
FROM `analytics-project-499406.sql_practice.airline_passenger_satisfaction`
GROUP BY customer_type
ORDER BY total_count DESC;

-- Which factors contribute to customer satisfaction the most?
WITH corr_scores AS (
    SELECT
        ROUND(CORR(departure_and_arrival_time_convenience,
            CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END), 3) AS departure_and_arrival_time_convenience,
        ROUND(CORR(ease_of_online_booking,
            CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END), 3) AS ease_of_online_booking,
        ROUND(CORR(checkin_service,
            CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END), 3) AS checkin_service,
        ROUND(CORR(online_boarding,
            CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END), 3) AS online_boarding,
        ROUND(CORR(gate_location,
            CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END), 3) AS gate_location,
        ROUND(CORR(onboard_service,
            CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END), 3) AS onboard_service,
        ROUND(CORR(seat_comfort,
            CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END), 3) AS seat_comfort,
        ROUND(CORR(leg_room_service,
            CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END), 3) AS leg_room_service,
        ROUND(CORR(cleanliness,
            CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END), 3) AS cleanliness,
        ROUND(CORR(food_and_drink,
            CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END), 3) AS food_and_drink,
        ROUND(CORR(inflight_service,
            CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END), 3) AS inflight_service,
        ROUND(CORR(inflight_wifi_service,
            CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END), 3) AS inflight_wifi_service,
        ROUND(CORR(inflight_entertainment,
            CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END), 3) AS inflight_entertainment,
        ROUND(CORR(baggage_handling,
            CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END), 3) AS baggage_handling
    FROM `analytics-project-499406.sql_practice.airline_passenger_satisfaction`
)

SELECT factor, correlation
FROM corr_scores
UNPIVOT (correlation FOR factor IN (
    departure_and_arrival_time_convenience,
    ease_of_online_booking,
    checkin_service,
    online_boarding,
    gate_location,
    onboard_service,
    seat_comfort,
    leg_room_service,
    cleanliness,
    food_and_drink,
    inflight_service,
    inflight_wifi_service,
    inflight_entertainment,
    baggage_handling
))
ORDER BY correlation DESC;

-- Does flight distance affect customer preferences or flight patterns?
SELECT
    customer_type,
    CASE
        WHEN flight_distance < 500  THEN '<500 miles'
        WHEN flight_distance < 1000 THEN '500-1000 miles'
        WHEN flight_distance < 2000 THEN '1000-2000 miles'
        ELSE '>2000 miles'
    END AS flight_distance_band,
    COUNT(CASE WHEN satisfaction = 'Satisfied' THEN 1 END) AS satisfied_count,
    COUNT(*) AS total_count,
    ROUND(
        COUNT(CASE WHEN satisfaction = 'Satisfied' THEN 1 END) * 100.0
        / COUNT(*), 2
    ) AS satisfaction_rate
FROM `analytics-project-499406.sql_practice.airline_passenger_satisfaction`
GROUP BY 1, 2
ORDER BY 1, 2;

SELECT customer_type
  ,departure_delay_bucket
  ,COUNT(CASE WHEN satisfaction = 'Satisfied' THEN 1 END) AS satisfied_count,
    COUNT(*) AS total_count,
    ROUND(
        COUNT(CASE WHEN satisfaction = 'Satisfied' THEN 1 END) * 100.0
        / COUNT(*), 2
    ) AS satisfaction_rate
FROM `analytics-project-499406.sql_practice.airline_passenger_satisfaction`
GROUP BY 1, 2
ORDER BY 1, 2;

SELECT customer_type
  ,arrival_delay_bucket
  ,COUNT(CASE WHEN satisfaction = 'Satisfied' THEN 1 END) AS satisfied_count,
    COUNT(*) AS total_count,
    ROUND(
        COUNT(CASE WHEN satisfaction = 'Satisfied' THEN 1 END) * 100.0
        / COUNT(*), 2
    ) AS satisfaction_rate
FROM `analytics-project-499406.sql_practice.airline_passenger_satisfaction`
GROUP BY 1, 2
ORDER BY 1, 2;
