SELECT * FROM interview_me.transactions_data_dummy;

-- Number of Transaction
SELECT COUNT(*) AS Total_Transactions
FROM transactions_data_dummy;

-- List the top 5 best-selling items based on the number of sales.
SELECT 
Item_Purchased,
SUM(Quantity) AS number_of_item
FROM transactions_data_dummy
WHERE Status = 'Completed'
GROUP BY Item_Purchased
ORDER BY SUM(Quantity) DESC
LIMIT 5;

-- Identify the day with the highest GMV and the day with the lowest GMV.
(
    SELECT 'Highest GMV' AS GMV_Type, 
           DATE(Date) AS Transaction_Date, 
           DAYNAME(Date) AS Day_Name,  
           SUM(Total_Spent) AS Total_GMV
    FROM transactions_data_dummy
    WHERE Status = 'Completed'
    GROUP BY DATE(Date), DAYNAME(Date)  
    ORDER BY Total_GMV DESC
    LIMIT 1
)
UNION ALL
(
    SELECT 'Lowest GMV' AS GMV_Type, 
           DATE(Date) AS Transaction_Date, 
           DAYNAME(Date) AS Day_Name,  
           SUM(Total_Spent) AS Total_GMV
    FROM transactions_data_dummy
    WHERE Status = 'Completed'
    GROUP BY DATE(Date), DAYNAME(Date)  
    ORDER BY Total_GMV ASC
    LIMIT 1
);

-- What is the average total spending (Total_Spent) per customer?
SELECT 
	User_ID,
    AVG(Total_Spent)
FROM transactions_data_dummy
WHERE Status = 'Completed'
GROUP BY User_ID
ORDER BY AVG(Total_Spent) DESC;

-- What percentage of customers made more than 3 transactions?
WITH Customer_Transaction_Count AS (
    SELECT User_ID, COUNT(*) AS Transaction_Count
    FROM transactions_data_dummy
    GROUP BY User_ID
)
SELECT 
    ROUND(
        (COUNT(CASE WHEN Transaction_Count > 3 THEN 1 END) * 100.0 / COUNT(*)), 
        2
    ) AS Percentage_Customers_More_Than_3_Transactions,
    ROUND(
        (COUNT(CASE WHEN Transaction_Count > 4 THEN 1 END) * 100.0 / COUNT(*)), 
        2
    ) AS Percentage_Customers_More_Than_4_Transactions,
        ROUND(
        (COUNT(CASE WHEN Transaction_Count > 5 THEN 1 END) * 100.0 / COUNT(*)), 
        2
    ) AS Percentage_Customers_More_Than_5_Transactions,
     ROUND(
        (COUNT(CASE WHEN Transaction_Count > 6 THEN 1 END) * 100.0 / COUNT(*)), 
        2
    ) AS Percentage_Customers_More_Than_6_Transactions,
     ROUND(
        (COUNT(CASE WHEN Transaction_Count > 7 THEN 1 END) * 100.0 / COUNT(*)), 
        2
    ) AS Percentage_Customers_More_Than_7_Transactions,
    ROUND(
        (COUNT(CASE WHEN Transaction_Count > 8 THEN 1 END) * 100.0 / COUNT(*)), 
        2
    ) AS Percentage_Customers_More_Than_8_Transactions
FROM Customer_Transaction_Count;

-- Analyze which payment method is most frequently used by customers.
SELECT Payment_Method,
	COUNT(Payment_Method) AS Number_of_Payment_Method
FROM transactions_data_dummy
GROUP BY Payment_Method
ORDER BY COUNT(Payment_Method) DESC
LIMIT 1;

-- Number of Transaction per Month
SELECT DISTINCT(MONTH(Date))
FROM transactions_data_dummy;


-- A bar chart displaying monthly GMV based on transaction dates.
SELECT MONTHNAME(Date) AS month_name, SUM(Total_Spent) AS Monthly_GMV
FROM transactions_data_dummy
WHERE Status = 'Completed'
GROUP BY 1;

-- Daily number of Transaction
SELECT 
	YEAR(Date),
    DATE(Date) AS Only_Date,
    COUNT(Transaction_ID)
FROM transactions_data_dummy
GROUP BY 1,2
ORDER BY 1 ASC;

-- Number of transaction customer 
SELECT 
	User_ID,
	COUNT(*)
FROM transactions_data_dummy
GROUP BY 1
ORDER BY 2 DESC;

-- Average daily transaction
SELECT AVG(transaction_count)
FROM (
    SELECT DATE(Date), COUNT(*) AS transaction_count
    FROM transactions_data_dummy
    GROUP BY 1
) AS subquery;

-- Average daily GMV 
SELECT AVG(Spent) AS Avg_Spent
FROM (
    SELECT DATE(Date), SUM(CASE WHEN Status = 'Completed' THEN Total_Spent ELSE 0 END) AS Spent
    FROM transactions_data_dummy
    GROUP BY 1
) AS subquery;

-- Best GMV Items
SELECT 
    Item_Purchased,
    COUNT(*) AS Number_Transactions,
    SUM(CASE WHEN Status = 'Completed' THEN Total_Spent ELSE 0 END) AS Total_Spent_Completed
FROM transactions_data_dummy
GROUP BY Item_Purchased
ORDER BY Total_Spent_Completed DESC;


-- Transaction and GMV per Costumer
SELECT 
    a.User_ID, 
    COALESCE(a.transaction_count, 0) AS transaction_count_completed,
    COALESCE(b.total_spent, 0) AS total_spent_all
FROM 
    (SELECT User_ID, COUNT(*) AS transaction_count
     FROM transactions_data_dummy
     WHERE Status = 'Completed'
     GROUP BY User_ID) a
LEFT JOIN 
    (SELECT User_ID, SUM(Total_Spent) AS total_spent
     FROM transactions_data_dummy
     GROUP BY User_ID) b
ON a.User_ID = b.User_ID
ORDER BY 3 DESC;

-- Number of transaction COmpleted and Failed, and How much it Total_Spent
(SELECT 
'Completed' AS Status,
COUNT(Status),
SUM(Total_Spent)
FROM transactions_data_dummy
WHERE Status ='Completed')
UNION ALL
(SELECT 
'Failed' AS Status,
COUNT(Status),
SUM(Total_Spent)
FROM transactions_data_dummy
WHERE Status ='Failed');
-- Give more percentage
WITH total_transactions AS (
    SELECT COUNT(*) AS total_count
    FROM transactions_data_dummy
)
SELECT 
    Status,
    COUNT(Status) AS transaction_count,
    SUM(Total_Spent) AS total_spent,
    ROUND(100.0 * COUNT(Status) / (SELECT total_count FROM total_transactions), 2) AS percentage
FROM transactions_data_dummy
WHERE Status IN ('Completed', 'Failed')
GROUP BY Status;







