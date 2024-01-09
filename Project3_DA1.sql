--1. Doanh thu theo từng ProductLine, Year  và DealSize?
--Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE
SELECT 
    productline,
    year_id,
    dealsize,
    SUM(sales) AS revenue
FROM 
    public.sales_dataset_rfm_prj
GROUP BY 
    productline,
    year_id,
    dealsize
ORDER BY 
    productline,
    year_id,
    dealsize;

--2.Đâu là tháng có bán tốt nhất mỗi năm?
--Output: MONTH_ID, REVENUE, ORDER_NUMBER
with table_a as (
select  
month_id,
year_id,
sum (sales) as revenue,
ordernumber
from public.sales_dataset_rfm_prj
group by month_id, year_id, ordernumber
order by year_id, month_id),

ranking as (
select
month_id,
year_id,
row_number () over (partition by year_id order by revenue DESC) as month_rank,
revenue,
ordernumber
from table_a)

SELECT
    month_id,
	year_id,
    revenue,
    ordernumber
FROM
    ranking
WHERE
    month_rank = 1;

--3. Product line nào được bán nhiều ở tháng 11?
--Output: MONTH_ID, REVENUE, ORDER_NUMBER
WITH table_a AS (
    SELECT  
        month_id,
        year_id,
        SUM(sales) AS revenue,
        productline,
        ordernumber
    FROM 
        public.sales_dataset_rfm_prj
    WHERE 
        month_id = 11
    GROUP BY 
        month_id, 
        year_id, 
        productline, 
        ordernumber
),
ranking AS (
    SELECT
        month_id,
        year_id,
        productline,
        ROW_NUMBER() OVER (PARTITION BY year_id ORDER BY revenue DESC) AS product_rank,
        revenue,
        ordernumber
    FROM 
        table_a
)
SELECT
    month_id,
    year_id,
    revenue,
    ordernumber,
    productline
FROM 
    ranking
WHERE 
    product_rank = 1;

--4. Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
Xếp hạng các các doanh thu đó theo từng năm.
--Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK
WITH UK_Sales AS (
    SELECT  
        year_id,
        productline,
        SUM(sales) AS revenue,
        ROW_NUMBER() OVER (PARTITION BY year_id ORDER BY SUM(sales) DESC) AS rank_by_revenue
    FROM 
        public.sales_dataset_rfm_prj
    WHERE 
        country = 'UK'
    GROUP BY 
        year_id, 
        productline
)
    SELECT 
        year_id,
        productline,
        revenue,
		    ROW_NUMBER() OVER (ORDER BY revenue DESC) as rank
    FROM 
        UK_Sales
    WHERE 
        rank_by_revenue = 1
-- 5.Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
--B1: tinh rfm
with customer_rfm as (
select
customername,
current_date - max (orderdate) as R,
count (distinct ordernumber) as F,
sum (sales) as M
from public.sales_dataset_rfm_prj
group by customername)
,
--B2: chia khoang
rfm_score as (
select 
customername,
ntile (5) over (order by r desc) as r_score,
ntile (5) over (order by f ) as f_score,
ntile (5) over (order by m) as m_score
from customer_rfm)
,
--B3:
rfm_final as (
select 
customername,
cast (r_score as varchar) || cast (f_score as varchar) || cast (m_score as varchar) as rfm_score
from rfm_score)
,
customer_segment as (
select 
a.customername,
b.segment
from rfm_final a
join segment_score b on a.rfm_score=b.scores)

select * from
customer_segment
where segment = 'Champions'


