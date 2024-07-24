SELECT * FROM SALES_DATASET_RFM_PRJ;

-- 1
ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER priceeach TYPE numeric USING priceeach::numeric;

ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER quantityordered TYPE numeric USING quantityordered::numeric;

ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER orderlinenumber TYPE numeric USING orderlinenumber::numeric;

ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER sales TYPE numeric USING sales::numeric;

ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER msrp TYPE numeric USING msrp::numeric;

ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER orderdate TYPE date USING orderdate::date;

-- 2. check null
SELECT count(*) 
FROM SALES_DATASET_RFM_PRJ
WHERE ordernumber IS NULL;

SELECT count(*) 
FROM SALES_DATASET_RFM_PRJ
WHERE quantityordered IS NULL;

SELECT count(*) 
FROM SALES_DATASET_RFM_PRJ
WHERE priceeach IS NULL;

SELECT count(*) 
FROM SALES_DATASET_RFM_PRJ
WHERE orderlinenumber IS NULL;

SELECT count(*) 
FROM SALES_DATASET_RFM_PRJ
WHERE sales IS NULL;

SELECT count(*) 
FROM SALES_DATASET_RFM_PRJ
WHERE orderdate IS NULL;

-- 3. add contactlast/first name
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD COLUMN CONTACTLASTNAME VARCHAR

ALTER TABLE SALES_DATASET_RFM_PRJ
ADD COLUMN CONTACTFIRSTNAME VARCHAR

UPDATE SALES_DATASET_RFM_PRJ
SET CONTACTLASTNAME = SUBSTRING(contactfullname from 
	POSITION('-' in contactfullname) + 1 for length(contactfullname))

UPDATE SALES_DATASET_RFM_PRJ
SET CONTACTLASTNAME = CONCAT(
					UPPER(SUBSTRING(CONTACTLASTNAME,1,1)),
					LOWER(SUBSTRING(CONTACTLASTNAME,2,LENGTH(CONTACTLASTNAME)))
							)

UPDATE SALES_DATASET_RFM_PRJ
SET CONTACTFIRSTNAME = CONCAT(
					UPPER(SUBSTRING(contactfullname,1,1)),
					LOWER(SUBSTRING(contactfullname,2,POSITION('-' in contactfullname)-2))
							)

-- 4. MONTH/YEAR/QUARTILE

	--quarter
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD COLUMN QTR_ID numeric;

UPDATE SALES_DATASET_RFM_PRJ
SET QTR_ID = EXTRACT(QUARTER from orderdate);

	-- month
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD COLUMN MONTH_ID numeric;

UPDATE SALES_DATASET_RFM_PRJ
SET MONTH_ID = EXTRACT(MONTH from orderdate);

	-- year
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD COLUMN YEAR_ID numeric;

UPDATE SALES_DATASET_RFM_PRJ
SET YEAR_ID = EXTRACT(YEAR from orderdate);

-- 5. OUTLIER

-- Option 1: IQR
WITH min_max_value as(
	SELECT Q1 - 1.5*IQR as min_value,
		   Q3 + 1.5*IQR as max_value
	FROM 
	( SELECT
		percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) as Q1,
		percentile_cont(0.75) WITHIN GROUP (ORDER BY quantityordered) as Q3,
		percentile_cont(0.75) WITHIN GROUP (ORDER BY quantityordered) -
		percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) as IQR
	FROM SALES_DATASET_RFM_PRJ) as a
	)

SELECT * FROM SALES_DATASET_RFM_PRJ
WHERE quantityordered < (SELECT min_value FROM min_max_value)
OR quantityordered > (SELECT max_value FROM min_max_value)


-- Option 2: z-score = (quantityordered- avg)/stddev

WITH 
cte as 
	(SELECT *, 
	(SELECT AVG(quantityordered) FROM SALES_DATASET_RFM_PRJ) as quantity_avg,
	(SELECT stddev(quantityordered) FROM SALES_DATASET_RFM_PRJ) as stddev
	FROM SALES_DATASET_RFM_PRJ),
outlier_cte as
	(SELECT *,  (quantityordered - quantity_avg)/stddev as z_score
	 FROM cte
	 WHERE abs((quantityordered - quantity_avg)/stddev) > 3
	)

SELECT * FROM outlier_cte

--solution: replace with avg
/*

UPDATE SALES_DATASET_RFM_PRJ
SET quantityordered = SELECT avg(quantityordered) FROM SALES_DATASET_RFM_PRJ)
WHERE quantityordered in (SELECT SELECT quantityordered FROM outlier_cte)

*/

