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
  -- cte
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

  -- subquery 
SELECT 
  user_id,
  spend,
  transaction_date
FROM (
  SELECT 
    user_id, 
    spend, 
    transaction_date, 
    ROW_NUMBER() OVER (
      PARTITION BY user_id ORDER BY transaction_date) AS row_num
  FROM transactions) AS trans_num 
WHERE row_num = 3;

#Exercise 4
  -- cte 
WITH purchase_cte AS (
SELECT 
  transaction_date, user_id,
  COUNT(*) OVER(PARTITION BY user_id, transaction_date ORDER BY transaction_date) AS purchase_count,
  ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS recent_date
FROM user_transactions )

SELECT 
  transaction_date, user_id,
  purchase_count
FROM purchase_cte
WHERE recent_date = 1
ORDER BY transaction_date ASC
  
  -- subquery
SELECT 
  transaction_date, user_id,
  COUNT(product_id) AS purchase_count
FROM user_transactions
WHERE (user_id, transaction_date) IN
    (SELECT user_id, MAX(transaction_date) 
    FROM user_transactions
    GROUP BY user_id)
GROUP BY user_id, transaction_date
ORDER BY transaction_date
  
#Exercise 5
SELECT    
  user_id,    
  tweet_date,   
  ROUND(AVG(tweet_count) OVER (
    PARTITION BY user_id     
    ORDER BY tweet_date     
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) ,2) AS rolling_avg_3d
FROM tweets;

#Exercise 6



