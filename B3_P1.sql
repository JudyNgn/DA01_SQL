--ex1 
select NAME from CITY 
where COUNTRYCODE = 'USA'
and 
POPULATION > 120000;

--ex2
select * from CITY
where COUNTRYCODE ='JPN';

--ex3
select city, state from station;

--ex4
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE 'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%' OR CITY LIKE 'U%'
   OR CITY LIKE 'a%' OR CITY LIKE 'e%' OR CITY LIKE 'i%' OR CITY LIKE 'o%' OR CITY LIKE 'u%';

--ex5
SELECT DISTINCT CITY
FROM STATION
WHERE CITY LIKE '%a' OR CITY LIKE '%e' OR CITY LIKE '%i' OR CITY LIKE '%o' OR CITY LIKE '%u';

--ex6
SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT LIKE 'A%' and CITY NOT LIKE 'E%' and CITY NOT LIKE 'I%' and CITY NOT LIKE 'O%' and CITY NOT LIKE 'U%';

--ex7
select name from Employee 
order by name;

--ex8
select name from Employee
where salary > 2000 and months < 10
order by employee_id;

--ex9
select product_id from Products
where low_fats = 'Y' and recyclable = 'Y';

--ex10
SELECT name 
FROM customer 
WHERE referee_id != 2 OR referee_id IS NULL ;

--ex11
select name, population, area 
from World
where area >= 3000000 or population >=25000000;

--ex12
select distinct author_id as id from Views
where author_id = viewer_id 
order by id;

--ex13
SELECT part, assembly_step FROM parts_assembly
where finish_date is null;

--exq14
select * from lyft_drivers
where yearly_salary <=30000 or yearly_salary >=70000;

--ex15
select advertising_channel from uber_advertising
where year = 2019 and money_spent > 100000;
