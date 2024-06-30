#Exercise 1
WITH cn_dup AS (
SELECT title, count(*) AS cnt FROM job_listings
GROUP BY company_id, title, description)

SELECT count(*) as duplicate_companies
FROM cn_dup
WHERE cnt > 1

#Exercise 2
WITH 
appliance_cte AS (
SELECT category, product, SUM(spend) AS total_spend
FROM product_spend
WHERE category='appliance'
AND EXTRACT(year FROM transaction_date) = 2022
GROUP BY category, product
ORDER BY total_spend DESC
LIMIT 2),

electronics_cte AS (
SELECT category, product, SUM(spend) AS total_spend
FROM product_spend
WHERE category='electronics'
AND EXTRACT(year FROM transaction_date) = 2022
GROUP BY category, product
ORDER BY total_spend DESC
LIMIT 2)

SELECT * FROM appliance_cte 
UNION 
SELECT * FROM electronics_cte
ORDER BY category ASC, total_spend DESC

#Exercise 3
# cte solution
WITH call_count_cte AS (
SELECT policy_holder_id, count(DISTINCT case_id) AS number_of_calls
FROM callers
GROUP BY policy_holder_id)

SELECT COUNT(*) AS policy_holder_count FROM call_count_cte
WHERE number_of_calls > 2

# subquery solution
SELECT COUNT(policy_holder_id) AS policy_holder_count
FROM (
  SELECT 
    policy_holder_id,
    COUNT(case_id) AS number_of_calls
  FROM callers
  GROUP BY policy_holder_id
  HAVING COUNT(case_id) >= 3
) AS call_records;

#Exercise 4
SELECT EXTRACT(MONTH from event_date),
COUNT(DISTINCT user_id)
FROM user_actions
WHERE EXTRACT(MONTH from event_date) = 7
AND user_id IN (SELECT user_id FROM user_actions WHERE EXTRACT(MONTH from event_date) = 6)
GROUP BY 1
ORDER BY 1,2

#Exercise 5
SELECT 
    DATE_FORMAT(trans_date, '%Y-%m') AS month, 
    country,
    COUNT(*) AS trans_count,
    SUM(IF(state='approved', 1,0)) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(IF(state='approved', amount, 0)) AS approved_total_amount
FROM Transactions
GROUP BY month, country

#Exercise 6


