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
