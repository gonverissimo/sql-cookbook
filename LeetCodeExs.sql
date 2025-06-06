-- 50 LeetCode SQL Exercices solved - Gonçalo Veríssimo
-- SQL Server

-- 1757. Recyclable and Low Fat Products
--Table: Products
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| product_id  | int     |
--| low_fats    | enum    |
--| recyclable  | enum    |
--+-------------+---------+
--product_id is the primary key (column with unique values) for this table.
--low_fats is an ENUM (category) of type ('Y', 'N') where 'Y' means this product is low fat and 'N' means it is not.
--recyclable is an ENUM (category) of types ('Y', 'N') where 'Y' means this product is recyclable and 'N' means it is not.

--Write a solution to find the ids of products that are both low fat and recyclable.
--Return the result table in any order.

SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y'

----------------------------------------------------------------------------------------------------------------------------

-- 584. Find Customer Referee
--Table: Customer
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| id          | int     |
--| name        | varchar |
--| referee_id  | int     |
--+-------------+---------+
--In SQL, id is the primary key column for this table.
--Each row of this table indicates the id of a customer, their name, and the id of the customer who referred them.

--Find the names of the customer that are not referred by the customer with id = 2.
--Return the result table in any order.

SELECT name
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL

----------------------------------------------------------------------------------------------------------------------------

--550. Game Play Analysis IV
--Table: Activity
--+--------------+---------+
--| Column Name  | Type    |
--+--------------+---------+
--| player_id    | int     |
--| device_id    | int     |
--| event_date   | date    |
--| games_played | int     |
--+--------------+---------+
--(player_id, event_date) is the primary key (combination of columns with unique values) of this table.
--This table shows the activity of players of some games.
--Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.

--Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places.
--In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date.
--Then divide that number by the total number of players.

WITH FirstLogin AS (
    SELECT player_id, MIN(event_date) AS first_login
    FROM Activity
    GROUP BY player_id
),
NextDayLogins AS (
    SELECT DISTINCT a.player_id
    FROM Activity a
    JOIN FirstLogin f
        ON a.player_id = f.player_id
       AND a.event_date = DATEADD(DAY, 1, f.first_login)
)
SELECT 
    ROUND(
        1.0 * COUNT(n.player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 
        2
    ) AS fraction
FROM NextDayLogins n

----------------------------------------------------------------------------------------------------------------------------

--2356. Number of Unique Subjects Taught by Each Teacher
--Table: Teacher
--+-------------+------+
--| Column Name | Type |
--+-------------+------+
--| teacher_id  | int  |
--| subject_id  | int  |
--| dept_id     | int  |
--+-------------+------+
--(subject_id, dept_id) is the primary key (combinations of columns with unique values) of this table.
--Each row in this table indicates that the teacher with teacher_id teaches the subject subject_id in the department dept_id.

--Write a solution to calculate the number of unique subjects each teacher teaches in the university.
--Return the result table in any order.

SELECT teacher_id, COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id

----------------------------------------------------------------------------------------------------------------------------

--1141. User Activity for the Past 30 Days I
--Table: Activity
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| user_id       | int     |
--| session_id    | int     |
--| activity_date | date    |
--| activity_type | enum    |
--+---------------+---------+

--This table may have duplicate rows.
--The activity_type column is an ENUM (category) of type ('open_session', 'end_session', 'scroll_down', 'send_message').
--The table shows the user activities for a social media website. 
--Note that each session belongs to exactly one user.
 
--Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively.
--A user was active on someday if they made at least one activity on that day.
--Return the result table in any order.

SELECT 
    activity_date AS day,
    COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date
ORDER BY activity_date

----------------------------------------------------------------------------------------------------------------------------

--1070. Product Sales Analysis III
--Table: Sales
--+-------------+-------+
--| Column Name | Type  |
--+-------------+-------+
--| sale_id     | int   |
--| product_id  | int   |
--| year        | int   |
--| quantity    | int   |
--| price       | int   |
--+-------------+-------+
--(sale_id, year) is the primary key (combination of columns with unique values) of this table.
--product_id is a foreign key (reference column) to Product table.
--Each row records a sale of a product in a given year.
--A product may have multiple sales entries in the same year.
--Note that the per-unit price.

--Write a solution to find all sales that occurred in the first year each product was sold.
--For each product_id, identify the earliest year it appears in the Sales table.
--Return all sales entries for that product in that year.
--Return a table with the following columns: product_id, first_year, quantity, and price.
--Return the result in any order.

SELECT 
    s.product_id,
    s.year AS first_year,
    s.quantity,
    s.price
FROM Sales s
JOIN (
    SELECT product_id, MIN(year) AS first_year
    FROM Sales
    GROUP BY product_id
) first_sales
ON s.product_id = first_sales.product_id
AND s.year = first_sales.first_year

----------------------------------------------------------------------------------------------------------------------------

--596. Classes With at Least 5 Students
--Table: Courses
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| student     | varchar |
--| class       | varchar |
--+-------------+---------+
--(student, class) is the primary key (combination of columns with unique values) for this table.
--Each row of this table indicates the name of a student and the class in which they are enrolled.
 
--Write a solution to find all the classes that have at least five students.
--Return the result table in any order.

SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student) >= 5

----------------------------------------------------------------------------------------------------------------------------

--1729. Find Followers Count
--Table: Followers
--+-------------+------+
--| Column Name | Type |
--+-------------+------+
--| user_id     | int  |
--| follower_id | int  |
--+-------------+------+
--(user_id, follower_id) is the primary key (combination of columns with unique values) for this table.
--This table contains the IDs of a user and a follower in a social media app where the follower follows the user.
 
