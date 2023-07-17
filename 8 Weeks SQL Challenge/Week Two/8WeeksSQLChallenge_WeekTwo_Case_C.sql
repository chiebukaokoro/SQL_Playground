                                /* 8 Weeks of SQL Challenge - Week 2 */
                                 /* Case C: Ingredient Optimisation */

-- 1. What are the standard ingredients for each pizza?
SELECT pizza_name, topping_name
  FROM pizza_runner.pizza_names
  JOIN pizza_runner.pizza_recipes_cleaned
 USING (pizza_id)
  JOIN pizza_runner.pizza_toppings
    ON toppings = topping_id
 ORDER BY 1,2;
    
-- 2. What was the most commonly added extra?
-- SOLN 1:
WITH cte AS (
    SELECT pizza_id,
           CAST(UNNEST(
                STRING_TO_ARRAY(extras, ',')
           ) AS INT) AS extras
      FROM pizza_runner.customer_orders
)  
SELECT t.topping_name, 
       COUNT(ct.extras) AS toppings
  FROM pizza_runner.pizza_toppings AS t
  JOIN cte AS ct
    ON ct.extras = t.topping_id
 GROUP BY 1
 ORDER BY 2 DESC
 LIMIT 1;

-- SOLN 2:
WITH cte AS (
    SELECT pizza_id,
           UNNEST(
                STRING_TO_ARRAY(extras, ',')
           )::INT AS extras
      FROM pizza_runner.customer_orders
)  
SELECT t.topping_name, 
       COUNT(ct.extras) AS toppings
  FROM pizza_runner.pizza_toppings AS t
  JOIN cte AS ct
    ON ct.extras = t.topping_id
 GROUP BY 1
 ORDER BY 2 DESC
 LIMIT 1;
   
-- 3. What was the most common exclusion?
WITH cte AS (
    SELECT pizza_id,
           UNNEST(
                STRING_TO_ARRAY(exclusions, ',')
           )::INT AS exclusions
      FROM pizza_runner.customer_orders
)  
SELECT t.topping_name, 
       COUNT(ct.exclusions) AS toppings
  FROM pizza_runner.pizza_toppings AS t
  JOIN cte AS ct
    ON ct.exclusions = t.topping_id
 GROUP BY 1
 ORDER BY 2 DESC
 LIMIT 1;
 
-- 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
      /*Meat Lovers
        Meat Lovers - Exclude Beef
        Meat Lovers - Extra Bacon
        Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers*/
-- 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order 
-- from the customer_orders table and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
