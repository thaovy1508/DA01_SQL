#Exercise 1
SELECT name FROM STUDENTS
WHERE marks > 75
ORDER BY RIGHT(name, 3), id asc;

#Exercise 2
SELECT user_id, 
concat(UPPER(LEFT(name,1)), LOWER(RIGHT(name, LENGTH(name) - 1))) as name 
FROM USERS
ORDER BY user_id;

#Exercise 3
SELECT manufacturer,
concat('$',round(sum(total_sales)/1000000,0), ' million') as sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY sum(total_sales) DESC, manufacturer;

#Exercise 4
SELECT EXTRACT(MONTH from submit_date) as mth,
product_id,
ROUND(AVG(stars),2) as avg_star
FROM reviews
GROUP BY mth, product_id
ORDER BY mth, product_id;

#Exercise 5
SELECT sender_id, count(message_id) AS message_count
FROM messages
WHERE EXTRACT(MONTH from sent_date) = 8
AND EXTRACT(YEAR from sent_date) = 2022
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

#Exercise 6
SELECT tweet_id FROM Tweets
WHERE LENGTH(content) > 15;

#Exercise 7
select
    activity_date as day,
    count(distinct user_id) as active_users
from 
    activity
where
    activity_date between '2019-06-28' and '2019-07-27'
group by 
    activity_date;

#Exercise 8
select count(*) as total_number from employees
where extract(month from joining_date) between 1 and 7
and extract(year from joining_date) = 2022;

#Exercise 9
select position('a' in first_namr) as position 
from worker
where first_name = 'Amitah';

#Exercise 10
select title, substring(title,length(winery) + 2 , 4) as year
from winemag_p2
where country = 'Macedonia';
