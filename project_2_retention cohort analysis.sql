
/* III
1) Sử dụng câu lệnh SQL để tạo ra 1 dataset như mong muốn và lưu dataset đó vào VIEW đặt tên là vw_ecommerce_analyst
*/

With category_data as
(
Select 
FORMAT_DATE('%Y-%m', t1.created_at) as Month,
FORMAT_DATE('%Y', t1.created_at) as Year,
t2.category as Product_category,
round(sum(t3.sale_price),2) as TPV,
count(t3.order_id) as TPO,
round(sum(t2.cost),2) as Total_cost
from bigquery-public-data.thelook_ecommerce.orders as t1 
Join bigquery-public-data.thelook_ecommerce.products as t2 on t1.order_id=t2.id 
Join bigquery-public-data.thelook_ecommerce.order_items as t3 on t2.id=t3.id
Group by Month, Year, Product_category
)
Select Month, Year, Product_category, TPV, TPO,
round(cast((TPV - lag(TPV) OVER(PARTITION BY Product_category ORDER BY Year, Month))
      /lag(TPV) OVER(PARTITION BY Product_category ORDER BY Year, Month) as Decimal)*100.00,2) || '%'
       as Revenue_growth,
round(cast((TPO - lag(TPO) OVER(PARTITION BY Product_category ORDER BY Year, Month))
      /lag(TPO) OVER(PARTITION BY Product_category ORDER BY Year, Month) as Decimal)*100.00,2) || '%'
       as Order_growth,
Total_cost,
round(TPV - Total_cost,2) as Total_profit,
round((TPV - Total_cost)/Total_cost,2) as Profit_to_cost_ratio
from category_data
Order by Product_category, Year, Month

/* 
2) Cohort chart
*/
With a as
(Select user_id, amount, FORMAT_DATE('%Y-%m', first_purchase_date) as cohort_month,
created_at,
(Extract(year from created_at) - extract(year from first_purchase_date))*12 
  + Extract(MONTH from created_at) - extract(MONTH from first_purchase_date) +1
  as index
from 
(
Select user_id, 
round(sale_price,2) as amount,
Min(created_at) OVER (PARTITION BY user_id) as first_purchase_date,
created_at
from bigquery-public-data.thelook_ecommerce.order_items 
) as b),
cohort_data as
(
Select cohort_month, 
index,
COUNT(DISTINCT user_id) as user_count,
round(SUM(amount),2) as revenue
from a
Group by cohort_month, index
ORDER BY INDEX
),
--CUSTOMER COHORT-- 
Customer_cohort as
(
Select 
cohort_month,
Sum(case when index=1 then user_count else 0 end) as m1,
Sum(case when index=2 then user_count else 0 end) as m2,
Sum(case when index=3 then user_count else 0 end) as m3,
Sum(case when index=4 then user_count else 0 end) as m4
from cohort_data
Group by cohort_month
Order by cohort_month
),
--RETENTION COHORT--
retention_cohort as
(
Select cohort_month,
round(100.00* m1/m1,2) || '%' as m1,
round(100.00* m2/m1,2) || '%' as m2,
round(100.00* m3/m1,2) || '%' as m3,
round(100.00* m4/m1,2) || '%' as m4
from customer_cohort
)
--CHURN COHORT--
Select cohort_month,
(100.00 - round(100.00* m1/m1,2)) || '%' as m1,
(100.00 - round(100.00* m2/m1,2)) || '%' as m2,
(100.00 - round(100.00* m3/m1,2)) || '%' as m3,
(100.00 - round(100.00* m4/m1,2))|| '%' as m4
from customer_cohort

--> Chart Cohort https://docs.google.com/spreadsheets/d/1Ke2bhPAaG2rDjMfZdcWeTw-mevymA4JHXdOOZ6KVA1Q/edit#gid=505337796
/*
Nhìn chung hằng tháng TheLook ghi nhận số lượng người dùng mới tăng dần đều, thể hiện chiến dịch quảng cáo tiếp cận người dùng
mới có hiệu quả.
Tuy nhiên trong giai đoạn 4 tháng đầu tính từ lần mua hàng/sử dụng trang thương mại điện tử TheLook, tỷ lệ người dùng cũ
quay lại sử dụng trong tháng kế tiếp khá thấp: dao động dưới 10% trong giai đoạn từ 2019-01 đến 2023-07 và tăng lên mức 
trên 10% trong những tháng còn lại của năm 2023, trong đó cao nhất là tháng đầu tiên sau 2023-10 với 18.28%.
 --> Tỷ lệ khách hàng trung thành thấp, TheLook nên xem xét cách quảng bá để thiếp lập và tiếp cận nhóm khách hàng trung thành
nhằm tăng doanh thu từ nhóm này và tiết kiệm các chi phí marketing
