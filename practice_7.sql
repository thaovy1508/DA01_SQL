#Exercise 1
WITH yearly_spend_cte AS
(SELECT 

  EXTRACT(YEAR FROM transaction_date) AS year,
  product_id,
  spend AS curr_year_spend,
  lag(spend) OVER(
    PARTITION BY product_id 
    ORDER BY 
      product_id, 
      EXTRACT(YEAR FROM transaction_date)) AS prev_year_spend
      
FROM user_transactions)

SELECT 
  year, product_id, curr_year_spend, prev_year_spend,
  ROUND(100*(curr_year_spend-prev_year_spend)/prev_year_spend,2) AS yoy_rate 
FROM yearly_spend_cte

#Exercise 2

