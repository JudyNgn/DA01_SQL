I/ Ad-hoc tasks
--1.Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)
WITH MonthlyTotals AS (
  SELECT 
    FORMAT_DATE("%Y-%m", created_at) AS Month_Year,
    COUNT(user_id) AS total_users_1,
    COUNT(order_id) AS total_orders_1
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE 
    DATE(created_at) BETWEEN '2019-01-01' AND '2022-04-30' AND status ='Complete'
  GROUP BY 1
)

SELECT 
  Month_Year,
  SUM(total_users_1) OVER(PARTITION BY Month_Year) AS total_users,
  SUM(total_orders_1) OVER(PARTITION BY Month_Year) AS total_orders
FROM MonthlyTotals
ORDER BY 1;

--Insight:
(+) Có sự tăng trưởng đều đặn về số lượng người dùng và đơn hàng từ tháng 12/2020 đến tháng 4/2022 
  --(There's a consistent growth trend in both total users and total orders from December 2020 to April 2022.)
=> Sự gia tăng về người dùng có vẻ tương đồng với sự tăng về số đơn hàng, cho thấy sự hiệu quả của  việc thu hút người dùng và số lượng đơn hàng được đặt
  --(The rise in users seems proportional to the increase in orders, indicating a healthy relationship between user acquisition and order placements.)
(+) Có những tháng lượng đơn hàng nhiều hơn lượng người dùng
  --(Each month shows a slightly higher count of orders compared to users, suggesting that some users might be making multiple orders within a single month.)
=> Có khả năng 1 người dùng đặt nhiều hơn 1 đơn hàng, đây có thể là đối tượng khách hàng trung thành tiềm năng
  --(The user retention seems quite consistent across several months, maintaining a considerable portion of users from month to month, suggesting potential loyal customer)
--Action Suggestion:
(+)Xác định và hiểu rõ những yếu tố thúc đẩy việc tăng số lượng người dùng và đơn hàng 
  trong những tháng đỉnh điểm cho chiến lược tiếp thị hoặc các hoạt động khuyến mãi trong tương lai
  (--Identifying and understanding the factors driving increased user and order counts during peak months can guide future marketing strategies or promotional activities.)
(+) Tập trung vào việc giữ chân và thu hút người dùng hiện tại có thể mang lại lợi ích, 
  dựa trên sự ổn định về số lượng người dùng qua các tháng liên tiếp.
  (--Focusing on retaining and engaging existing users could be beneficial, given the consistent user counts across consecutive months.)

--2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
SELECT 
  FORMAT_DATE("%Y-%m", oi.created_at) AS Month_Year,
  COUNT(DISTINCT oi.user_id) AS distinct_users,
  ROUND ((SUM(oi.sale_price) / COUNT(DISTINCT oi.order_id)),2) AS average_order_value
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
WHERE 
  DATE(oi.created_at) BETWEEN '2019-01-01' AND '2022-04-30' AND oi.status ='Complete'
GROUP BY 1
ORDER BY 1;

--Insight:
(+) Về lượng người dùng và tổng giá trị đơn hàng:
  --năm 2019: cho thấy sự tăng mạnh về số lượng người dùng sau tháng 1 và 2, tuy giá trị trung bình đơn hàng giảm xuống
  nhưng lại có sự ổn định nhất định về giá trị trung bình đơn hàng từ tháng 3 đến tháng 12 
  --năm 2020 và 2021: cùng với sự tăng trưởng ổn định của lượng người dùng qua từng tháng, giá trị trung bình đơn hàng 
  có giá trị khá ổng định xuyên suốt hai năm 2020 và 2021
  -- năm 2022 (đến tháng 4): tuy giá trị đơn hàng có biến động nhẹ, nhưng không quá khác biệt so với năm 2020 và 2022.
  lượng người dùng vẫn tăng đều.
(+) Nhận xét về quan hệ người dùng và giá trị trung bình đơn hàng
  -- Số lượng người dùng tiếp tục tăng với một xu hướng ổn định, cho thấy chiến lược thu hút hoặc giữ chân khách hàng hiệu quả.
  -- có khả năng có sự nhất quán cao trong xu hướng tiêu dùng của người dùng
(+) Kế hoạch 
  -- Tận dụng sự tăng trưởng khá ổn định để tiếp tục định hướng hoặc mở rộng đối tượng khách hàng hoặc mở rộng dịch vụ sản phẩm
  -- Vẫn nên nghiên cứu sâu đối với những tháng có giá trị trung bình thay đổi nhiều để xem có sự thay đổi nào nổi bật trong xu hướng tiêu dùng 
  liên quan đến các dịp nhất định để mở rộng tiềm năng kinh doanh. 

--3. Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính (Từ 1/2019-4/2022)
-- Tạo bảng tạm YoungestOldestCustomers
CREATE TEMP TABLE YoungestOldestCustomers AS (
    WITH MinMaxAges AS (
        SELECT gender, MIN(age) AS min_age, MAX(age) AS max_age
        FROM bigquery-public-data.thelook_ecommerce.users
        WHERE created_at BETWEEN '2019-01-01' AND '2022-04-30'
        GROUP BY gender
    ),
    YoungestCustomers AS (
        SELECT u.first_name, u.last_name, u.gender, u.age, 'youngest' AS tag
        FROM bigquery-public-data.thelook_ecommerce.users u
        JOIN MinMaxAges m ON u.gender = m.gender AND u.age = m.min_age
    ),
    OldestCustomers AS (
        SELECT u.first_name, u.last_name, u.gender, u.age, 'oldest' AS tag
        FROM bigquery-public-data.thelook_ecommerce.users u
        JOIN MinMaxAges m ON u.gender = m.gender AND u.age = m.max_age
    )
    SELECT * FROM YoungestCustomers
    UNION ALL
    SELECT * FROM OldestCustomers
);

-- Đếm số lượng tương ứng
SELECT 
    tag,
    COUNT(*) AS count
FROM YoungestOldestCustomers
GROUP BY tag;

--Insight:
(+)Trẻ nhất và lớn tuổi nhất:
Trẻ nhất: Khách hàng trẻ nhất có tuổi là 12.
Lớn tuổi nhất: Khách hàng lớn tuổi nhất có tuổi là 70.
(+)Số lượng khách hàng:
Trẻ nhất: Có tổng cộng 1673 khách hàng được xác định là trẻ nhất.
Lớn tuổi nhất: Có tổng cộng 1713 khách hàng được xác định là lớn tuổi nhất.

--4.Top 5 sản phẩm có lợi nhuận cao nhất mỗi tháng
WITH ProfitPerMonth AS (
    SELECT
        FORMAT_DATE('%Y-%m', oi.created_at) AS month_year,
        oi.product_id,
        p.name AS product_name,
        ROUND (SUM(oi.sale_price),2) AS sales,
        ROUND (SUM(p.cost),2) AS cost,
        SUM(oi.sale_price - p.cost) AS profit,
        DENSE_RANK() OVER(PARTITION BY FORMAT_DATE('%Y-%m', oi.created_at) ORDER BY SUM(oi.sale_price - p.cost) DESC) AS rank_per_month
    FROM
        `bigquery-public-data.thelook_ecommerce.order_items` oi
    JOIN
        `bigquery-public-data.thelook_ecommerce.products` p ON oi.product_id = p.id
    WHERE
        oi.status = 'Complete'
    GROUP BY
        month_year,
        oi.product_id,
        product_name,
        oi.created_at
)
SELECT
    month_year,
    product_id,
    product_name,
    sales,
    cost,
    profit,
    rank_per_month
FROM
    ProfitPerMonth
WHERE
    rank_per_month <= 5
ORDER BY 
    month_year;

--5.Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục (assume current date is 15th April 2022)
SELECT
  DATE(oi.created_at) AS dates,
  p.category AS product_categories,
  SUM(oi.sale_price) AS revenue
FROM
  `bigquery-public-data.thelook_ecommerce.products` p
JOIN
  `bigquery-public-data.thelook_ecommerce.order_items` oi ON p.id = oi.product_id
WHERE
  DATE(oi.created_at) BETWEEN '2022-01-01' AND '2022-04-15'  
GROUP BY
  dates, product_categories
ORDER BY
  dates, revenue DESC;

II/ 
--1. Tạo metric trước khi dựng dashboard
WITH abc AS (
    SELECT
        FORMAT_DATE("%Y-%m", o.created_at) AS Month,
        EXTRACT(YEAR FROM o.created_at) AS Year,
        p.category AS Product_category,
        SUM (p.cost) as Total_cost,
        SUM(oi.sale_price) AS TPV,
        COUNT(DISTINCT oi.order_id) AS TPO
    FROM
        bigquery-public-data.thelook_ecommerce.orders o
    JOIN
        bigquery-public-data.thelook_ecommerce.order_items oi ON o.order_id = oi.order_id
    JOIN
        bigquery-public-data.thelook_ecommerce.products p ON oi.product_id = p.id
    GROUP BY
        FORMAT_DATE("%Y-%m", o.created_at),
        EXTRACT(YEAR FROM o.created_at),
        p.category
),
xyz AS (
    SELECT 
        *,
        LAG(TPV) OVER (PARTITION BY Product_category ORDER BY Year, Month) AS pre_TPV
    FROM 
        abc
),
xxx AS (
    SELECT 
        *,
        ROUND(((TPV - pre_TPV) / pre_TPV) * 100, 2) AS Revenue_growth
    FROM 
        xyz
)
,
ordergrowth as (
SELECT 
        *,
        LAG(TPO) OVER (PARTITION BY Product_category ORDER BY Year, Month) AS pre_TPO,
        ROUND(((TPO - LAG(TPO) OVER (PARTITION BY Product_category ORDER BY Year, Month ASC)) / LAG(TPO) OVER (PARTITION BY Product_category ORDER BY Year, Month ASC)) * 100, 2) AS Order_growth
    FROM 
        xxx)

select
Month,
Year,
Product_category,
TPV,
TPO,
CONCAT (Revenue_growth,'%') as Revenue_growth,
CONCAT (Order_growth,'%') as Order_growth,
Total_cost,
(TPV-Total_cost) as total_profit,
((TPV-Total_cost) /total_cost) as Profit_to_cost_ratio
from 
ordergrowth

--2. Tạo rentention cohort
--join bang, check null 
with new_table as (
select 
o.order_id,
oi.user_id,
oi.inventory_item_id,
oi.created_at,
oi.sale_price,
o.num_of_item
from brilliant-balm-410215.vw_ecommerce_analyst.orders as o
join brilliant-balm-410215.vw_ecommerce_analyst.order_items as oi
on o.user_id=oi.user_id
where oi.user_id is not null and num_of_item >0)
,
--check dup
main as (
select * from (
select *,
row_number () over (partition by order_id,inventory_item_id, num_of_item order by created_at) as stt
from new_table) as t
where stt = 1)
,
--tao index
index as (
select user_id, amount, FORMAT_DATE('%Y-%m',created_at) as cohort_date, created_at,
(extract (year from created_at) - extract (year from first_purchase_date))*12+ 
(extract (month from created_at) - extract (month from first_purchase_date)) + 1 as indexs
from
(select 
user_id,
sale_price*num_of_item as amount,
min (created_at) over (partition by user_id) as first_purchase_date,
created_at
from main ) as a)
,
xxx as (
select 
cohort_date,
indexs,
count (distinct user_id) as cnt,
sum(amount) as revenue
from index
group by cohort_date,indexs)
,
--su dung pivot de tao cohort customer
customer_cohort as (
select 
cohort_date,
sum (case when indexs =1 then cnt else 0 end )as m1,
sum (case when indexs =2 then cnt else 0 end )as m2,
sum (case when indexs =3 then cnt else 0 end )as m3,
sum (case when indexs =4 then cnt else 0 end )as m4
from xxx
group by cohort_date
order by cohort_date)

--tao rentention cohort
select 
cohort_date,
concat (round (m1/m1*100,2), '%') as m1,
concat (round (m2/m1*100,2),'%') as m2,
concat (round (m3/m1*100,2),'%') as m3,
concat (round (m4/m1*100,2), '%')as m4
from customer_cohort
--Nhận xét 
-- Về cơ bản, 1 tháng từ khi người dùng tham gia có được tỉ lệ quay lại của khách hàng cao nhất, nhưng 
   lại giảm dần cho những tháng tiếp theo. Điều này cho thấy trong vòng 1 tháng khi có khách hàng mới, doanh nghiệp 
   cần nghiên cứu hành vi tiêu dùng để tiếp tục giữ chân đối tượng này. Nếu không khách hàng quay lại giảm dần.
-- Dù theo thời gian tỉ lệ quay lại khả quan hơn, nhưng xu hướng vẫn tương đồng, có khả năng khách hàng chỉ tham gia mua sắm cùng 1 
  đợt khuyến mãi và không quay lại cho đến đơt tiếp theo. 