--Write a solution that will, for each user, return the number of followers.
--Return the result table ordered by user_id in ascending order.

SELECT 
    user_id,
    COUNT(follower_id) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id ASC

----------------------------------------------------------------------------------------------------------------------------

--619. Biggest Single Number
--Table: MyNumbers
--+-------------+------+
--| Column Name | Type |
--+-------------+------+
--| num         | int  |
--+-------------+------+
--This table may contain duplicates (In other words, there is no primary key for this table in SQL).
--Each row of this table contains an integer.
--A single number is a number that appeared only once in the MyNumbers table.

--Find the largest single number. If there is no single number, report null.

SELECT MAX(num) AS num
FROM (
    SELECT num
    FROM MyNumbers
    GROUP BY num
    HAVING COUNT(*) = 1
) AS singles


----------------------------------------------------------------------------------------------------------------------------

--1045. Customers Who Bought All Products
--Table: Customer
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| customer_id | int     |
--| product_key | int     |
--+-------------+---------+
--This table may contain duplicates rows. 
--customer_id is not NULL.
--product_key is a foreign key (reference column) to Product table.
 
--Table: Product
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| product_key | int     |
--+-------------+---------+
--product_key is the primary key (column with unique values) for this table.
 
--Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.
--Return the result table in any order.

SELECT c.customer_id
FROM Customer c
INNER JOIN Product p ON c.product_key = p.product_key
GROUP BY c.customer_id
HAVING COUNT(DISTINCT c.product_key) = (SELECT COUNT(*) FROM Product)

----------------------------------------------------------------------------------------------------------------------------

--595. Big Countries
--Table: World
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| name        | varchar |
--| continent   | varchar |
--| area        | int     |
--| population  | int     |
--| gdp         | bigint  |
--+-------------+---------+
--name is the primary key (column with unique values) for this table.
--Each row of this table gives information about the name of a country, the continent to which it belongs, its area, the population, and its GDP value.
 
--A country is big if:
--it has an area of at least three million (i.e., 3000000 km2), or
--it has a population of at least twenty-five million (i.e., 25000000).

--Write a solution to find the name, population, and area of the big countries.
--Return the result table in any order.

SELECT name, population, area
FROM World
WHERE area >= 3000000 OR population >= 25000000

----------------------------------------------------------------------------------------------------------------------------

--1148. Article Views I
--Table: Views
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| article_id    | int     |
--| author_id     | int     |
--| viewer_id     | int     |
--| view_date     | date    |
--+---------------+---------+
--There is no primary key (column with unique values) for this table, the table may have duplicate rows.
--Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 
--Note that equal author_id and viewer_id indicate the same person.
 
--Write a solution to find all the authors that viewed at least one of their own articles.
--Return the result table sorted by id in ascending order.

SELECT DISTINCT author_id as id
FROM Views
WHERE author_id = viewer_id
ORDER BY id

----------------------------------------------------------------------------------------------------------------------------

--1683. Invalid Tweets
--Table: Tweets
--+----------------+---------+
--| Column Name    | Type    |
--+----------------+---------+
--| tweet_id       | int     |
--| content        | varchar |
--+----------------+---------+
--tweet_id is the primary key (column with unique values) for this table.
--content consists of alphanumeric characters, '!', or ' ' and no other special characters.
--This table contains all the tweets in a social media app.
 
--Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.
--Return the result table in any order.

SELECT tweet_id
FROM Tweets
WHERE LEN(content) > 15

----------------------------------------------------------------------------------------------------------------------------

--1378. Replace Employee ID With The Unique Identifier
--Table: Employees
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| id            | int     |
--| name          | varchar |
--+---------------+---------+
--id is the primary key (column with unique values) for this table.
--Each row of this table contains the id and the name of an employee in a company.
 
--Table: EmployeeUNI
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| id            | int     |
--| unique_id     | int     |
--+---------------+---------+
--(id, unique_id) is the primary key (combination of columns with unique values) for this table.
--Each row of this table contains the id and the corresponding unique id of an employee in the company.
 
--Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.
--Return the result table in any order.

SELECT a.name, b.unique_id
FROM Employees a
LEFT JOIN EmployeeUNI b ON a.id = b.id

----------------------------------------------------------------------------------------------------------------------------

--1068. Product Sales Analysis I
--Table: Sales

--+-------------+-------+
--| Column Name | Type  |
--+-------------+-------+
--| sale_id     | int   |
--| product_id  | int   |
--| year        | int   |
--| quantity    | int   |
--| price       | int   |
--+-------------+-------+
--(sale_id, year) is the primary key (combination of columns with unique values) of this table.
--product_id is a foreign key (reference column) to Product table.
--Each row of this table shows a sale on the product product_id in a certain year.
--Note that the price is per unit.
 
--Table: Product

--+--------------+---------+
--| Column Name  | Type    |
--+--------------+---------+
--| product_id   | int     |
--| product_name | varchar |
--+--------------+---------+
--product_id is the primary key (column with unique values) of this table.
--Each row of this table indicates the product name of each product.
 
--Write a solution to report the product_name, year, and price for each sale_id in the Sales table.
--Return the resulting table in any order.

SELECT b.product_name, a.year, a.price
FROM Sales a
JOIN Product b ON a.product_id = b.product_id

----------------------------------------------------------------------------------------------------------------------------

--1581. Customer Who Visited but Did Not Make Any Transactions
--Table: Visits
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| visit_id    | int     |
--| customer_id | int     |
--+-------------+---------+
--visit_id is the column with unique values for this table.
--This table contains information about the customers who visited the mall.
 
