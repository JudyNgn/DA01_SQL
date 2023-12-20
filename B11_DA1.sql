-- PRACTICE EXERCISES--
-- ex1
SELECT COUNTRY.Continent, FLOOR(AVG(CITY.Population)) AS Average_City_Population
FROM Country
JOIN City ON CITY.CountryCode = COUNTRY.Code
GROUP BY COUNTRY.Continent;

--ex2
SELECT 
  ROUND(COUNT(texts.email_id)::DECIMAL
    /COUNT(DISTINCT emails.email_id),2) AS activation_rate
FROM emails
LEFT JOIN texts
  ON emails.email_id = texts.email_id
  AND texts.signup_action = 'Confirmed';

--ex3
SELECT age_bucket,
    ROUND((SUM(CASE WHEN activity_type = 'send' THEN time_spent ELSE 0 END) /
    (SUM(CASE WHEN activity_type = 'send' THEN time_spent ELSE 0 END) + 
    SUM(CASE WHEN activity_type = 'open' THEN time_spent ELSE 0 END)) * 100.0), 2) AS send_perc,
    
    ROUND((SUM(CASE WHEN activity_type = 'open' THEN time_spent ELSE 0 END) /
    (SUM(CASE WHEN activity_type = 'send' THEN time_spent ELSE 0 END) + 
    SUM(CASE WHEN activity_type = 'open' THEN time_spent ELSE 0 END)) * 100.0), 2) AS open_perc
FROM activities
JOIN age_breakdown on activities.user_id=age_breakdown.user_id
group by age_bucket;

--ex4
SELECT 
customer_contracts.customer_id
FROM customer_contracts
left JOIN products 
on customer_contracts.product_id=products.product_id
group by customer_contracts.customer_id
HAVING COUNT(DISTINCT products.product_category) = (SELECT COUNT(DISTINCT product_category) FROM products);

--ex5
SELECT
    mng.employee_id,
    mng.name,
    count(emp.employee_id) as reports_count,
    ROUND(AVG(emp.age)) AS average_age
FROM Employees as mng
INNER JOIN Employees as emp ON mng.employee_id = emp.reports_to
GROUP BY mng.employee_id
ORDER BY mng.employee_id;

--ex6
SELECT
    products.product_name,
    SUM(unit) AS unit
FROM
    orders 
JOIN products 
      ON orders.product_id=products.product_id
WHERE
        orders.order_date between '2020-02-01' and '2020-02-29'
GROUP BY
    product_name
HAVING
    sum(unit) >= 100;

--ex7
SELECT 
t1.page_id
FROM pages as t1
FULL JOIN page_likes as t2
  ON t1.page_id=t2.page_id
WHERE t2.liked_date is NULL
ORDER BY t1.page_id;
-----------------------------------------------------------------------------------
--MIDCOURSE_TEST--
--ex1
select 
min (replacement_cost)
from film

--ex2
select count (film_id)
from (
    select film_id,
           case
               when replacement_cost between 9.99 and 19.99 then 'low'
               when replacement_cost between 20.00 and 24.99 then 'medium'
               when replacement_cost between 25.00 and 29.99 then 'high'
           end as categorize_rep_cost
    from film
) as categorized_films
where categorize_rep_cost = 'low'
group by categorize_rep_cost;

--ex3
select 
	film.title, film.length, category.name as category_name 
from film_category
	full join category
	on film_category.category_id=category.category_id 
	full join film
	on film_category.film_id=film.film_id	
where category.name='Drama' or category.name='Sports'
order by length desc

--ex4
select 
	count (film.title)as title_count, category.name 
from film_category
	full join category
	on film_category.category_id=category.category_id 
	full join film
	on film_category.film_id=film.film_id
group by category.name
order by title_count desc 

--ex5
select 
actor.first_name, actor.last_name, count (film_actor.film_id)
from actor
full join film_actor
	on actor.actor_id=film_actor.actor_id
group by actor.first_name, actor.last_name
order by count (film_actor.film_id) desc

--ex6
SELECT COUNT(*) AS address_count
FROM Address
LEFT JOIN Customer ON Address.address_id = Customer.address_id
WHERE Customer.address_id IS NULL;

--ex7
SELECT City.city, SUM(payment.amount) AS total_revenue
FROM City
JOIN Address ON City.city_id = Address.city_id
JOIN Customer ON Address.address_id = Customer.address_id
JOIN Payment ON Customer.customer_id = Payment.customer_id
GROUP BY City.city
ORDER BY total_revenue DESC;

--ex8
SELECT CONCAT(City.city, ', ', Country.country) AS city_country,
       SUM(Payment.amount) AS total_revenue
FROM City
JOIN Country ON City.country_id = Country.country_id
JOIN Address ON City.city_id = Address.city_id
JOIN Customer ON Address.address_id = Customer.address_id
JOIN Payment ON Customer.customer_id = Payment.customer_id
GROUP BY city_country
ORDER BY total_revenue desc -- tìm doanh thu cao nhất (dùng asc nếu tìm thấp nhất)
LIMIT 1;




