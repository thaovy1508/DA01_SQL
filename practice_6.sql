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
SELECT p.page_id 
FROM pages p
FULL OUTER JOIN page_likes l
ON p.page_id = l.page_id
WHERE l.user_id IS NULL
ORDER BY p.page_id asc;
  
#Exercise 5
SELECT EXTRACT(MONTH from event_date),
COUNT(DISTINCT user_id)
FROM user_actions
WHERE EXTRACT(MONTH from event_date) = 7
AND user_id IN (SELECT user_id FROM user_actions WHERE EXTRACT(MONTH from event_date) = 6)
GROUP BY 1
ORDER BY 1,2

#Exercise 6
SELECT 
    DATE_FORMAT(trans_date, '%Y-%m') AS month, 
    country,
    COUNT(*) AS trans_count,
    SUM(IF(state='approved', 1,0)) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(IF(state='approved', amount, 0)) AS approved_total_amount
FROM Transactions
GROUP BY month, country

#Exercise 7
#Method 1 - subquery
SELECT product_id, year as first_year, quantity, price
FROM Sales
WHERE (product_id, year) in (
    SELECT product_id, MIN(year)
    FROM Sales
    GROUP BY product_id
)

#Method 2 - cte
WITH first_year_sale_cte AS(
    SELECT s.product_id,
        MIN(s.year) AS first_year
    FROM Sales s
    GROUP BY s.product_id)

SELECT 
    fys.product_id, 
    fys.first_year,
    s.quantity,
    s.price
FROM first_year_sale_cte fys
JOIN Sales s ON fys.product_id = s.product_id 
AND fys.first_year = s.year

#Exercise 8
SELECT customer_id
FROM Customer c
JOIN Product p
ON c.product_key = p.product_key
GROUP BY c.customer_id
HAVING COUNT(DISTINCT c.product_key) = 
(SELECT COUNT(DISTINCT product_key) 
FROM Product)

#Exercise 9
# Method 1 - cte
WITH employees_cte AS (
SELECT employee_id, manager_id
FROM employees 
WHERE salary < 30000)

SELECT e.employee_id
FROM employees_cte e
WHERE e.manager_id NOT IN (SELECT employee_id FROM employees)

# Method 2 - correlated
SELECT employee_id
FROM employees 
WHERE manager_id NOT IN (SELECT employee_id FROM employees)
AND salary < 30000

#Exercise 10
SELECT 
    employee_id,
    CASE 
        WHEN count(*) = 1 THEN MAX(department_id)
        WHEN count(*) > 1 THEN MAX(CASE WHEN primary_flag = 'Y' THEN department_id END)
    END AS department_id
FROM employee
GROUP BY employee_id)

SELECT employee_id, department_id
FROM employee_cte
WHERE department_id IS NOT NULL

#Exercise 11
WITH mv_cte AS (
SELECT m.user_id, count(DISTINCT m.movie_id) AS num_of_rating
FROM MovieRating m
GROUP BY m.user_id) 

(SELECT u.name AS results
FROM mv_cte m
JOIN Users u 
ON u.user_id = m.user_id
ORDER BY m.num_of_rating DESC, u.name ASC
LIMIT 1)

UNION ALL

(SELECT m.title
FROM MovieRating mr
JOIN Movies m
ON mr.movie_id = m.movie_id
WHERE extract(YEAR from mr.created_at) = 2020
AND extract(MONTH from mr.created_at) = 2
GROUP BY mr.movie_id
ORDER BY AVG(mr.rating) DESC, m.title ASC
LIMIT 1)

#Exercise 12
WITH new_cte AS (
    SELECT requester_id as id, count(*) as num 
    FROM RequestAccepted
    GROUP BY requester_id
    UNION ALL
    SELECT accepter_id as id, count(*) as num
    FROM RequestAccepted
    GROUP BY accepter_id
)

SELECT id, sum(num) as num from new_cte
GROUP BY id
ORDER BY num DESC 
LIMIT 1


