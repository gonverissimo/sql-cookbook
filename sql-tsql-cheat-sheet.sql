-- ==========================================================
-- SQL / T-SQL SUMMARY - Fundamentals and Important Features
-- ==========================================================
-- This file presents the main commands, concepts, and examples
-- for practical use in SQL Server (T-SQL) and relational databases.

-- 1. SQL LANGUAGES
-- ----------------
-- DDL (Data Definition Language): Defines and alters the DB structure
--   CREATE, ALTER, DROP, TRUNCATE, RENAME
-- DML (Data Manipulation Language): Manipulates data
--   SELECT, INSERT, UPDATE, DELETE, MERGE
-- DCL (Data Control Language): Controls permissions
--   GRANT, REVOKE
-- TCL (Transaction Control Language): Controls transactions
--   BEGIN TRANSACTION, COMMIT, ROLLBACK, SAVEPOINT


-- 2. CREATING AND ALTERING OBJECTS
-- --------------------------------
-- Create table:
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    Age INT,
    RegistrationDate DATETIME DEFAULT GETDATE()
);

-- Alter table (add column):
ALTER TABLE Customers
ADD Phone NVARCHAR(20);

-- Drop table:
DROP TABLE Customers;

-- Truncate table (delete data, keep structure):
TRUNCATE TABLE Customers;

-- Rename table (SQL Server 2016+):
EXEC sp_rename 'Customers', 'Active_Customers';


-- 3. COMMON DATA TYPES
-- ---------------------
-- INT, BIGINT, SMALLINT, TINYINT (integer numbers)
-- DECIMAL(p,s), NUMERIC(p,s) (decimal numbers with precision)
-- FLOAT, REAL (floating point)
-- CHAR(n), VARCHAR(n), NVARCHAR(n) (text)
-- DATETIME, DATE, TIME, DATETIME2, SMALLDATETIME (dates and times)
-- BIT (boolean 0/1)
-- UNIQUEIDENTIFIER (GUID)


-- 4. BASIC QUERIES (SELECT)
-- --------------------------
-- Select all:
SELECT * FROM Customers;

-- Select specific columns:
SELECT Name, Email FROM Customers;

-- Filters with WHERE:
SELECT * FROM Customers WHERE Age >= 18;

-- Order results:
SELECT * FROM Customers ORDER BY Name ASC, Age DESC;

-- Limit results (TOP N):
SELECT TOP 10 * FROM Customers ORDER BY RegistrationDate DESC;

-- Distinct values:
SELECT DISTINCT Age FROM Customers;


-- 5. INSERT, UPDATE, DELETE DATA
-- -------------------------------
-- Insert one row:
INSERT INTO Customers (Name, Email, Age) VALUES ('Anna', 'anna@mail.com', 30);

-- Insert multiple rows:
INSERT INTO Customers (Name, Email, Age) VALUES
('Peter', 'peter@mail.com', 25),
('Mary', 'mary@mail.com', 28);

-- Update data:
UPDATE Customers SET Age = Age + 1 WHERE Name = 'Anna';

-- Delete data:
DELETE FROM Customers WHERE Age < 18;


-- 6. JOINS
-- ---------
-- Used to combine data from two or more related tables

-- INNER JOIN: only matching rows in both tables
SELECT c.Name, o.OrderID, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- LEFT JOIN: all from left + matching from right (NULL if none)
SELECT c.Name, o.OrderID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- RIGHT JOIN: all from right + matching from left
SELECT c.Name, o.OrderID
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- FULL OUTER JOIN: all rows from both tables
SELECT c.Name, o.OrderID
FROM Customers c
FULL OUTER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- CROSS JOIN: Cartesian product (all possible combinations)
SELECT c.Name, o.OrderID
FROM Customers c
CROSS JOIN Orders o;


-- 7. SUBQUERIES
-- --------------
-- Query inside another query

-- Example: Customers with age greater than average
SELECT Name, Age
FROM Customers
WHERE Age > (SELECT AVG(Age) FROM Customers);

-- Subquery in FROM (derived table)
SELECT AvgAge
FROM (SELECT AVG(Age) AS AvgAge FROM Customers) AS Sub;

-- Correlated subquery (depends on outer query row)
SELECT Name,
       (SELECT COUNT(*) FROM Orders o WHERE o.CustomerID = c.CustomerID) AS TotalOrders
FROM Customers c;


-- 8. AGGREGATE FUNCTIONS AND GROUPING
-- ------------------------------------
-- SUM, COUNT, AVG, MIN, MAX
SELECT COUNT(*) AS TotalCustomers FROM Customers;

SELECT Age, COUNT(*) AS NumCustomers
FROM Customers
GROUP BY Age
HAVING COUNT(*) > 1;  -- Filter groups


-- 9. CONDITIONAL EXPRESSIONS
-- ---------------------------
-- CASE - similar to if-then-else
SELECT Name,
       CASE
           WHEN Age < 18 THEN 'Minor'
           WHEN Age BETWEEN 18 AND 65 THEN 'Adult'
           ELSE 'Senior'
       END AS AgeGroup
FROM Customers;


-- 10. TRANSACTIONS
-- -----------------
-- Ensure atomicity (all or nothing) in a sequence of commands

BEGIN TRANSACTION;

UPDATE Customers SET Age = Age + 1 WHERE Name = 'Anna';

-- Confirm changes
COMMIT;

-- Revert changes
-- ROLLBACK;


-- 11. INDEXES
-- ------------
-- Improve search and sorting performance

