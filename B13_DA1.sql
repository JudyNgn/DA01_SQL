--ex1
select 
count (distinct company_id)
from job_listings
where (title, description, company_id) IN 
(SELECT title, description, company_id
FROM job_listings
GROUP BY title, description, company_id
HAVING COUNT(*) > 1)

--ex2
WITH ranked_spending_cte AS (
SELECT 
category, 
product, 
SUM(spend) AS total_spend,
RANK() OVER (
PARTITION BY category 
ORDER BY SUM(spend) DESC) AS ranking 
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product
)
--note ex2: sử dụng RANK và PARTITION để sắp xếp và đếm được row của từng category trong 1 table (buổi sau học kĩ)

SELECT 
  category, 
  product, 
  total_spend 
FROM ranked_spending_cte 
WHERE ranking <= 2 
ORDER BY category, ranking;


--ex3
WITH call_record AS (
SELECT
  policy_holder_id,
  COUNT(case_id) AS call_count
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3
)

SELECT COUNT(policy_holder_id) AS member_count
FROM call_record;

-ex4
SELECT 
t1.page_id
FROM pages as t1
LEFT JOIN page_likes as t2
  ON t1.page_id=t2.page_id
WHERE t2.liked_date is NULL
ORDER BY t1.page_id;

--ex5
WITH june_actives AS (
SELECT user_id
FROM user_actions
WHERE EXTRACT(MONTH FROM event_date) = 6
AND event_type IN ('sign-in', 'like', 'comment')
)
SELECT
7 AS month,
COUNT(DISTINCT user_id) AS monthly_active_users
FROM user_actions
WHERE EXTRACT(MONTH FROM event_date) = 7
AND user_id IN (SELECT user_id FROM june_actives);

--ex6
SELECT 
    DATE_FORMAT(trans_date, '%Y-%m') AS month,
    country,
    COUNT(id) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY month, country
ORDER BY month, country;
--note ex6: sử dụng date format: DATE_FORMAT(trans_date, '%Y-%m'), %Y: Represents the year with four digits,
--%m : Represents the month as a two-digit number 

--ex7
SELECT product_id, year AS first_year, quantity, price
FROM Sales
WHERE (product_id, year) in (
    SELECT product_id, MIN(year) 
    FROM Sales
    GROUP BY product_id
)

--ex8
SELECT  customer_id 
FROM Customer 
GROUP BY customer_id
HAVING 
COUNT(distinct product_key) = (SELECT COUNT(product_key) FROM Product)

--ex9
SELECT e.employee_id
FROM Employees AS e
LEFT JOIN Employees AS m ON e.manager_id = m.employee_id
WHERE e.salary < 30000
AND m.employee_id IS NULL;

--ex10
SELECT 
  employee_id, 
  department_id 
FROM 
  Employee 
WHERE 
  primary_flag = 'Y' 
UNION 
SELECT 
  employee_id, 
  department_id 
FROM 
  Employee 
GROUP BY 
  employee_id 
HAVING 
  COUNT(employee_id) = 1;

--ex11
(
    SELECT u.name AS results
    FROM MovieRating mr, Users u
    WHERE mr.user_id = u.user_id
    GROUP BY mr.user_id
    ORDER BY COUNT(1) DESC, u.name
    LIMIT 1
)
UNION ALL
(
    SELECT m.title AS results
    FROM MovieRating mr, Movies m 
    WHERE mr.movie_id = m.movie_id AND mr.created_at LIKE '2020-02%'
    GROUP BY mr.movie_id
    ORDER BY AVG(rating) DESC, m.title
    LIMIT 1
)
-- lexicographically: A string x is lexicographically smaller than a string y of the same length if x[i] comes before y[i] in alphabetic order 


--ex12
SELECT id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id
    FROM RequestAccepted
    
    UNION ALL
    
    SELECT accepter_id AS id
    FROM RequestAccepted
) AS combined_ids
GROUP BY id
ORDER BY num DESC
LIMIT 1;


