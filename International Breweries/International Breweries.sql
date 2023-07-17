-- INTERNATIONAL BREWERIES TASK

/*1. Within the space of the last three years, what was the profit worth of the breweries, inclusive of the anglophone and the francophone territories?*/
SELECT SUM(profit) past_3_years_profit
FROM internationalbreweries;

/*2. Compare the total profit between these two territories in order for the territory manager, Mr. Stone made a strategic decision that will aid profit maximization in 2020.*/
SELECT territory, SUM(profit) profit
FROM internationalbreweries
GROUP BY territory
ORDER BY profit DESC;

/*3. Country that generated the highest profit in 2019*/
SELECT DISTINCT countries, SUM(profit) profit
FROM internationalbreweries
WHERE years = 2019
GROUP BY countries
ORDER BY profit DESC
LIMIT 1;

/*4. Help him find the year with the highest profit.*/
SELECT DISTINCT years, SUM(profit) profit
FROM internationalbreweries
GROUP BY years
ORDER BY profit DESC
LIMIT 1;

/*5. Which month in the three years was the least profit generated?*/
SELECT years, months, MIN(profit) profit
FROM internationalbreweries
GROUP BY years, months
ORDER BY profit
LIMIT 1;

/*6. What was the minimum profit in the month of December 2018?*/
SELECT MIN(profit) min_profit
FROM internationalbreweries
WHERE months = 'December' AND years = 2018;

/*7. Compare the profit in percentage for each of the month in 2019*/
SELECT month_number, 
       months,
       ROUND(
           (CAST((SUM(profit) * 100) AS DECIMAL(12, 2)) / 
            (
                SELECT SUM(profit)
                FROM internationalbreweries
                WHERE years = 2019
            )
           ), 2
       ) AS profit_percentage,
       LAG(
        ROUND(
            (CAST((SUM(profit) * 100) AS DECIMAL(12, 2)) / 
             (
                  SELECT SUM(profit)
                  FROM internationalbreweries
                  WHERE years = 2019
             )
            ), 2
        )
    ) OVER (ORDER BY month_number) AS last_month_profit_percentage
FROM internationalbreweries
WHERE years = 2019
GROUP BY month_number, months
ORDER BY month_number;

/*8. Which particular brand generated the highest profit in Senegal?*/
SELECT brands, SUM(profit) profit
FROM internationalbreweries
WHERE countries = 'Senegal'
GROUP BY brands
ORDER BY profit DESC
LIMIT 1;

/*9. Within the last two years, the brand manager wants to know the top three brands consumed in the francophone countries*/
SELECT brands, SUM(quantity) numbers_consumed
FROM internationalbreweries
WHERE territory = 'Francophone' AND Years BETWEEN 2018 AND 2019
GROUP BY brands
ORDER BY numbers_consumed DESC
LIMIT 3;

/*10. Find out the top two choice of consumer brands in Ghana*/
SELECT brands, SUM(quantity) numbers_consumed
FROM internationalbreweries
WHERE countries = 'Ghana' 
GROUP BY brands
ORDER BY numbers_consumed DESC
LIMIT 2;

/*11. Find out the details of beers consumed in the past three years in the most oil reached country in West Africa.*/
SELECT sales_rep, brands, SUM(quantity) quantity, SUM(cost) cost, SUM(profit) profit
FROM internationalbreweries
WHERE countries = 'Nigeria' AND category = 'Beer'
GROUP BY sales_rep, brands;

/*12. Favorites malt brand in Anglophone region between 2018 and 2019*/
SELECT brands, SUM(quantity) numbers_consumed
FROM internationalbreweries
WHERE category = 'Malt' AND territory = 'Anglophone' AND years BETWEEN 2018 AND 2019
GROUP BY brands
ORDER BY numbers_consumed DESC
LIMIT 1;

/*13. Which brands sold the highest in 2019 in Nigeria?*/
SELECT brands, SUM(quantity) numbers_sold
FROM internationalbreweries
WHERE countries = 'Nigeria' AND years = 2019
GROUP BY brands
ORDER BY numbers_sold DESC
LIMIT 1;

/*14. Favorites brand in South_South region in Nigeria*/
SELECT brands, SUM(quantity) numbers_sold
FROM internationalbreweries
WHERE countries = 'Nigeria' AND region = 'southsouth'
GROUP BY brands
ORDER BY numbers_sold DESC
LIMIT 1;

/*15. Bear consumption in Nigeria.*/
SELECT countries, category, SUM(quantity) quantity
FROM internationalbreweries
WHERE countries = 'Nigeria' AND category = 'Beer'
GROUP BY 1, 2;

/*16. Level of consumption of Budweiser in the regions in Nigeria*/
SELECT countries, region, brands, SUM(quantity) quantity
FROM internationalbreweries
WHERE countries = 'Nigeria' AND brands = 'budweiser'
GROUP BY 1, 2, 3;

/*17. Level of consumption of Budweiser in the regions in Nigeria in 2019 (Decision on Promo)*/
SELECT countries, region, brands, SUM(quantity) quantity
FROM internationalbreweries
WHERE countries = 'Nigeria' AND brands = 'budweiser' AND years = 2019
GROUP BY 1, 2, 3;

/*18. Country with the highest consumption of beer.*/
SELECT countries, SUM(quantity) quantity, category
FROM internationalbreweries
WHERE category = 'Beer'
GROUP BY 1, 3
ORDER BY 2 DESC
LIMIT 1;

/*19. Highest sales personnel of Budweiser in Senegal*/
SELECT sales_rep, countries, brands, SUM(quantity) quantity, SUM(profit) profit
FROM internationalbreweries
WHERE countries = 'Senegal' AND brands = 'budweiser'
GROUP BY 1, 2, 3
ORDER BY 4 DESC
LIMIT 1;

/*20. Country with the highest profit of the fourth quarter in 2019*/
SELECT countries, SUM(profit) profit
FROM internationalbreweries
WHERE years = 2019 AND months IN ('October', 'November', 'December')
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

SELECT * FROM internationalbreweries