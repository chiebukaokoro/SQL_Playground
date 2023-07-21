                        /* 8 Weeks SQL Challenge */
                               /* Week One */
--1. What is the total amount each customer spent at the restaurant?
SELECT s.customer_id, SUM(m.price) AS total_amount
  FROM sales AS s
  JOIN menu AS m 
    ON s.product_id = m.product_id
 GROUP BY s.customer_id;

--2. How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT(order_date)) number_of_days_visited
  FROM sales
 GROUP BY customer_id;

--3. What was the first item from the menu purchased by each customer?
/*WITH cte AS (SELECT customer_id, MIN(order_date) first_order_date
  FROM sales 
 GROUP BY customer_id
)
SELECT DISTINCT c.customer_id, c.first_order_date, s.product_id
  FROM cte c
  JOIN sales s
    ON c.customer_id = s.customer_id
  JOIN menu me
    ON s.product_id = me.product_id
 GROUP BY s.customer_id, me.product_name;*/

SELECT TOP 1 s.customer_id, s.order_date, me.product_name
  FROM sales s
  JOIN menu me
    ON s.product_id = me.product_id
 WHERE customer_id = 'A'
 UNION
 SELECT TOP 1 s.customer_id, s.order_date, me.product_name
  FROM sales s
  JOIN menu me
    ON s.product_id = me.product_id
 WHERE customer_id = 'B'
 UNION
 SELECT TOP 1 s.customer_id, s.order_date, me.product_name
  FROM sales s
  JOIN menu me
    ON s.product_id = me.product_id
 WHERE customer_id = 'C';

--4. What is the most purchased item on the menu and 
--how many times was it purchased by all customers?
SELECT TOP 1 me.product_name, COUNT(s.product_id) sales_frequency
  FROM menu me
  JOIN sales s
    ON me.product_id = s.product_id
 GROUP BY me.product_name
 ORDER BY sales_frequency DESC;

--5. Which item was the most popular for each customer?
/*WITH cte AS (SELECT s.customer_id, me.product_name, COUNT(s.product_id) sales_frequency
  FROM menu me
  JOIN sales s
    ON me.product_id = s.product_id
 GROUP BY s.customer_id, me.product_name
)
SELECT DISTINCT(customer_id), product_name, MAX(sales_frequency)
  FROM cte
 GROUP BY customer_id, product_name;*/

/*WITH cte AS (SELECT s.customer_id, me.product_name, COUNT(s.product_id) sales_frequency
  FROM sales s
  JOIN menu me
    ON s.product_id = me.product_id
 --WHERE s.customer_id = 'A'
 GROUP BY s.customer_id, me.product_name
)
SELECT customer_id, MAX(sales_frequency)
  FROM cte
 GROUP BY customer_id;*/

--6. Which item was purchased first by the customer after they became a member?
WITH cte AS (SELECT s.customer_id, MIN(s.order_date) first_membership_purschase
  FROM sales s
  JOIN members m
    ON s.customer_id = m.customer_id
 WHERE s.order_date > m.join_date
 GROUP BY s.customer_id
)
SELECT c.customer_id, c.first_membership_purschase, me.product_name
  FROM cte c
  JOIN sales s
    ON c.customer_id = s.customer_id
  JOIN menu me
    ON s.product_id = me.product_id
 WHERE first_membership_purschase = order_date;

--Which item was purchased just before the customer became a member?
WITH cte AS (SELECT s.customer_id, MAX(s.order_date) last_pre_membership_purschase
  FROM sales s
  JOIN members m
    ON s.customer_id = m.customer_id
 WHERE s.order_date < m.join_date
 GROUP BY s.customer_id
)
SELECT c.customer_id, c.last_pre_membership_purschase, me.product_name
  FROM cte c
  JOIN sales s
    ON c.customer_id = s.customer_id
  JOIN menu me
    ON s.product_id = me.product_id
 WHERE last_pre_membership_purschase = order_date;

