#Exercise 1

SELECT ROUND(avg(a.order_date = a.customer_pref_delivery_date)*100,2) as immediate_percentage
FROM (

SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER 
    (PARTITION BY customer_id ORDER BY order_date ASC) as order_rank
    FROM Delivery
) orders
WHERE order_rank = 1
) a
