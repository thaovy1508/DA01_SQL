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

# MID_COURSE TEST
1. Task: Tạo danh sách tất cả chi phí thay thế (replacement costs )  khác nhau của các film.
Question: Chi phí thay thế thấp nhất là bao nhiêu?
SELECT DISTINCT replacement_cost 
	FROM film
	ORDER BY replacement_cost ASC;

2.Task: Viết một truy vấn cung cấp cái nhìn tổng quan về số lượng phim có chi phí thay thế trong các phạm vi chi phí sau
1.	low: 9.99 - 19.99
2.	medium: 20.00 - 24.99
3.	high: 25.00 - 29.99
Question: Có bao nhiêu phim có chi phí thay thế thuộc nhóm “low”?

SELECT 
CASE 
	WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
	WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium'
	ELSE 'high' END AS category,
COUNT(*) 
FROM film
GROUP BY category;

3. Task: Tạo danh sách các film_title  bao gồm tiêu đề (title), độ dài (length) và tên danh mục (category_name) được sắp xếp theo độ dài giảm dần. Lọc kết quả để chỉ các phim trong danh mục 'Drama' hoặc 'Sports'.
Question: Phim dài nhất thuộc thể loại nào và dài bao nhiêu?

SELECT f.title, f.length, c.name
	FROM film f
	JOIN film_category fc
	ON f.film_id = fc.film_id
	JOIN category c
	ON c.category_id = fc.category_id
	WHERE c.name IN ('Drama', 'Sports')
	ORDER BY f.length DESC;

4. Task: Đưa ra cái nhìn tổng quan về số lượng phim (tilte) trong mỗi danh mục (category).
Question:Thể loại danh mục nào là phổ biến nhất trong số các bộ phim?

SELECT c.name, count(*) as total
	FROM film f
	JOIN film_category fc
	ON f.film_id = fc.film_id
	JOIN category c
	ON c.category_id = fc.category_id
	GROUP BY c.name
	ORDER BY total DESC;

5. Task:Đưa ra cái nhìn tổng quan về họ và tên của các diễn viên cũng như số lượng phim họ tham gia.
Question: Diễn viên nào đóng nhiều phim nhất?

SELECT CONCAT(a.first_name,' ', a.last_name) as actor_name, 
	count(*) as total_movies
FROM film f
JOIN film_actor fa
ON f.film_id = fa.film_id
JOIN actor a
ON a.actor_id = fa.actor_id
GROUP BY actor_name
ORDER BY total_movies DESC;

6. Task: Tìm các địa chỉ không liên quan đến bất kỳ khách hàng nào.
Question: Có bao nhiêu địa chỉ như vậy?



