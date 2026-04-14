--- SQL Retail Sales Analysis
CREATE DATABASE SQL_PROJECT_1
--- Create Table

CREATE TABLE Retail_salesData (
			transactions_id int PRIMARY KEY,
			sale_date Date,
			sale_time TIME,
			customer_id INT,
			gender VARCHAR(20),
			age INT,
			category VARCHAR(20),
			quantiy INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT
			); 

			 
INSERT INTO Retail_salesData ( transactions_id,sale_date,sale_time,customer_id,gender,age,category,quantiy,price_per_unit,cogs,total_sale)
SELECT*
FROM [SQL - Retail Sales Analysis_utf ]

SELECT 
COUNT (*)
FROM Retail_salesData

SELECT *
FROM Retail_salesData
WHERE sale_time IS NULL
	OR 
	  transactions_id IS NULL
	OR 
	  sale_date IS NULL
	OR
	  customer_id IS NULL
	OR
	  gender IS NULL
	OR
	  category IS NULL
	OR
	  quantiy IS NULL
	OR
	  price_per_unit IS NULL
	OR
	  cogs IS NULL
	OR
	  total_sale IS NULL ;

---
DELETE FROM Retail_salesData
WHERE sale_time IS NULL
	OR 
	  transactions_id IS NULL
	OR 
	  sale_date IS NULL
	OR
	  customer_id IS NULL
	OR
	  gender IS NULL
	OR
	  category IS NULL
	OR
	  quantiy IS NULL
	OR
	  price_per_unit IS NULL
	OR
	  cogs IS NULL
	OR
	  total_sale IS NULL ;

---HOW MANY SALES WE HAVE ?

SELECT 
COUNT (*) AS TOTAL_SALES
FROM Retail_salesData


--- HOW MANY UNIQUE CUSTOMERS WE HAVE ?

SELECT 
COUNT (DISTINCT customer_id) AS TOTAL_CUSTOMERS
FROM Retail_salesData

--- WHAT AND HOW MANY CATEGORY WE HAVE

SELECT 
DISTINCT category AS TOTAL_NO_CATEGORY
FROM Retail_salesData

SELECT 
COUNT (DISTINCT category) AS TOTAL_CATEGORY
FROM Retail_salesData

-- BUSINESS KEY PROBLMES

-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * 
FROM Retail_salesData
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT *
FROM Retail_salesData as RS
WHERE category = 'Clothing'
AND
MONTH(RS.sale_date) = 11
AND
YEAR(RS.sale_date) = 2022
AND
RS.quantiy >= 4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT
	RS.category,
	SUM(RS.total_sale) AS Total_Sales
FROM Retail_salesData AS RS
GROUP BY RS.category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
AVG(age) AS AVG_Age
FROM Retail_salesData AS RS
WHERE RS.category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT*
FROM Retail_salesData
WHERE total_sale >= 1000\

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT
category,
gender,
COUNT(transactions_id) AS Transactions
FROM Retail_salesData 
GROUP BY gender,category

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH MonthlySales AS (
    SELECT 
        YEAR(sale_date) AS S_YEAR,
        MONTH(sale_date) AS S_MONTH,
        AVG(total_sale) AS Avg_sale
    FROM Retail_salesData
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)

SELECT *,
       RANK() OVER (PARTITION BY S_YEAR ORDER BY Avg_sale DESC) AS Rank_
FROM MonthlySales;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
TOP 5 customer_id,
SUM(total_sale) AS Total_sales
FROM Retail_salesData
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT 
	category,
	COUNT( DISTINCT customer_id) AS Customer
FROM Retail_salesData
GROUP BY category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

;WITH hourly_sale AS (
    SELECT *,
        CASE 
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM Retail_salesData
)

SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

--- end of project