#Exercise 1:
SELECT NAME FROM CITY
WHERE COUNTRYCODE= 'USA'
AND POPULATION > 120000;

#Exercise 2:
  SELECT * FROM CITY
WHERE COUNTRYCODE = 'JPN';

#Exercise 3:
SELECT CITY,  STATE FROM STATION;

#Exercise 4:
SELECT DISTINCT CITY FROM STATION
WHERE substr(CITY,1,1) in ('A','E','I','O','U') ;

#Exercise 5:
SELECT DISTINCT CITY FROM STATION
WHERE RIGHT(CITY,1) in ('a','e','i','o','u') ;

#Exercise 6:
SELECT DISTINCT CITY FROM STATION
WHERE substr(CITY,1,1) not in ('A','E','I','O','U') ;

#Exercise 7:
SELECT NAME FROM EMPLOYEE
ORDER BY NAME ASC;

#Exercise 8:
SELECT NAME FROM EMPLOYEE
WHERE SALARY > 2000 
AND MONTHS < 10
ORDER BY EMPLOYEE_ID ASC;

#Exercise 9:
SELECT product_id FROM Products
WHERE low_fats = 'Y'
AND recyclable = 'Y';


#Exercise 10:
SELECT NAME FROM CUSTOMER
WHERE REFEREE_ID != 2 OR REFEREE_ID IS NULL;

#Exercise 11:
SELECT name, population, area FROM WORLD
WHERE area >= 3000000
OR population >= 25000000;

#Exercise 12:
SELECT distinct AUTHOR_ID as id FROM VIEWS
WHERE VIEWER_ID = AUTHOR_ID
ORDER BY id ASC;

#Exercise 13:
SELECT part, assembly_step FROM parts_assembly
where finish_date is NULL;

#Exercise 14:
select * from lyft_drivers
where yearly_salary <= 30000 or yearly_salary >= 70000;
  
#Exercise 15:
select advertising_channel from uber_advertising
where money_spent > 100000
and year = 2019;