-- Create clustered index (physically organizes data)
CREATE CLUSTERED INDEX idx_CustomerID ON Customers(CustomerID);

-- Create non-clustered index
CREATE NONCLUSTERED INDEX idx_Name ON Customers(Name);

-- Drop index
DROP INDEX idx_Name ON Customers;


-- 12. VIEWS
-- ----------
-- Virtual tables based on a query
CREATE VIEW vw_AdultCustomers AS
SELECT * FROM Customers WHERE Age >= 18;

-- Use the view
SELECT * FROM vw_AdultCustomers;

-- Update a simple view
CREATE OR ALTER VIEW vw_ActiveCustomers AS
SELECT CustomerID, Name, Email FROM Customers WHERE RegistrationDate > '2024-01-01';


-- 13. STORED PROCEDURES
-- ---------------------
-- Predefined SQL code blocks for reuse

-- Create procedure
CREATE PROCEDURE sp_GetAdultCustomers
AS
BEGIN
    SELECT * FROM Customers WHERE Age >= 18;
END;
GO

-- Execute procedure
EXEC sp_GetAdultCustomers;

-- Procedure with parameters
CREATE PROCEDURE sp_GetCustomerByID
    @CustomerID INT
AS
BEGIN
    SELECT * FROM Customers WHERE CustomerID = @CustomerID;
END;
GO

EXEC sp_GetCustomerByID 5;


-- 14. USER-DEFINED FUNCTIONS
-- ---------------------------
-- Scalar functions (return a single value)
CREATE FUNCTION fn_GetAverageAge()
RETURNS FLOAT
AS
BEGIN
    DECLARE @avg FLOAT;
    SELECT @avg = AVG(CAST(Age AS FLOAT)) FROM Customers;
    RETURN @avg;
END;
GO

-- Use function
SELECT dbo.fn_GetAverageAge() AS AverageAge;


-- 15. TRIGGERS
-- -------------
-- Code executed automatically in response to DML events (INSERT, UPDATE, DELETE)

CREATE TRIGGER trg_AfterInsertCustomer
ON Customers
AFTER INSERT
AS
BEGIN
    PRINT 'New customer inserted';
    -- Example: insert log, validations, notifications
END;
GO


-- 16. CURSORS
-- ------------
-- Allows row-by-row processing over a result set (use sparingly)

DECLARE cursor_customers CURSOR FOR
SELECT CustomerID, Name FROM Customers WHERE Age >= 18;

DECLARE @CustomerID INT, @Name NVARCHAR(100);

OPEN cursor_customers;
FETCH NEXT FROM cursor_customers INTO @CustomerID, @Name;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Customer: ' + @Name;
    FETCH NEXT FROM cursor_customers INTO @CustomerID, @Name;
END;

CLOSE cursor_customers;
DEALLOCATE cursor_customers;


-- 17. VARIABLES AND FLOW CONTROL
-- -------------------------------
-- Declare variable
DECLARE @counter INT = 0;

-- WHILE loop
WHILE @counter < 5
BEGIN
    PRINT 'Counter = ' + CAST(@counter AS NVARCHAR(10));
    SET @counter = @counter + 1;
END;

-- IF ELSE
DECLARE @age INT = 20;
IF @age >= 18
    PRINT 'Adult';
ELSE
    PRINT 'Minor';


-- 18. TEMPORARY TABLES
-- ---------------------
-- Local temporary tables (exist only in session)
CREATE TABLE #TempCustomers (
    CustomerID INT,
    Name NVARCHAR(100)
);

INSERT INTO #TempCustomers VALUES (1, 'John'), (2, 'Mary');

SELECT * FROM #TempCustomers;

DROP TABLE #TempCustomers;


-- 19. WINDOW FUNCTIONS
-- --------------------
-- Functions that operate on a window of rows for advanced calculations

-- Example: calculate running average, ranking

SELECT CustomerID, Name, Age,
       ROW_NUMBER() OVER (ORDER BY Age DESC) AS Ranking,
       AVG(Age) OVER () AS AverageAge,
       SUM(Age) OVER (PARTITION BY Age) AS SumAgesSameGroup
FROM Customers;


-- 20. MERGE
-- ----------
-- Command to insert, update or delete data in target table according to source table

MERGE Customers AS target
USING (SELECT CustomerID, Name FROM CustomersTemp) AS source
ON target.CustomerID = source.CustomerID
WHEN MATCHED THEN
    UPDATE SET Name = source.Name
WHEN NOT MATCHED BY TARGET THEN
    INSERT (Name) VALUES (source.Name)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;


-- 21. PERMISSION CONTROL
-- ----------------------
-- Grant and revoke permissions

GRANT SELECT ON Customers TO UserX;
REVOKE SELECT ON Customers FROM UserX;


-- 22. SETTINGS AND UTILITIES
-- ---------------------------
-- Example: SET NOCOUNT to avoid "x rows affected" messages
SET NOCOUNT ON;

-- Get SQL Server version
SELECT @@VERSION;


-- ==============================
-- IMPORTANT TIPS AND NOTES
-- ==============================
-- - Use parameters in stored procedures to avoid SQL Injection
-- - Avoid cursors whenever possible; prefer set-based operations
-- - Use indexes to improve performance but avoid excessive indexing
-- - Transactions ensure atomicity and data integrity
-- - Views simplify complex queries and promote reuse
-- - Scalar functions should be used carefully to avoid performance hits
-- - Triggers are useful for auditing, validation, and automation
-- - Window functions are powerful for advanced analytics
-- - MERGE simplifies data synchronization between tables
-- - Always test scripts in development before production
