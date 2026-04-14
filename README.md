# SQL-Retail-Sales-Data-Project

## Project Overview

**Project Title**:  SQL-Retail-Sales-Data-Project        
**Level**: Beginner  
**Database**: `SQL_PROJECT_1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database and answering specific business questions through SQL queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `SQL_PROJECT_1`.
- **Table Creation**: A table named `Retail_salesData` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE SQL_PROJECT_1;

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
```
- ** Error occurs **: Encountered a problem that my SQL version is not able to import data directli so i executed the 'Import Flat File' alternative, adjusted 
data types to resolve an issue with the time data, and successfully 
migrated the data into a staging table, ensuring compatibility before 
production load .

```sql
INSERT INTO Retail_salesData
( transactions_id,sale_date,sale_time,customer_id,gender,age,category,quantiy,price_per_unit,cogs,total_sale)
SELECT*
FROM [SQL - Retail Sales Analysis_utf ]

```


### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql

SELECT 
COUNT (*)
FROM Retail_salesData

SELECT *
FROM Retail_salesData
WHERE sale_time IS NULL OR transactions_id IS NULL OR sale_date IS NULL	OR customer_id IS NULL
OR  gender IS NULL	OR category IS NULL	OR  quantiy IS NULL	OR  price_per_unit IS NULL
OR  cogs IS NULL	OR  total_sale IS NULL ;
---
DELETE FROM Retail_salesData
WHERE sale_time IS NULL	OR 
	  transactions_id IS NULL	OR   sale_date IS NULL	OR  customer_id IS NULL	OR  gender IS NULL	OR
	  category IS NULL	OR  quantiy IS NULL	OR  price_per_unit IS NULL	OR  cogs IS NULL	OR
	  total_sale IS NULL ;

```
- **Some basic Business Analyst ques.

---HOW MANY SALES WE HAVE ?
```sql

SELECT 
COUNT (*) AS TOTAL_SALES
FROM Retail_salesData

```
--- HOW MANY UNIQUE CUSTOMERS WE HAVE ?
```sql

SELECT 
COUNT (DISTINCT customer_id) AS TOTAL_CUSTOMERS
FROM Retail_salesData

```
--- WHAT AND HOW MANY CATEGORY WE HAVE
```sql

SELECT 
DISTINCT category AS TOTAL_NO_CATEGORY
FROM Retail_salesData

SELECT 
COUNT (DISTINCT category) AS TOTAL_CATEGORY
FROM Retail_salesData

```
### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * 
FROM Retail_salesData
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT *
FROM Retail_salesData as RS
WHERE category = 'Clothing'
AND
MONTH(RS.sale_date) = 11
AND
YEAR(RS.sale_date) = 2022
AND
RS.quantiy >= 4
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT
	RS.category,
	SUM(RS.total_sale) AS Total_Sales
FROM Retail_salesData AS RS
GROUP BY RS.category
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
AVG(age) AS AVG_Age
FROM Retail_salesData AS RS
WHERE RS.category = 'Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT*
FROM Retail_salesData
WHERE total_sale >= 1000\
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT
category,
gender,
COUNT(transactions_id) AS Transactions
FROM Retail_salesData 
GROUP BY gender,category

```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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

```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
TOP 5 customer_id,
SUM(total_sale) AS Total_sales
FROM Retail_salesData
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC

```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql

SELECT 
	category,
	COUNT( DISTINCT customer_id) AS Customer
FROM Retail_salesData
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql

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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Author - Dev Agarwal

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, feel free to get in touch!


Thank you, and I look forward to connecting with you!
