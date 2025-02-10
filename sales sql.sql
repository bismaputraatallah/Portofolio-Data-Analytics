-- Create database
CREATE DATABASE IF NOT EXISTS salesdatawalmart;

-- Create Table
CREATE TABLE IF NOT EXISTS sales(
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT DECIMAL(6, 4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_percentage DECIMAL(11, 9) NOT NULL,
    gross_income DECIMAL(12, 4) NOT NULL,
    rating DECIMAL(2, 1) NOT NULL
);

--  Feature Engineering

-- add table time_of_day
-- step 1
SELECT 
	time,
    (CASE WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening" END) AS time_of_date
FROM salesdatawalmart.sales;
-- step 2
ALTER TABLE salesdatawalmart.sales
ADD COLUMN time_of_day VARCHAR(20);
-- step 3
UPDATE salesdatawalmart.sales
SET time_of_day = (CASE 
        WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END);

-- add column day_name
-- step 1
SELECT
	date,
    DAYNAME (date)
FROM salesdatawalmart.sales;
-- step 2
ALTER TABLE salesdatawalmart.sales 
ADD COLUMN day_name VARCHAR (20);
-- step 3
UPDATE salesdatawalmart.sales 
SET day_name = DAYNAME (date)

-- add column month_name 
-- step 1
SELECT
	date,
    MONTHNAME (date)
FROM salesdatawalmart.sales;
-- step 2
ALTER TABLE salesdatawalmart.sales 
ADD COLUMN month_name VARCHAR (20);
-- step 3
UPDATE salesdatawalmart.sales 
SET month_name = MONTHNAME (date)

-- EDA
-- How many uniqe cities does the data have -----------
SELECT
	DISTINCT city
FROM salesdatawalmart.sales;

-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM  salesdatawalmart.sales;

-- How many unique product lines does the data have?
 SELECT 
	DISTINCT product_line
FROM  salesdatawalmart.sales;

-- What is the most common payment method? 
SELECT 
    payment_method,
    COUNT(product_line) AS number_of_payment
FROM salesdatawalmart.sales
GROUP BY payment_method
ORDER BY 2 DESC

-- What is the total revenue by month?
SELECT 
	MONTHNAME(date) AS month_name_number,
    SUM(total) AS total_gross_income
FROM salesdatawalmart.sales
GROUP BY month_name_number;

-- What month had the largest COGS?
 SELECT 
	monthname(date) AS month_cogs,
    SUM(cogs) AS number_cogs
FROM  salesdatawalmart.sales
GROUP BY 1

-- What is the most selling product line?
SELECT 
    product_line,
    COUNT(invoice_id) AS number_of_selling_product
FROM salesdatawalmart.sales
GROUP BY product_line
ORDER BY 2 DESC
LIMIT 1

-- What product line had the largest revenue?
 SELECT 
	product_line,
    SUM(total)
FROM  salesdatawalmart.sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- What is the city with the largest revenue?
SELECT 
	city,
    SUM(total)
FROM  salesdatawalmart.sales
GROUP BY 1
ORDER BY 2 DESC


-- What product line had the largest VAT?
SELECT 
	product_line,
    SUM(VAT)
FROM  salesdatawalmart.sales
GROUP BY 1
ORDER BY 2 DESC

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
    product_line,
    CASE 
        WHEN quantity > (SELECT AVG(quantity) FROM salesdatawalmart.sales) THEN 'Good'
        ELSE 'Bad' 
    END AS remark
FROM salesdatawalmart.sales;

-- Which branch sold more products than average product sold?
SELECT 
    branch,
    SUM(quantity) AS number_of_sold
FROM salesdatawalmart.sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM salesdatawalmart.sales);

-- Which customer type buys the most?
SELECT 
    customer_type,
    COUNT(customer_type) AS number_of_customers
FROM salesdatawalmart.sales
GROUP BY customer_type
ORDER BY number_of_customers DESC;

-- What is the most common product line by gender?
SELECT 
	gender,
    product_line,
    COUNT(gender) AS number_of_product
FROM salesdatawalmart.sales
GROUP BY 1, 2
ORDER BY 3











