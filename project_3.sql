#1
SELECT PRODUCTLINE , YEAR_ID, DEALSIZE, SUM(SALES) AS REVENUE
FROM public.sales_dataset_rfm_prj
GROUP BY PRODUCTLINE , YEAR_ID, DEALSIZE;

#2 
SELECT YEAR_ID, MONTH_ID, ORDER_NUMBER FROM
(SELECT YEAR_ID, MONTH_ID , SUM(SALES) AS REVENUE, 
	COUNT(DISTINCT ORDERNUMBER) AS ORDER_NUMBER,
	RANK() OVER (PARTITION BY YEAR_ID ORDER BY SUM(SALES) DESC, COUNT(ORDERNUMBER) DESC)
	FROM public.sales_dataset_rfm_prj
GROUP BY YEAR_ID, MONTH_ID ) as sub_query
WHERE RANK = 1;

#3
SELECT productline, dealsize, sum(sales) as revenue,
		count(ordernumber) as order_number
from public.sales_dataset_rfm_prj
where month_id = 11
group by productline, dealsize
order by revenue desc, order_number desc
limit 1;

#4
