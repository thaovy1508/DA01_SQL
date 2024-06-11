#Exercise 1
SELECT 

COUNT(CASE 
  WHEN device_type = 'laptop' THEN 1 
  ELSE NULL
END) laptop_reviews,

COUNT(CASE 
  WHEN device_type IN ('tablet','phone')  THEN 1 
  ELSE NULL
END) mobile_reviews

FROM viewership;

#Exercise 2
SELECT *,
CASE
    WHEN (x+y>z) and (x+z>y) and (y+z>x) THEN 'Yes'
    ELSE 'No'
END as triangle
FROM Triangle

#Exercise 3
SELECT 
ROUND(100*AVG( 
CASE
  WHEN call_category = 'n/a' or call_category IS NULL THEN 1
  ELSE 0
END),1) UNCATEGORISED_CALL_PCT
FROM callers;

#Exercise 4
SELECT NAME FROM CUSTOMER
WHERE REFEREE_ID != 2 OR REFEREE_ID IS NULL;

#Exercise 5
SELECT
    survived,
    sum(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
    sum(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
    sum(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM titanic
GROUP BY 
    survived
