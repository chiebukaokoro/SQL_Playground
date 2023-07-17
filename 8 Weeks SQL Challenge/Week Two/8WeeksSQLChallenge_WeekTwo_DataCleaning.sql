/* 8 Weeks SQL Challenge - Week 2 Data Cleaning */

-- Change all the blanks, null, NaN to NULL in the customer_orders table
UPDATE pizza_runner.customer_orders
   SET exclusions = NULL
 WHERE exclusions IN ('', 'null');
 
UPDATE pizza_runner.customer_orders
   SET extras = NULL
 WHERE extras IN ('', 'null');
 
SELECT * FROM pizza_runner.customer_orders
 
-- Change all the blanks and null to NULL in the runner_orders table
UPDATE pizza_runner.runner_orders
   SET pickup_time = NULL
 WHERE pickup_time IN ('', 'null');

UPDATE pizza_runner.runner_orders
   SET distance = NULL
 WHERE distance IN ('', 'null');

UPDATE pizza_runner.runner_orders
   SET duration = NULL
 WHERE duration IN ('', 'null');
 
UPDATE pizza_runner.runner_orders
   SET cancellation = NULL
 WHERE cancellation IN ('', 'null');
 
SELECT * FROM pizza_runner.runner_orders;
 
-- Resolving inconsistencies in the distance and duration column of the runner_orders table
UPDATE pizza_runner.runner_orders
   SET distance = '23.4km'
 WHERE distance = '23.4';
 
UPDATE pizza_runner.runner_orders
   SET distance = '10km'
 WHERE distance = '10';
 
SELECT order_id, 
       runner_id, 
       pickup_time,
       SUBSTRING(distance, 1, LENGTH((distance))-2) AS distance_in_km,
       LEFT(duration, 2) AS duration_in_mins
  INTO pizza_runner.runner_orders_cleaned
  FROM pizza_runner.runner_orders;
  
ALTER TABLE  pizza_runner.pizza_recipes_cleaned
ALTER COLUMN toppings TYPE INTEGER USING toppings::integer;
  
SELECT * FROM pizza_runner.runner_orders;

SELECT * FROM pizza_runner.runner_orders_cleaned;
  
-- Change the data type of the pickup_time column from varchar to timestamp
-- Create a temporary TIMESTAMP column
ALTER TABLE pizza_runner.runner_orders_cleaned 
ADD COLUMN pickup_time_holder TIMESTAMP without time zone NULL;

-- Copy casted value over to the temporary column
UPDATE pizza_runner.runner_orders_cleaned 
SET pickup_time_holder = pickup_time::TIMESTAMP;

-- Modify original column using the temporary column
ALTER TABLE pizza_runner.runner_orders_cleaned 
ALTER COLUMN pickup_time TYPE TIMESTAMP without time zone USING pickup_time_holder;

-- Drop the temporary column (after examining altered column values)
ALTER TABLE pizza_runner.runner_orders_cleaned 
DROP COLUMN pickup_time_holder;

SELECT * FROM pizza_runner.runner_orders_cleaned;

-- Checks if the data type have changed from varchar to timestamp
SELECT pg_typeof(pickup_time)
  FROM pizza_runner.runner_orders_cleaned
 LIMIT 1;
 
SELECT pg_typeof(pickup_time)
  FROM pizza_runner.runner_orders
 LIMIT 1;
 
-- Unpivoting the data entries of the pizza_recipes tables
SELECT pizza_id,
       UNNEST(
                STRING_TO_ARRAY(toppings, ',')
       ) AS toppings
  INTO pizza_runner.pizza_recipes_cleaned
  FROM pizza_runner.pizza_recipes;
  
SELECT * FROM pizza_runner.pizza_recipes_cleaned;

SELECT * FROM pizza_runner.pizza_recipes;
  