--Table: Transactions
--+----------------+---------+
--| Column Name    | Type    |
--+----------------+---------+
--| transaction_id | int     |
--| visit_id       | int     |
--| amount         | int     |
--+----------------+---------+
--transaction_id is column with unique values for this table.
--This table contains information about the transactions made during the visit_id.
 
--Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.
--Return the result table sorted in any order.

SELECT 
    v.customer_id,
    COUNT(*) AS count_no_trans
FROM 
    Visits v
LEFT JOIN 
    Transactions t ON v.visit_id = t.visit_id
WHERE 
    t.transaction_id IS NULL
GROUP BY 
    v.customer_id

----------------------------------------------------------------------------------------------------------------------------

--197. Rising Temperature
--Table: Weather
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| id            | int     |
--| recordDate    | date    |
--| temperature   | int     |
--+---------------+---------+
--id is the column with unique values for this table.
--There are no different rows with the same recordDate.
--This table contains information about the temperature on a certain day.
 
--Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).
--Return the result table in any order.

SELECT w1.id
FROM Weather w1
JOIN Weather w2
  ON w1.recordDate = DATEADD(day, 1, w2.recordDate)
WHERE w1.temperature > w2.temperature

----------------------------------------------------------------------------------------------------------------------------

--1661. Average Time of Process per Machine
--Table: Activity
--+----------------+---------+
--| Column Name    | Type    |
--+----------------+---------+
--| machine_id     | int     |
--| process_id     | int     |
--| activity_type  | enum    |
--| timestamp      | float   |
--+----------------+---------+
--The table shows the user activities for a factory website.
--(machine_id, process_id, activity_type) is the primary key (combination of columns with unique values) of this table.
--machine_id is the ID of a machine.
--process_id is the ID of a process running on the machine with ID machine_id.
--activity_type is an ENUM (category) of type ('start', 'end').
--timestamp is a float representing the current time in seconds.
--'start' means the machine starts the process at the given timestamp and 'end' means the machine ends the process at the given timestamp.
--The 'start' timestamp will always be before the 'end' timestamp for every (machine_id, process_id) pair.
--It is guaranteed that each (machine_id, process_id) pair has a 'start' and 'end' timestamp.
 
--There is a factory website that has several machines each running the same number of processes. Write a solution to find the average time each machine takes to complete a process.
--The time to complete a process is the 'end' timestamp minus the 'start' timestamp.
--The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.
--The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.
--Return the result table in any order.

SELECT 
    machine_id,
    ROUND(AVG(end_time - start_time), 3) AS processing_time
FROM (
    SELECT 
        machine_id,
        process_id,
        MAX(CASE WHEN activity_type = 'start' THEN timestamp END) AS start_time,
        MAX(CASE WHEN activity_type = 'end' THEN timestamp END) AS end_time
    FROM Activity
    GROUP BY machine_id, process_id
) AS process_times
GROUP BY machine_id

----------------------------------------------------------------------------------------------------------------------------

--577. Employee Bonus
--Table: Employee
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| empId       | int     |
--| name        | varchar |
--| supervisor  | int     |
--| salary      | int     |
--+-------------+---------+
--empId is the column with unique values for this table.
--Each row of this table indicates the name and the ID of an employee in addition to their salary and the id of their manager.
 
--Table: Bonus
--+-------------+------+
--| Column Name | Type |
--+-------------+------+
--| empId       | int  |
--| bonus       | int  |
--+-------------+------+
--empId is the column of unique values for this table.
--empId is a foreign key (reference column) to empId from the Employee table.
--Each row of this table contains the id of an employee and their respective bonus.
 
--Write a solution to report the name and bonus amount of each employee with a bonus less than 1000.
--Return the result table in any order.

SELECT e.name, b.bonus
FROM Employee e
LEFT JOIN Bonus b ON e.empId = b.empId
WHERE b.bonus < 1000 OR b.bonus IS NULL

----------------------------------------------------------------------------------------------------------------------------

--1280. Students and Examinations
--Table: Students
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| student_id    | int     |
--| student_name  | varchar |
--+---------------+---------+
--student_id is the primary key (column with unique values) for this table.
--Each row of this table contains the ID and the name of one student in the school.
 
--Table: Subjects
--+--------------+---------+
--| Column Name  | Type    |
--+--------------+---------+
--| subject_name | varchar |
--+--------------+---------+
--subject_name is the primary key (column with unique values) for this table.
--Each row of this table contains the name of one subject in the school.
 
--Table: Examinations
--+--------------+---------+
--| Column Name  | Type    |
--+--------------+---------+
--| student_id   | int     |
--| subject_name | varchar |
--+--------------+---------+
--There is no primary key (column with unique values) for this table. It may contain duplicates.
--Each student from the Students table takes every course from the Subjects table.
--Each row of this table indicates that a student with ID student_id attended the exam of subject_name.
 
--Write a solution to find the number of times each student attended each exam.
--Return the result table ordered by student_id and subject_name.

SELECT 
    s.student_id,
    s.student_name,
    subj.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects subj
LEFT JOIN Examinations e
    ON s.student_id = e.student_id AND subj.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, subj.subject_name
ORDER BY s.student_id, subj.subject_name

----------------------------------------------------------------------------------------------------------------------------

--570. Managers with at Least 5 Direct Reports
--Table: Employee
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| id          | int     |
--| name        | varchar |
--| department  | varchar |
--| managerId   | int     |
--+-------------+---------+
--id is the primary key (column with unique values) for this table.
--Each row of this table indicates the name of an employee, their department, and the id of their manager.
--If managerId is null, then the employee does not have a manager.
--No employee will be the manager of themself.
 
