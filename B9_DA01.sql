--ex1
---option1
SELECT 
SUM(CASE WHEN device_type='laptop' THEN 1 ELSE 0 END) AS laptop_reviews,
SUM(CASE WHEN device_type IN ('phone','tablet') THEN 1 ELSE 0 END) AS mobile_reviews
FROM viewership;
--note: then 1 else 0: nếu device_type là laptop thì sẽ trả kết quả 1, else trả kết quả 0. sau đó dùng sum để tổng lại. 
---option2
SELECT 
  SUM(CAST(device_type = 'laptop' AS int)) AS laptop_reviews,
  SUM(CAST(device_type IN ('phone','tablet') AS int)) AS mobile_reviews
FROM viewership;

--ex2
SELECT 
    x, y, z,
    CASE 
        WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes'
        ELSE 'No'
    END AS triangle
FROM Triangle;

--ex3
SELECT 
    ROUND(
        (COUNT(CASE WHEN call_category IS NULL OR call_category = 'n/a' OR call_category = '' THEN 1 ELSE 0 END)
        / COUNT(*)::DECIMAL) * 100, 1
    ) AS uncategorized_percentage
FROM callers;

--ex4
SELECT name 
FROM customer 
WHERE referee_id <> 2 OR referee_id IS NULL ;

--ex5
SELECT
    survived,
    sum(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
    sum(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
    sum(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM titanic
GROUP BY 
    survived
