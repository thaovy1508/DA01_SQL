#Exercise 1
SELECT b.Continent, floor(avg(a.Population))
FROM City as a
JOIN Country as b
ON a.CountryCode = b.Code
GROUP BY b.Continent;

#Exercise 2