--Write a solution to find managers with at least five direct reports.
--Return the result table in any order.

SELECT e.name
FROM Employee e
WHERE e.id IN (
    SELECT managerId
    FROM Employee
    WHERE managerId IS NOT NULL
    GROUP BY managerId
    HAVING COUNT(*) >= 5
)

----------------------------------------------------------------------------------------------------------------------------

--1934. Confirmation Rate
--Table: Signups
--+----------------+----------+
--| Column Name    | Type     |
--+----------------+----------+
--| user_id        | int      |
--| time_stamp     | datetime |
--+----------------+----------+
--user_id is the column of unique values for this table.
--Each row contains information about the signup time for the user with ID user_id.

--Table: Confirmations
--+----------------+----------+
--| Column Name    | Type     |
--+----------------+----------+
--| user_id        | int      |
--| time_stamp     | datetime |
--| action         | ENUM     |
--+----------------+----------+
--(user_id, time_stamp) is the primary key (combination of columns with unique values) for this table.
--user_id is a foreign key (reference column) to the Signups table.
--action is an ENUM (category) of the type ('confirmed', 'timeout')
--Each row of this table indicates that the user with ID user_id requested a confirmation message at time_stamp and that confirmation message was either confirmed ('confirmed') or expired without confirming ('timeout').
 
--The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages.
--The confirmation rate of a user that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.

--Write a solution to find the confirmation rate of each user.
--Return the result table in any order.

SELECT 
    s.user_id,
    ROUND(
        ISNULL(
            CAST(SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) AS FLOAT) 
            / NULLIF(COUNT(c.action), 0),
            0
        ),
        2
    ) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c
    ON s.user_id = c.user_id
GROUP BY s.user_id

----------------------------------------------------------------------------------------------------------------------------

--620. Not Boring Movies
--Table: Cinema
--+----------------+----------+
--| Column Name    | Type     |
--+----------------+----------+
--| id             | int      |
--| movie          | varchar  |
--| description    | varchar  |
--| rating         | float    |
--+----------------+----------+
--id is the primary key (column with unique values) for this table.
--Each row contains information about the name of a movie, its genre, and its rating.
--rating is a 2 decimal places float in the range [0, 10]
 
--Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".
--Return the result table ordered by rating in descending order.

SELECT id, movie, description, rating
FROM Cinema
WHERE id % 2 = 1 AND description != 'boring'
ORDER BY rating desc

----------------------------------------------------------------------------------------------------------------------------

--1251. Average Selling Price
--Table: Prices
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| product_id    | int     |
--| start_date    | date    |
--| end_date      | date    |
--| price         | int     |
--+---------------+---------+
--(product_id, start_date, end_date) is the primary key (combination of columns with unique values) for this table.
--Each row of this table indicates the price of the product_id in the period from start_date to end_date.
--For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for the same product_id.
 
--Table: UnitsSold
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| product_id    | int     |
--| purchase_date | date    |
--| units         | int     |
--+---------------+---------+
--This table may contain duplicate rows.
--Each row of this table indicates the date, units, and product_id of each product sold. 
 
--Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places.
--If a product does not have any sold units, its average selling price is assumed to be 0.
--Return the result table in any order.

SELECT 
    p.product_id,
    ROUND(
        ISNULL(SUM(p.price * u.units) * 1.0 / NULLIF(SUM(u.units), 0), 0),
        2
    ) AS average_price
FROM Prices p
LEFT JOIN UnitsSold u
    ON p.product_id = u.product_id
    AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY p.product_id

----------------------------------------------------------------------------------------------------------------------------

--1075. Project Employees I
--Table: Project
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| project_id  | int     |
--| employee_id | int     |
--+-------------+---------+
--(project_id, employee_id) is the primary key of this table.
--employee_id is a foreign key to Employee table.
--Each row of this table indicates that the employee with employee_id is working on the project with project_id.
 
--Table: Employee
--+------------------+---------+
--| Column Name      | Type    |
--+------------------+---------+
--| employee_id      | int     |
--| name             | varchar |
--| experience_years | int     |
--+------------------+---------+
--employee_id is the primary key of this table. It's guaranteed that experience_years is not NULL.
--Each row of this table contains information about one employee.
 
--Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.
--Return the result table in any order.

SELECT 
    p.project_id,
    ROUND(AVG(e.experience_years * 1.0), 2) AS average_years
FROM Project p
JOIN Employee e
    ON p.employee_id = e.employee_id
GROUP BY p.project_id

----------------------------------------------------------------------------------------------------------------------------

--1633. Percentage of Users Attended a Contest
--Table: Users
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| user_id     | int     |
--| user_name   | varchar |
--+-------------+---------+
--user_id is the primary key (column with unique values) for this table.
--Each row of this table contains the name and the id of a user.
 
--Table: Register
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| contest_id  | int     |
--| user_id     | int     |
--+-------------+---------+
--(contest_id, user_id) is the primary key (combination of columns with unique values) for this table.
--Each row of this table contains the id of a user and the contest they registered into.
 
--Write a solution to find the percentage of the users registered in each contest rounded to two decimals.
--Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.

SELECT 
    r.contest_id,
    ROUND(COUNT(DISTINCT r.user_id) * 100.0 / (SELECT COUNT(*) FROM Users), 2) AS percentage
FROM Register r
GROUP BY r.contest_id
ORDER BY percentage DESC, contest_id ASC

----------------------------------------------------------------------------------------------------------------------------

