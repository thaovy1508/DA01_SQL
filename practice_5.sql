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