--What is the total items and amount spent for each member before they became a member?
WITH cte AS (SELECT s.customer_id, MAX(s.order_date) last_pre_membership_purschase
  FROM sales s
  JOIN members m
    ON s.customer_id = m.customer_id
 WHERE s.order_date < m.join_date
 GROUP BY s.customer_id
)
SELECT c.customer_id, c.last_pre_membership_purschase, COUNT(s.product_id) total_items, 
	   SUM(me.price) amount_spent
  FROM cte c
  JOIN sales s
    ON c.customer_id = s.customer_id
  JOIN menu me
    ON s.product_id = me.product_id
 WHERE last_pre_membership_purschase = order_date
 GROUP BY c.customer_id, c.last_pre_membership_purschase;

--If each $1 spent equates to 10 points and sushi has a 2x points multiplier - 
--how many points would each customer have?
SELECT s.customer_id, 
       SUM(CASE
			WHEN me.product_name = 'sushi' THEN 2*10*me.price
			ELSE 10*me.price
	   END) points
  FROM sales s
  JOIN menu me
    ON s.product_id = me.product_id
 GROUP BY s.customer_id

--In the first week after a customer joins the program (including their join date) 
--they earn 2x points on all items, not just sushi -
--how many points do customer A and B have at the end of January?
SELECT s.customer_id, 
	   --m.join_date,
	   --s.order_date,
       SUM(CASE
			WHEN s.order_date BETWEEN m.join_date AND DATEADD(day, 7, m.join_date) THEN 2*10*me.price
			--ELSE 10*me.price
	   END) points
  FROM menu me
  JOIN sales s
    ON s.product_id = me.product_id
  JOIN members m
    ON m.customer_id = s.customer_id
 WHERE MONTH(s.order_date) = 1 AND s.order_date >= m.join_date
 GROUP BY s.customer_id /*m.join_date, s.order_date*/

 
                                     /* Week One Bonuses */
--BONUS ONE: Join All The Things
SELECT s.customer_id,
	   s.order_date,
	   me.product_name,
	   me.price,
	   CASE
			WHEN s.order_date >= m.join_date THEN 'Y'
			ELSE 'N'
	    END member
  FROM members m
  FULL OUTER JOIN sales s
    ON m.customer_id = s.customer_id
  JOIN menu me
    ON s.product_id = me.product_id
 ORDER BY s.customer_id, s.order_date, me.product_name;

--BONUS TWO
WITH cte AS (
				SELECT s.customer_id,
				s.order_date,
				me.product_name,
				me.price,
				CASE
					WHEN s.order_date >= m.join_date THEN 'Y'
					ELSE 'N'
				END member
			FROM members m
			FULL OUTER JOIN sales s
			ON m.customer_id = s.customer_id
			JOIN menu me
			ON s.product_id = me.product_id
			--ORDER BY s.customer_id, s.order_date, me.product_name
)
 SELECT c.customer_id,
	    c.order_date,
	    c.product_name,
	    c.price,
		c.member,
	    CASE
			 WHEN c.member = 'Y' THEN DENSE_RANK() OVER (
														  PARTITION BY c.customer_id, c.member ORDER BY c.order_date
									  )
			 ELSE NULL
	     END ranking
  FROM cte c;

/*SELECT s.customer_id,
	   s.order_date,
	   me.product_name,
	   me.price,
	  CASE
		  WHEN s.order_date >= m.join_date THEN 'Y'
		  ELSE 'N'
	   END member,
	  CASE
		  WHEN s.order_date >= m.join_date THEN DENSE_RANK() OVER (
													PARTITION BY s.customer_id, 5 ORDER BY s.order_date
													)
		  ELSE NULL
	   END ranking
  FROM members m
  FULL OUTER JOIN sales s
    ON m.customer_id = s.customer_id
  JOIN menu me
    ON s.product_id = me.product_id
 ORDER BY s.customer_id, s.order_date, me.product_name*/