--1211. Queries Quality and Percentage
--Table: Queries
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| query_name  | varchar |
--| result      | varchar |
--| position    | int     |
--| rating      | int     |
--+-------------+---------+
--This table may have duplicate rows.
--This table contains information collected from some queries on a database.
--The position column has a value from 1 to 500.
--The rating column has a value from 1 to 5. Query with rating less than 3 is a poor query.
 
--We define query quality as:
--The average of the ratio between query rating and its position.
--We also define poor query percentage as:
--The percentage of all queries with rating less than 3.

--Write a solution to find each query_name, the quality and poor_query_percentage.
--Both quality and poor_query_percentage should be rounded to 2 decimal places.
--Return the result table in any order.

SELECT
  query_name,
  ROUND(AVG(CAST(rating AS FLOAT) / position), 2) AS quality,
  ROUND(100.0 * SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) / COUNT(*), 2) AS poor_query_percentage
FROM Queries
GROUP BY query_name

----------------------------------------------------------------------------------------------------------------------------

--1193. Monthly Transactions I
--Table: Transactions
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| id            | int     |
--| country       | varchar |
--| state         | enum    |
--| amount        | int     |
--| trans_date    | date    |
--+---------------+---------+
--id is the primary key of this table.
--The table has information about incoming transactions.
--The state column is an enum of type ["approved", "declined"].
 
--Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.
--Return the result table in any order.

SELECT
  FORMAT(trans_date, 'yyyy-MM') AS month,
  country,
  COUNT(*) AS trans_count,
  SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
  SUM(amount) AS trans_total_amount,
  SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY FORMAT(trans_date, 'yyyy-MM'), country

----------------------------------------------------------------------------------------------------------------------------

--1174. Immediate Food Delivery II
--Table: Delivery
--+-----------------------------+---------+
--| Column Name                 | Type    |
--+-----------------------------+---------+
--| delivery_id                 | int     |
--| customer_id                 | int     |
--| order_date                  | date    |
--| customer_pref_delivery_date | date    |
--+-----------------------------+---------+
--delivery_id is the column of unique values of this table.
--The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).
 
--If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.
--The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.
--Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

WITH FirstOrders AS (
  SELECT
    customer_id,
    order_date,
    customer_pref_delivery_date
  FROM Delivery d1
  WHERE order_date = (
    SELECT MIN(order_date)
    FROM Delivery d2
    WHERE d2.customer_id = d1.customer_id
  )
)

SELECT
  ROUND(
    100.0 * SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) / COUNT(*),
    2
  ) AS immediate_percentage
FROM FirstOrders;

----------------------------------------------------------------------------------------------------------------------------

--1731. The Number of Employees Which Report to Each Employee
--Table: Employees
--+-------------+----------+
--| Column Name | Type     |
--+-------------+----------+
--| employee_id | int      |
--| name        | varchar  |
--| reports_to  | int      |
--| age         | int      |
--+-------------+----------+
--employee_id is the column with unique values for this table.
--This table contains information about the employees and the id of the manager they report to. Some employees do not report to anyone (reports_to is null). 
 
--For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.
--Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.
--Return the result table ordered by employee_id.

SELECT 
    e.employee_id,
    e.name,
    COUNT(r.employee_id) AS reports_count,
    ROUND(AVG(r.age * 1.0), 0) AS average_age
FROM 
    Employees e
JOIN 
    Employees r ON r.reports_to = e.employee_id
GROUP BY 
    e.employee_id, e.name
ORDER BY 
    e.employee_id;

----------------------------------------------------------------------------------------------------------------------------

--1789. Primary Department for Each Employee
--Table: Employee
--+---------------+---------+
--| Column Name   |  Type   |
--+---------------+---------+
--| employee_id   | int     |
--| department_id | int     |
--| primary_flag  | varchar |
--+---------------+---------+
--(employee_id, department_id) is the primary key (combination of columns with unique values) for this table.
--employee_id is the id of the employee.
--department_id is the id of the department to which the employee belongs.
--primary_flag is an ENUM (category) of type ('Y', 'N'). If the flag is 'Y', the department is the primary department for the employee. If the flag is 'N', the department is not the primary.
 
--Employees can belong to multiple departments. When the employee joins other departments, they need to decide which department is their primary department. Note that when an employee belongs to only one department, their primary column is 'N'.

--Write a solution to report all the employees with their primary department. For employees who belong to one department, report their only department.
--Return the result table in any order.

SELECT employee_id, department_id
FROM Employee
WHERE primary_flag = 'Y'

UNION

SELECT employee_id, department_id
FROM Employee
WHERE employee_id IN (
    SELECT employee_id
    FROM Employee
    GROUP BY employee_id
    HAVING COUNT(*) = 1
)

----------------------------------------------------------------------------------------------------------------------------

--610. Triangle Judgement
--Table: Triangle
--+-------------+------+
--| Column Name | Type |
--+-------------+------+
--| x           | int  |
--| y           | int  |
--| z           | int  |
--+-------------+------+
--In SQL, (x, y, z) is the primary key column for this table.
--Each row of this table contains the lengths of three line segments.
 
--Report for every three line segments whether they can form a triangle.
--Return the result table in any order.

SELECT 
    x, y, z,
    CASE 
        WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes'
        ELSE 'No'
    END AS triangle
FROM 
    Triangle

----------------------------------------------------------------------------------------------------------------------------

--1978. Employees Whose Manager Left the Company
--Table: Employees
--+-------------+----------+
--| Column Name | Type     |
--+-------------+----------+
--| employee_id | int      |
--| name        | varchar  |
--| manager_id  | int      |
--| salary      | int      |
--+-------------+----------+
--In SQL, employee_id is the primary key for this table.
--This table contains information about the employees, their salary, and the ID of their manager. Some employees do not have a manager (manager_id is null). 
 
