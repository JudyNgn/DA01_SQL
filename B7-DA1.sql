--ex1
select NAME
from STUDENTS
where marks >75
order by right (name,3),id;

--ex2
select 
user_id,
concat (upper (left (name,1)),lower (right (name,length (name)-1))) as name 
from Users
order by user_id;

--ex3
SELECT manufacturer,
'$' ||round (sum (total_sales)/1000000,0)||' '||'million' as sale
FROM pharmacy_sales
group by manufacturer
order by sum (total_sales) desc, manufacturer asc;

--ex4
SELECT extract (month from submit_date) as mth,
product_id as product,
round (avg (stars),2) as avg_stars
FROM reviews
group by product_id, mth
order by mth, product_id;

--ex5
SELECT sender_id,
count (content) as message_count
FROM messages
where sent_date between '08/01/2022' and '08/31/2022'
group by sender_id
order by count(content) DESC
limit 2;

--ex6
select tweet_id
from Tweets
where length(content)>15;

--ex7
SELECT activity_date AS day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date
ORDER BY activity_date;

--ex8
select 
count (id)
from employees
where extract (month from joining_date) between 01 and 07
and extract (year from joining_date) = 2022;

--ex9
select 
position ('a' in first_name)
from worker
where first_name = 'Amitah';

--ex10
select 
cast (substring (title, length (winery)+2,4) as INT) as wine_years, 
winery
from winemag_p2
where country = 'Macedonia';
