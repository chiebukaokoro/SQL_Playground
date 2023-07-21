                                /* 8 Weeks of SQL Challenge - Week 2 */
                                     /* Case A: Pizza Metrics */

-- 1. How many pizzas were ordered?
SELECT COUNT(order_id) AS number_of_ordered_pizza
  FROM pizza_runner.customer_orders;
-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS unique_number_of_ordered_pizza
  FROM pizza_runner.customer_orders;
-- 3. How many successful orders were delivered by each runner?
SELECT runner_id,
       COUNT(runner_id) AS number_of_successful_delivery
  FROM pizza_runner.runner_orders
 WHERE duration <> 'null'
 GROUP BY 1;
 
                       --OR
SELECT runner_id,
       COUNT(runner_id) AS number_of_successful_delivery
  FROM pizza_runner.runner_orders
 WHERE duration NOT IN ('null', '')
 GROUP BY 1;
-- 4. How many of each type of pizza was delivered?
SELECT p.pizza_name,
       COUNT(c.pizza_id) AS number_of_pizza_delivered
  FROM pizza_runner.pizza_names AS p
  JOIN pizza_runner.customer_orders AS c USING (pizza_id)
  JOIN pizza_runner.runner_orders AS r USING (order_id)
 WHERE r.duration <> 'null'
 GROUP BY 1;
-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT c.customer_id,
       p.pizza_name,
       COUNT(c.order_id) AS number_of_orders
  FROM pizza_runner.pizza_names AS p
  JOIN pizza_runner.customer_orders AS c USING (pizza_id)
 GROUP BY 1, 2
 ORDER BY 1;
-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT MAX(number_of_orders) AS max_of_single_delivery
  FROM (SELECT order_id,
               COUNT(order_id) AS number_of_orders
          FROM pizza_runner.customer_orders
         GROUP BY 1) AS num_orders
        
                     --OR

SELECT order_id, MAX(number_of_orders) AS max_of_single_delivery
  FROM (SELECT order_id,
               COUNT(order_id) AS number_of_orders
          FROM pizza_runner.customer_orders
         GROUP BY 1) AS num_orders
 GROUP BY 1        
 ORDER BY 2 DESC
 LIMIT 1;


                     --OR

WITH num_orders AS (
    SELECT order_id,
           COUNT(order_id) AS number_of_orders
      FROM pizza_runner.customer_orders
     GROUP BY 1) 
SELECT order_id, MAX(number_of_orders) AS max_of_single_delivery
  FROM num_orders
 GROUP BY 1        
 ORDER BY 2 DESC
 LIMIT 1;
        
-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT customer_id,
       COUNT(CASE
                  WHEN exclusions NOT IN ('null', '') OR extras NOT IN ('null', '') THEN 'changes'
             END
            ) AS changes,
       COUNT(CASE
                  WHEN exclusions IN ('null', '') AND extras IN ('null', '') THEN 'no_changes'
            END
            ) AS no_changes
  FROM pizza_runner.customer_orders as c
  JOIN pizza_runner.runner_orders AS r USING (order_id)
 WHERE r.duration NOT IN ('null', '')
 GROUP BY 1
          


/*WITH cte1 AS (
        SELECT *
          FROM pizza_runner.customer_orders
         WHERE exclusions NOT IN ('null', '') OR extras NOT IN ('null', '')
),
cte2 AS (
        SELECT *
          FROM pizza_runner.customer_orders
         WHERE exclusions IN ('null', '') AND extras IN ('null', '')
)
SELECT c.customer_id, COUNT(ct1.customer_id) AS changes, COUNT(ct2.customer_id) AS no_changes
  FROM pizza_runner.customer_orders AS c
  JOIN cte1 AS ct1 USING (order_id)
  JOIN cte2 AS ct2 USING (order_id)
  JOIN pizza_runner.runner_orders AS r USING (order_id)
 WHERE r.duration NOT IN ('null', '')
 GROUP BY 1

SELECT customer_id,
       (
         SELECT COUNT(*)
           FROM pizza_runner.customer_orders
          WHERE exclusions NOT IN ('null', '') OR extras NOT IN ('null', '')
        ) AS changes,
       (
         SELECT COUNT(*)
           FROM pizza_runner.customer_orders
          WHERE exclusions IN ('null', '') AND extras IN ('null', '')
       ) AS no_changes
  FROM pizza_runner.customer_orders
  JOIN pizza_runner.runner_orders AS r USING (order_id)
 WHERE r.duration NOT IN ('null', '')
 GROUP BY 1*/
 
-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(*) number_of_pizza_with_exclusions_and_extras
  FROM (SELECT *
          FROM pizza_runner.customer_orders
         WHERE exclusions NOT IN ('null', '') AND extras NOT IN ('null', '')) AS exclusions_and_extras
  JOIN pizza_runner.runner_orders AS r USING (order_id)
 WHERE r.duration NOT IN ('null', '')
 
                             --OR
                             
 SELECT COUNT(c.order_id) AS number_of_successful_delivery
  FROM pizza_runner.runner_orders AS r
  JOIN pizza_runner.customer_orders AS c USING (order_id)
 WHERE r.duration NOT IN ('null', '') AND c.exclusions NOT IN ('null', '') AND c.extras NOT IN ('null', '');
-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT DATE(order_time) as order_day,
       EXTRACT(HOUR FROM order_time) as order_hour,
       COUNT(order_id) as total_order
  FROM pizza_runner.customer_orders
 GROUP BY 1, 2
 ORDER BY 1;
-- 10. What was the volume of orders for each day of the week?
SELECT DATE(order_time) as order_day,
       EXTRACT(DOW FROM order_time) as order_dow,
       COUNT(order_id) as total_order
  FROM pizza_runner.customer_orders
 GROUP BY 1, 2
 ORDER BY 1;
--N.B: The day of the week as Sunday (0) to Saturday (6)

/*SELECT DATE(order_time) as order_day,
       EXTRACT(ISODOW FROM order_time) as order_dow,
       COUNT(order_id) as total_order
  FROM pizza_runner.customer_orders
 GROUP BY 1, 2
 ORDER BY 1;
--N.B: The day of the week as Monday (1) to Sunday (7)*/