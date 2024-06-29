#Exercise 1
WITH cn_dup AS (
SELECT title, count(*) AS cnt FROM job_listings
GROUP BY company_id, title, description)

SELECT count(*) as duplicate_companies
FROM cn_dup
WHERE cnt > 1

#Exercise 2
