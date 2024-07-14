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
#Method 1 - cte
  
WITH card_launch_cte AS (
SELECT 
  card_name,
  issued_amount,
  MAKE_DATE(issue_year, issue_month, 1) AS issue_date,
  MIN(MAKE_DATE(issue_year, issue_month, 1)) OVER (
    PARTITION BY card_name) AS launch_date
FROM monthly_cards_issued)

SELECT card_name, issued_amount
FROM card_launch_cte
WHERE issue_date = launch_date
ORDER BY issued_amount DESC

#Method 2 - FIRST_VALUE()
SELECT 
  DISTINCT card_name,
  FIRST_VALUE(issued_amount) OVER (
    PARTITION BY card_name ORDER BY issue_year, issue_month) AS issued_amount

FROM monthly_cards_issued
ORDER BY issued_amount DESC

#Exercise 3
WITH ranking_cte AS (
SELECT 
  user_id, 
  spend,
  transaction_date,
  RANK() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rank_num
FROM transactions)

SELECT 
  user_id,
  spend,
  transaction_date
FROM ranking_cte
WHERE rank_num = 3

#Exercise 4


