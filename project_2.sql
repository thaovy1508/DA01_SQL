Ad-hoc tasks

--1. Output: month_year ( yyyy-mm) , total_user, total_orde
     Insights: The number of total users and orders is increasing over time.  

WITH order_cte as (
select order_id, 
        user_id, 
        EXTRACT(YEAR from created_at) || '-' || EXTRACT(month from created_at) as month_year
from bigquery-public-data.thelook_ecommerce.orders
where status='Complete'
and DATE(created_at) between '2019-01-01' and '2022-04-30')

select month_year,
      count(distinct user_id) as total_user,
      count(distinct order_id) as total_order
from order_cte
group by 1
order by 1;

--2. Output: month_year ( yyyy-mm), distinct_users, average_order_value
     Insights: The average price remains fairly consistent over time, with a range of about $80-90
       
WITH order_cte as (
select  o.order_id, 
        o.user_id, 
        i.sale_price,
        EXTRACT(YEAR from o.created_at) || '-' || EXTRACT(month from o.created_at) as month_year
from bigquery-public-data.thelook_ecommerce.orders o
left join bigquery-public-data.thelook_ecommerce.order_items i
on i.order_id = o.order_id
where o.status='Complete'
and DATE(o.created_at) between '2019-01-01' and '2022-04-30'),

avg_cte as (
select month_year,
      count(distinct user_id) as distinct_user,
      count(distinct order_id) as total_order,
      sum(sale_price) as total_price
from order_cte
group by 1
order by 1)

select month_year,
       distinct_user,
       total_price/total_order as average_order_value
from avg_cte


-- 3. Output: first_name, last_name, gender, age, tag 
      Insights: 

