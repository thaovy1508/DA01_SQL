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

-- lag function
WITH transaction_cte AS (
SELECT 
  transaction_id,
  merchant_id,
  credit_card_id,
  amount,
  transaction_timestamp,
  EXTRACT(EPOCH FROM transaction_timestamp -
    LAG(transaction_timestamp) OVER (
      PARTITION BY merchant_id, credit_card_id, amount
      ORDER BY transaction_timestamp)
  )/60 AS mins_diff
FROM transactions )

SELECT count(*) AS payment_count
FROM transaction_cte
WHERE mins_diff <= 10

-- self join
SELECT count(*)
FROM transactions t1
JOIN transactions t2
ON t1.merchant_id = t2.merchant_id
AND t1.credit_card_id = t2.credit_card_id
AND t1.amount = t2.amount
AND t1.transaction_id < t2.transaction_id
AND t2.transaction_timestamp - t1.transaction_timestamp <= INTERVAL '10 MINUTES'

#Exercise 7

  -- rank()
  
WITH ranking_cte AS (
SELECT 
  category,
  product,
  SUM(spend) AS total_spend,
  RANK() OVER ( 
    PARTITION BY category ORDER BY SUM(spend)desc) AS RANK_NUM
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product)

SELECT 
  category,
  product,
  total_spend
FROM ranking_cte
WHERE RANK_NUM <= 2
ORDER BY category, total_spend DESC

#Exercise 8
-- dense_rank

WITH top_10_cte AS (
  SELECT 
    artists.artist_name,
    DENSE_RANK() OVER (
      ORDER BY COUNT(songs.song_id) DESC) AS artist_rank
  FROM artists
  INNER JOIN songs
    ON artists.artist_id = songs.artist_id
  INNER JOIN global_song_rank AS ranking
    ON songs.song_id = ranking.song_id
  WHERE ranking.rank <= 10
  GROUP BY artists.artist_name
)

SELECT artist_name, artist_rank
FROM top_10_cte
WHERE artist_rank <= 5

