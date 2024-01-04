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


