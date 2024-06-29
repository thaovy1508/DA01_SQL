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

