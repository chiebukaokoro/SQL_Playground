                                /* 8 Weeks of SQL Challenge - Week 2 */
                             /* Case B: Runner and Customer Experience */
--1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT EXTRACT(ISOYEAR FROM registration_date) AS ISO8601_year, 
       EXTRACT(WEEK FROM registration_date) AS ISO8601_week_num_sign_up, 
       COUNT(*) AS num_of_sign_ups
  FROM pizza_runner.runners
 GROUP BY 1, 2
 
--2. What was the average time in minutes it took for each runner 
--to arrive at the Pizza Runner HQ to pickup the order?

SELECT runner_id, EXTRACT(MINUTE FROM AVG(r.pickup_time - c.order_time)) AS average_pickup_time
  FROM pizza_runner.runner_orders_cleaned AS r
  JOIN pizza_runner.customer_orders AS c
 USING (order_id)
 GROUP BY 1;

SELECT runner_id, AVG(r.pickup_time - c.order_time) AS average_pickup_time
  FROM pizza_runner.runner_orders_cleaned AS r
  JOIN pizza_runner.customer_orders AS c
 USING (order_id)
 GROUP BY 1;
/*WITH cte AS (
              SELECT runner_id, order_id, TO_TIMESTAMP(pickup_time, 'YYYY-MM-DD HH24:MI:SS') AS new_pickup_timestamp
                FROM pizza_runner.runner_orders
)
SELECT r.runner_id, AVG(new_pickup_timestamp, c.order_time) AS diff
  FROM pizza_runner.customer_orders AS c
  JOIN pizza_runner.runner_orders AS r 
 USING (order_id)
 GROUP BY 1*/
 
--3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT c.order_id,COUNT(c.order_id), AVG(r.pickup_time - c.order_time) AS average_pickup_time
  FROM pizza_runner.runner_orders_cleaned AS r
  JOIN pizza_runner.customer_orders AS c
 USING (order_id)
 GROUP BY 1;

-- There is relationsgip that exist between the nember of order and 
-- how long it takes to prepare is that of direct proportionality.

--4. What was the average distance travelled for each customer?
SELECT c.customer_id, 
       ROUND(AVG(r.distance_in_km), 2) AS dist_trav_in_km
  FROM pizza_runner.customer_orders AS c
  JOIN pizza_runner.runner_orders_cleaned AS r 
 USING (order_id)
 GROUP BY 1;
 
--5. What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX(duration_in_mins) - MIN(duration_in_mins) AS duration_range_in_mins
  FROM pizza_runner.runner_orders_cleaned;
  
--6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT AVG(distance_in_km/duration_in_mins) AS average_speed_in_km_per_mins
  FROM pizza_runner.runner_orders_cleaned;
  
--7. What is the successful delivery percentage for each runner?
/*SELECT runner_id, (SELECT COUNT(*)
                    FROM pizza_runner.runner_orders_cleaned
                   WHERE pickup_time IS NOT NULL
                   )/ COUNT(*) * 100 AS percentage_succesful_delivery
  FROM pizza_runner.runner_orders_cleaned
 GROUP BY 1;*/
 
WITH num_of_successful_delivery AS (
SELECT runner_id, COUNT(*) AS num
  FROM pizza_runner.runner_orders_cleaned
 WHERE pickup_time IS NOT NULL
 GROUP BY 1
)
 
SELECT r.runner_id, ROUND((n.num::DECIMAL(4,2)/COUNT(r.*))*100, 2) AS percentage_succesful_delivery
  FROM pizza_runner.runner_orders_cleaned AS r
  JOIN num_of_successful_delivery AS n 
 USING (runner_id)
 GROUP BY 1, n.num
 