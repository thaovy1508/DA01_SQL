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
