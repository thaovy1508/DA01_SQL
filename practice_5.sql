#Exercise 1
SELECT b.Continent, floor(avg(a.Population))
FROM City as a
JOIN Country as b
ON a.CountryCode = b.Code
GROUP BY b.Continent;

#Exercise 2
SELECT round(cast(sum(
case 
  when t.signup_action = 'Confirmed' then 1 
  else 0 
end) as decimal)/count(e.email_id),2) as confirm_rate 
FROM emails e
JOIN texts t
ON t.email_id = e.email_id;

#Exercise 3
SELECT age_bucket, 
ROUND(100.0*SUM(CASE WHEN activity_type = 'open' THEN time_spent ELSE 0 END)/SUM(time_spent),2) as open_perc,
ROUND(100.0*SUM(CASE WHEN activity_type = 'send' THEN time_spent ELSE 0 END)/SUM(time_spent),2) as send_perc
FROM activities a
LEFT JOIN age_breakdown b
ON a.user_id = b.user_id 
WHERE a.activity_type in ('open', 'send')
GROUP BY age_bucket;

#Exercise 4
SELECT c.customer_id
FROM customer_contracts c
LEFT JOIN products p
ON c.product_id = p.product_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT p.product_category) = 3;

#Exercise 5
SELECT 
    e.employee_id, 
    e.name, 
    count(r.reports_to) as reports_count, 
    round(avg(r.age)) as average_age
FROM Employees e
INNER JOIN EmployeeS r
ON e.employee_id = r.reports_to
GROUP BY e.employee_id
ORDER BY e.employee_id;

#Exercise 6
SELECT p.product_name, sum(o.unit) as unit
FROM Products p
RIGHT JOIN Orders o
ON o.product_id = p.product_id
WHERE EXTRACT(year from o.order_date) = 2020
AND EXTRACT(month from o.order_date) = 2
GROUP BY o.product_id
HAVING unit >= 100;

#Exercise 7
SELECT p.page_id 
FROM pages p
FULL OUTER JOIN page_likes l
ON p.page_id = l.page_id
WHERE l.user_id IS NULL
ORDER BY p.page_id ASC;