--Find the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company.
--When a manager leaves the company, their information is deleted from the Employees table, but the reports still have their manager_id set to the manager that left.
--Return the result table ordered by employee_id.

SELECT e.employee_id
FROM Employees e
LEFT JOIN Employees m ON e.manager_id = m.employee_id
WHERE e.salary < 30000
  AND e.manager_id IS NOT NULL
  AND m.employee_id IS NULL
ORDER BY e.employee_id

 ----------------------------------------------------------------------------------------------------------------------------

--1667. Fix Names in a Table
--Table: Users
--+----------------+---------+
--| Column Name    | Type    |
--+----------------+---------+
--| user_id        | int     |
--| name           | varchar |
--+----------------+---------+
--user_id is the primary key (column with unique values) for this table.
--This table contains the ID and the name of the user. The name consists of only lowercase and uppercase characters.
 
--Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase.
--Return the result table ordered by user_id.

SELECT 
    user_id,
    UPPER(LEFT(name, 1)) + LOWER(SUBSTRING(name, 2, LEN(name))) AS name
FROM 
    Users
ORDER BY 
    user_id

----------------------------------------------------------------------------------------------------------------------------

--1527. Patients With a Condition
--Table: Patients
--+--------------+---------+
--| Column Name  | Type    |
--+--------------+---------+
--| patient_id   | int     |
--| patient_name | varchar |
--| conditions   | varchar |
--+--------------+---------+
--patient_id is the primary key (column with unique values) for this table.
--'conditions' contains 0 or more code separated by spaces. 
--This table contains information of the patients in the hospital.
 
--Write a solution to find the patient_id, patient_name, and conditions of the patients who have Type I Diabetes. Type I Diabetes always starts with DIAB1 prefix.
--Return the result table in any order.

SELECT patient_id, patient_name, conditions
FROM Patients
WHERE conditions LIKE 'DIAB1%'         
   OR conditions LIKE '% DIAB1%'   
   
----------------------------------------------------------------------------------------------------------------------------

--196. Delete Duplicate Emails
--Table: Person
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| id          | int     |
--| email       | varchar |
--+-------------+---------+
--id is the primary key (column with unique values) for this table.
--Each row of this table contains an email. The emails will not contain uppercase letters.
 
--Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.
--For SQL users, please note that you are supposed to write a DELETE statement and not a SELECT one.
--For Pandas users, please note that you are supposed to modify Person in place.
--After running your script, the answer shown is the Person table. The driver will first compile and run your piece of code and then show the Person table.
--The final order of the Person table does not matter.

WITH CTE AS (
    SELECT 
        id,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS rn
    FROM Person
)
DELETE FROM CTE WHERE rn > 1

----------------------------------------------------------------------------------------------------------------------------

--176. Second Highest Salary
--Table: Employee
--+-------------+------+
--| Column Name | Type |
--+-------------+------+
--| id          | int  |
--| salary      | int  |
--+-------------+------+
--id is the primary key (column with unique values) for this table.
--Each row of this table contains information about the salary of an employee.
 
--Write a solution to find the second highest distinct salary from the Employee table. If there is no second highest salary, return null (return None in Pandas).

WITH RankedSalaries AS (
    SELECT 
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM Employee
)
SELECT 
    MAX(salary) AS SecondHighestSalary
FROM RankedSalaries
WHERE rnk = 2

----------------------------------------------------------------------------------------------------------------------------

--1484. Group Sold Products By The Date
--Table Activities:
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| sell_date   | date    |
--| product     | varchar |
--+-------------+---------+
--There is no primary key (column with unique values) for this table. It may contain duplicates.
--Each row of this table contains the product name and the date it was sold in a market.
 
--Write a solution to find for each date the number of different products sold and their names.
--The sold products names for each date should be sorted lexicographically.
--Return the result table ordered by sell_date.

WITH DistinctProducts AS (
    SELECT DISTINCT sell_date, product
    FROM Activities
)
SELECT
    sell_date,
    COUNT(product) AS num_sold,
    STRING_AGG(product, ',') WITHIN GROUP (ORDER BY product) AS products
FROM DistinctProducts
GROUP BY sell_date
ORDER BY sell_date

----------------------------------------------------------------------------------------------------------------------------

--1327. List the Products Ordered in a Period
--Table: Products
--+------------------+---------+
--| Column Name      | Type    |
--+------------------+---------+
--| product_id       | int     |
--| product_name     | varchar |
--| product_category | varchar |
--+------------------+---------+
--product_id is the primary key (column with unique values) for this table.
--This table contains data about the company's products.
 
--Table: Orders
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| product_id    | int     |
--| order_date    | date    |
--| unit          | int     |
--+---------------+---------+
--This table may have duplicate rows.
--product_id is a foreign key (reference column) to the Products table.
--unit is the number of products ordered in order_date.
 
--Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.
--Return the result table in any order.

WITH FebOrders AS (
    SELECT 
        product_id,
        SUM(unit) AS total_units
    FROM Orders
    WHERE order_date >= '2020-02-01' AND order_date < '2020-03-01'
    GROUP BY product_id
    HAVING SUM(unit) >= 100
)
SELECT 
    p.product_name,
    f.total_units AS unit
FROM FebOrders f
JOIN Products p ON f.product_id = p.product_id

----------------------------------------------------------------------------------------------------------------------------

--1517. Find Users With Valid E-Mails
--Table: Users
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| user_id       | int     |
--| name          | varchar |
--| mail          | varchar |
--+---------------+---------+
--user_id is the primary key (column with unique values) for this table.
--This table contains information of the users signed up in a website. Some e-mails are invalid.
 
