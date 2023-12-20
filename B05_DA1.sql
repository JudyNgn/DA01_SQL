--ex1
SELECT DISTINCT CITY FROM STATION
WHERE ID%2 = 0;

--ex2
select COUNT (CITY) - COUNT(DISTINCT (CITY) FROM STATION 

--ex3
SELECT CEILING (AVG(salary)-avg(replace(salary,'0','')))
from EMPLOYEES;

--ex4
SELECT
round (sum (item_count :: DECIMAL*order_occurrences)/sum (order_occurrences), 1) as mean
from items_per_order;
--or
SELECT
ROUND(cast(SUM(item_count * order_occurrences) / SUM(order_occurrences) as DECIMAL) ,1) AS mean
FROM items_per_order;
--note ex4: use ::DECIMAL or CAST (field as DECIMAL) to cast integer to decimal

--ex5
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(DISTINCT skill) = 3
ORDER BY candidate_id;

--ex6
SELECT user_id,
MAX(post_date::date)- MIN(post_date::date) AS days_between
FROM posts
WHERE post_date >='2021-01-01' AND post_date <= '2022-01-01'
GROUP BY user_id
HAVING count (post_id) >=2;
--note ex6: use :: to cast to the number of day, or use DATE (MAX (post_date))- DATE (MIN (post_date))

--ex7
SELECT card_name, MAX (issued_amount)-MIN(issued_amount) as Difference
FROM monthly_cards_issued
group by card_name
ORDER BY difference DESC;

--ex8
SELECT 	
  manufacturer,
  ABS (SUM (total_sales - cogs)) as total_loss,
  COUNT(drug) AS drug_count
FROM pharmacy_sales
WHERE total_sales - cogs <= 0
GROUP BY manufacturer
ORDER BY total_loss DESC;

--ex9
SELECT *
FROM CINEMA
where id % 2 <> 0 and description <> 'boring'
order by rating desc;

--ex10
select teacher_id, 
count(distinct (subject_id)) as cnt
from Teacher 
group by teacher_id;

--ex11
select user_id, count(follower_id) as followers_count
from Followers
group by user_id
order by user_id;

--ex12
select class
from Courses
group by class
having count(student) >=5;
