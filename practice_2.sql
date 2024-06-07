#Exercise 1
select distinct city from station
where ID % 2 = 0;

#Exercise 2
select count(city) - count (distinct city) from station;

#Exercise 3
