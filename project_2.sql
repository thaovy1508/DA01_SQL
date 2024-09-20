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
      Insights: Youngest 12 years old, Female: 474, Male:490
                Oldest: 70 years old, Female:477, Male: 501

with cte as (
  select gender, 
          min(age) as min_age,
          max(age) as max_age
  from bigquery-public-data.thelook_ecommerce.users
  group by gender
),
min_cte as (
select id, a.gender, age, first_name, last_name
from bigquery-public-data.thelook_ecommerce.users a
join cte b
on a.gender = b.gender
where age = min_age
and DATE(a.created_at) between '2019-01-01' and '2022-04-30'),

max_cte as (
select id, a.gender, age, first_name, last_name
from bigquery-public-data.thelook_ecommerce.users a
join cte b
on a.gender = b.gender
where age = max_age
and DATE(a.created_at) between '2019-01-01' and '2022-04-30')

(select gender, count(*) as total ,'youngest' as tag
from min_cte 
group by gender)

union all

(select gender, count(*) as total, 'oldest' as tag
from max_cte 
group by gender)

-- 4. Output: month_year ( yyyy-mm), product_id, product_name, sales, cost, profit, rank_per_month
Select * from (
  With product_profit as (
    Select CAST(FORMAT_DATE('%Y-%m' , t1.delivered_at) AS String) as month_year,
           t1.product_id as product_id,
           t2.name as product_name,
           round(sum(t1.sale_price),2) as sales,
           round(sum(t2.cost),2) as cost,
           round(sum(t1.sale_price) - sum(t2.cost),2) as profit
    from bigquery-public-data.thelook_ecommerce.order_items as t1
    join bigquery-public-data.thelook_ecommerce.products as t2
    on t1.product_id = t2.id
    where t1.status = 'Complete'
    group by month_year, t1.product_id, t2.name

  )

  Select *, 
  dense_rank() OVER (
    PARTITION BY month_year
    ORDER BY month_year, profit) as rank
    from product_profit
  ) as rank_table
where rank_table.rank <= 5
order by rank_table.month_year

-- 5. 
Select 

     CAST(FORMAT_DATE('%Y-%m-%d' , t1.created_at) AS String) as day,
     t2.category as product_categories,
     round(sum(t1.sale_price),2) as revenue
          
from bigquery-public-data.thelook_ecommerce.order_items as t1
join bigquery-public-data.thelook_ecommerce.products as t2
on t1.product_id = t2.id
where t1.status = 'Complete'
and cast(t1.created_at as date) between date_add(CURRENT_DATE, INTERVAL -3 MONTH) and CURRENT_DATE
group by day, category
order by day

  

 
