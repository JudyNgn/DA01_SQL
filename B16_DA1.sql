--ex1
WITH 
organize AS (
    SELECT 
        customer_id,
        delivery_id,
        order_date,
        customer_pref_delivery_date,
        CASE
            WHEN order_date = customer_pref_delivery_date THEN 'immediate'
            ELSE 'scheduled'
        END AS schedule,
        ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date ASC) AS rn
    FROM Delivery
    ORDER BY customer_id
),
firstorder AS (
    SELECT 
        customer_id,
        delivery_id,
        order_date,
        schedule
    FROM organize
    WHERE rn = 1
)

SELECT 
    ROUND((SUM(CASE WHEN schedule = 'immediate' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS immediate_percentage
FROM firstorder;

--ex2
with cte as(
    select player_id as player_id_1,
    event_date as cur,
    lead(event_date,1) over(PARTITION BY player_id ORDER BY event_date) as 'next',                            
    FIRST_VALUE(event_date) over(PARTITION BY player_id  ORDER BY event_date) as 'fir'                        
    from Activity
)
  
select round(count(distinct player_id_1)
/(select count(distinct player_id) from Activity),2) as fraction  
from cte
where cur + interval 1 day=next and cur=fir;

--ex3
SELECT 
CASE 
    WHEN id = (SELECT MAX(id) FROM seat) AND id % 2 = 1
            THEN id 
    WHEN id % 2 = 1
            THEN id + 1
    ELSE id - 1
END AS id,
student
FROM seat
ORDER BY id

--ex4
WITH cte1 as
(SELECT 
visited_on, 
SUM(amount) as total_amount
FROM Customer
GROUP BY visited_on),

cte2 as 
(SELECT 
visited_on, 
SUM(total_amount) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as amount, 
ROUND(AVG(total_amount) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) as average_amount
FROM cte1)

SELECT *
FROM cte2
WHERE visited_on >= (SELECT visited_on FROM Customer ORDER BY visited_on LIMIT 1) + 6
ORDER BY visited_on

--ex5
WITH TIV_2015_Duplicates AS (
    SELECT tiv_2015 
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(DISTINCT pid) > 1
),
Unique_Locations AS (
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(pid) = 1
)
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN (SELECT tiv_2015 FROM TIV_2015_Duplicates)
AND (lat, lon) IN (SELECT lat, lon FROM Unique_Locations);

--ex6
WITH ranking as (
SELECT 
    d.name AS Department,
    e.name AS Employee,
    e.salary,
    DENSE_RANK() OVER (PARTITION BY d.name ORDER BY e.salary DESC) AS SalaryRank
FROM 
    employee AS e
JOIN 
    department AS d ON e.departmentId = d.id)

select 
Department,
Employee,
salary
from ranking
where SalaryRank <= 3

--ex7
with sum as(
SELECT 
person_name, 
SUM(weight) OVER(ORDER BY turn) AS total
FROM Queue)

select person_name
from sum
where total <=1000
order by total desc
limit 1

--ex8
WITH UniqueProducts AS (
  SELECT DISTINCT product_id
  FROM Products
),
LastChangedPrice AS (
  SELECT DISTINCT
    product_id,
    FIRST_VALUE(new_price) OVER (
      PARTITION BY product_id
      ORDER BY change_date DESC
    ) AS price
  FROM Products
  WHERE change_date <= '2019-08-16'
)
SELECT
  UP.product_id,
  CASE WHEN LCP.price IS NULL THEN 10 ELSE LCP.price END AS price
FROM
  UniqueProducts UP
LEFT JOIN
  LastChangedPrice LCP
ON
  UP.product_id = LCP.product_id;

