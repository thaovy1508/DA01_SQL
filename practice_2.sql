#Exercise 1
SELECT distinct city FROM station
WHERE ID % 2 = 0;

#Exercise 2
SELECT count(city) - count (distinct city) FROM station;

#Exercise 3
SELECT ceil(avg(salary) - avg(replace(salary,0,''))) FROM Employees;

#Exercise 4
SELECT round(CAST(sum(order_occurrences*item_count)/sum(order_occurrences) AS numeric), 1) 
  FROM items_per_order;

#Exercise 5
SELECT candidate_id FROM candidates
WHERE skill in ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING count(skill) = 3
ORDER BY candidate_id asc;

#Exercise 6
SELECT user_id, 
max(post_date::date)-min(post_date::date) AS days_between 
FROM posts
WHERE EXTRACT(YEAR from post_date) = '2021'
GROUP BY user_id
HAVING count(post_id) > 1;

#Exercise 7
SELECT card_name, max(issued_amount)-min(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

#Exercise 8
SELECT manufacturer, 
COUNT(1) AS drug_count, 
SUM(cogs)-SUM(total_sales) AS total_loss 
FROM pharmacy_sales
WHERE cogs > total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC;

#Exercise 9
SELECT * FROM Cinema
WHERE id%2 =1
AND description != 'boring'
ORDER BY rating DESC;

#Exercise 10
SELECT teacher_id, count(distinct subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id;

#Exercise 11
SELECT user_id, count(distinct follower_id) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id ASC;

#Exercise 12
SELECT class FROM Courses
GROUP BY class
HAVING COUNT(*) > 4;