--Write a solution to find the users who have valid emails.
--A valid e-mail has a prefix name and a domain where:
--The prefix name is a string that may contain letters (upper or lower case), digits, underscore '_', period '.', and/or dash '-'. The prefix name must start with a letter.
--The domain is '@leetcode.com'.
--Return the result table in any order.

SELECT *
FROM Users
WHERE mail LIKE '[A-Za-z]%@leetcode.com'
    AND PATINDEX('%[^A-Za-z0-9\-\_\.\-]%@leetcode.com', mail) = 0

----------------------------------------------------------------------------------------------------------------------------

--180. Consecutive Numbers
--Table: Logs
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| id          | int     |
--| num         | varchar |
--+-------------+---------+
--In SQL, id is the primary key for this table.
--id is an autoincrement column starting from 1.
 
--Find all numbers that appear at least three times consecutively.
--Return the result table in any order.

SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs l1
JOIN Logs l2 ON l2.id = l1.id + 1
JOIN Logs l3 ON l3.id = l1.id + 2
WHERE l1.num = l2.num AND l2.num = l3.num

----------------------------------------------------------------------------------------------------------------------------

--1164. Product Price at a Given Date
--Table: Products
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| product_id    | int     |
--| new_price     | int     |
--| change_date   | date    |
--+---------------+---------+
--(product_id, change_date) is the primary key (combination of columns with unique values) of this table.
--Each row of this table indicates that the price of some product was changed to a new price at some date.
 
--Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.
--Return the result table in any order.

SELECT
    p.product_id,
    COALESCE(latest.new_price, 10) AS price
FROM
    (SELECT DISTINCT product_id FROM Products) p
OUTER APPLY (
    SELECT TOP 1 new_price
    FROM Products
    WHERE product_id = p.product_id AND change_date <= '2019-08-16'
    ORDER BY change_date DESC
) latest

----------------------------------------------------------------------------------------------------------------------------

--1204. Last Person to Fit in the Bus
--Table: Queue
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| person_id   | int     |
--| person_name | varchar |
--| weight      | int     |
--| turn        | int     |
--+-------------+---------+
--person_id column contains unique values.
--This table has the information about all people waiting for a bus.
--The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table.
--turn determines the order of which the people will board the bus, where turn=1 denotes the first person to board and turn=n denotes the last person to board.
--weight is the weight of the person in kilograms.
 
--There is a queue of people waiting to board a bus. However, the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.
--Write a solution to find the person_name of the last person that can fit on the bus without exceeding the weight limit
--The test cases are generated such that the first person does not exceed the weight limit.

WITH OrderedQueue AS (
    SELECT *, 
           SUM(weight) OVER (ORDER BY turn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_weight
    FROM Queue
)
SELECT TOP 1 person_name
FROM OrderedQueue
WHERE total_weight <= 1000
ORDER BY turn DESC

----------------------------------------------------------------------------------------------------------------------------

--1907. Count Salary Categories
--Table: Accounts
--+-------------+------+
--| Column Name | Type |
--+-------------+------+
--| account_id  | int  |
--| income      | int  |
--+-------------+------+
--account_id is the primary key (column with unique values) for this table.
--Each row contains information about the monthly income for one bank account.
 
--Write a solution to calculate the number of bank accounts for each salary category. The salary categories are:
--"Low Salary": All the salaries strictly less than $20000.
--"Average Salary": All the salaries in the inclusive range [$20000, $50000].
--"High Salary": All the salaries strictly greater than $50000.
--The result table must contain all three categories. If there are no accounts in a category, return 0.

--Return the result table in any order.

SELECT 'Low Salary' AS category, 
       COUNT(*) AS accounts_count
FROM Accounts
WHERE income < 20000

UNION ALL

SELECT 'Average Salary', 
       COUNT(*) 
FROM Accounts
WHERE income BETWEEN 20000 AND 50000

UNION ALL

SELECT 'High Salary', 
       COUNT(*) 
FROM Accounts
WHERE income > 50000

----------------------------------------------------------------------------------------------------------------------------

--626. Exchange Seats
--Table: Seat
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| id          | int     |
--| student     | varchar |
--+-------------+---------+
--id is the primary key (unique value) column for this table.
--Each row of this table indicates the name and the ID of a student.
--The ID sequence always starts from 1 and increments continuously.
 
--Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.
--Return the result table ordered by id in ascending order.

SELECT
    CASE
        WHEN id % 2 = 1 AND id + 1 <= (SELECT MAX(id) FROM Seat) THEN id + 1
        WHEN id % 2 = 0 THEN id - 1
        ELSE id
    END AS id,
    student
FROM Seat
ORDER BY id;

----------------------------------------------------------------------------------------------------------------------------

--1341. Movie Rating
--Table: Movies
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| movie_id      | int     |
--| title         | varchar |
--+---------------+---------+
--movie_id is the primary key (column with unique values) for this table.
--title is the name of the movie.

--Table: Users
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| user_id       | int     |
--| name          | varchar |
--+---------------+---------+
--user_id is the primary key (column with unique values) for this table.
--The column 'name' has unique values.

--Table: MovieRating
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| movie_id      | int     |
--| user_id       | int     |
--| rating        | int     |
--| created_at    | date    |
--+---------------+---------+
--(movie_id, user_id) is the primary key (column with unique values) for this table.
--This table contains the rating of a movie by a user in their review.
--created_at is the user's review date. 
 
--Write a solution to:
--Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
--Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.

WITH TopUser AS (
    SELECT TOP 1 u.name AS results
    FROM Users u
    JOIN MovieRating mr ON u.user_id = mr.user_id
    GROUP BY u.user_id, u.name
    ORDER BY COUNT(*) DESC, u.name
),
TopMovie AS (
    SELECT TOP 1 m.title AS results
    FROM Movies m
    JOIN MovieRating mr ON m.movie_id = mr.movie_id
    WHERE mr.created_at >= '2020-02-01' AND mr.created_at < '2020-03-01'
    GROUP BY m.movie_id, m.title
    ORDER BY AVG(CAST(mr.rating AS FLOAT)) DESC, m.title
)

SELECT * FROM TopUser
UNION ALL
SELECT * FROM TopMovie

----------------------------------------------------------------------------------------------------------------------------

--1321. Restaurant Growth
--Table: Customer
--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| customer_id   | int     |
--| name          | varchar |
--| visited_on    | date    |
--| amount        | int     |
--+---------------+---------+
--In SQL,(customer_id, visited_on) is the primary key for this table.
--This table contains data about customer transactions in a restaurant.
--visited_on is the date on which the customer with ID (customer_id) has visited the restaurant.
--amount is the total paid by a customer.
 
--You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).
--Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.
--Return the result table ordered by visited_on in ascending order.

WITH daily_amounts AS (
    SELECT
        visited_on,
        SUM(amount) AS amount
    FROM Customer
    GROUP BY visited_on
),
moving_sum AS (
    SELECT
        visited_on,
        SUM(amount) OVER (
            ORDER BY visited_on
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS amount
    FROM daily_amounts
)
SELECT
    visited_on,
    amount,
    ROUND(CAST(amount AS decimal(10,2)) / 7, 2) AS average_amount
FROM moving_sum
WHERE visited_on >= DATEADD(DAY, 6, (SELECT MIN(visited_on) FROM daily_amounts))
ORDER BY visited_on

----------------------------------------------------------------------------------------------------------------------------

--602. Friend Requests II: Who Has the Most Friends
--Table: RequestAccepted
--+----------------+---------+
--| Column Name    | Type    |
--+----------------+---------+
--| requester_id   | int     |
--| accepter_id    | int     |
--| accept_date    | date    |
--+----------------+---------+
--(requester_id, accepter_id) is the primary key (combination of columns with unique values) for this table.
--This table contains the ID of the user who sent the request, the ID of the user who received the request, and the date when the request was accepted.
 
--Write a solution to find the people who have the most friends and the most friends number.
--The test cases are generated so that only one person has the most friends.

WITH AllFriends AS (
    SELECT requester_id AS id, accepter_id AS friend_id FROM RequestAccepted
    UNION
    SELECT accepter_id AS id, requester_id AS friend_id FROM RequestAccepted
),
FriendCount AS (
    SELECT
        id,
        COUNT(DISTINCT friend_id) AS num
    FROM AllFriends
    GROUP BY id
),
MaxFriends AS (
    SELECT MAX(num) AS max_num FROM FriendCount
)
SELECT id, num
FROM FriendCount
WHERE num = (SELECT max_num FROM MaxFriends)

----------------------------------------------------------------------------------------------------------------------------

--585. Investments in 2016
--Table: Insurance
--+-------------+-------+
--| Column Name | Type  |
--+-------------+-------+
--| pid         | int   |
--| tiv_2015    | float |
--| tiv_2016    | float |
--| lat         | float |
--| lon         | float |
--+-------------+-------+
--pid is the primary key (column with unique values) for this table.
--Each row of this table contains information about one policy where:
--pid is the policyholder's policy ID.
--tiv_2015 is the total investment value in 2015 and tiv_2016 is the total investment value in 2016.
--lat is the latitude of the policy holder's city. It's guaranteed that lat is not NULL.
--lon is the longitude of the policy holder's city. It's guaranteed that lon is not NULL.

--Write a solution to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:
--have the same tiv_2015 value as one or more other policyholders, and
--are not located in the same city as any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).
--Round tiv_2016 to two decimal places.

WITH Tiv2015Duplicates AS (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
),
UniqueLocations AS (
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
)

SELECT
    ROUND(SUM(i.tiv_2016), 2) AS tiv_2016
FROM Insurance i
JOIN Tiv2015Duplicates t ON i.tiv_2015 = t.tiv_2015
JOIN UniqueLocations u ON i.lat = u.lat AND i.lon = u.lon;

----------------------------------------------------------------------------------------------------------------------------

--185. Department Top Three Salaries
--Pandas Schema
--Table: Employee
--+--------------+---------+
--| Column Name  | Type    |
--+--------------+---------+
--| id           | int     |
--| name         | varchar |
--| salary       | int     |
--| departmentId | int     |
--+--------------+---------+
--id is the primary key (column with unique values) for this table.
--departmentId is a foreign key (reference column) of the ID from the Department table.
--Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.
 
--Table: Department
--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| id          | int     |
--| name        | varchar |
--+-------------+---------+
--id is the primary key (column with unique values) for this table.
--Each row of this table indicates the ID of a department and its name.
 
--A company's executives are interested in seeing who earns the most money in each of the company's departments.
--A high earner in a department is an employee who has a salary in the top three unique salaries for that department.
--Write a solution to find the employees who are high earners in each of the departments.
--Return the result table in any order.

WITH RankedSalaries AS (
    SELECT 
        d.name AS Department,
        e.name AS Employee,
        e.salary AS Salary,
        DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) AS SalaryRank
    FROM Employee e
    JOIN Department d ON e.departmentId = d.id
)
SELECT
    Department,
    Employee,
    Salary
FROM RankedSalaries
WHERE SalaryRank <= 3