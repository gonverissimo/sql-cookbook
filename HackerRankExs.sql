-- 58 HackerRank SQL Exercices solved - Gonçalo Veríssimo
-- SQL Server

--Revising the Select Query I
--Query all columns for all American cities in the CITY table with populations larger than 100000. The CountryCode for America is USA.

SELECT *
FROM CITY
WHERE CountryCode = 'USA' AND Population > 100000

------------------------------------------------------------------------------------------------------------------------------------------

--Revising the Select Query II
--Query the NAME field for all American cities in the CITY table with populations larger than 120000. The CountryCode for America is USA.

SELECT NAME
FROM CITY
WHERE CountryCode = 'USA' and population > 120000

------------------------------------------------------------------------------------------------------------------------------------------

--Select All
--Query all columns (attributes) for every row in the CITY table.

SELECT *
FROM CITY

------------------------------------------------------------------------------------------------------------------------------------------

--Select By Id
--Query all columns for a city in CITY with the ID 1661.

SELECT *
FROM CITY
WHERE ID = '1661'

------------------------------------------------------------------------------------------------------------------------------------------

--Japanese Cities' Attributes
--Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.

SELECT *
FROM CITY
WHERE CountryCode = 'JPN'

------------------------------------------------------------------------------------------------------------------------------------------

--Japanese Cities' Names
--Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN.

SELECT NAME
FROM CITY
WHERE CountryCode = 'JPN'

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 1
--Query a list of CITY and STATE from the STATION table.

SELECT city, state
FROM STATION

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 2
--Query the following two values from the STATION table:
--The sum of all values in LAT_N rounded to a scale of 2 decimal places.
--The sum of all values in LONG_W rounded to a scale of 2 decimal places.

SELECT 
  CAST(ROUND(SUM(LAT_N), 2) AS DECIMAL(10, 2)) AS SumLat,
  CAST(ROUND(SUM(LONG_W), 2) AS DECIMAL(10, 2)) AS SumLong
FROM STATION;

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 3
--Query a list of CITY names from STATION for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer.

SELECT DISTINCT CITY
FROM STATION
WHERE ID % 2 = 0

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 4
--Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.

SELECT COUNT(city) - COUNT(DISTINCT city) AS difference
FROM STATION

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 5
--Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name).
--If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.

SELECT TOP 1 CITY, LEN(CITY) AS NAME_LENGTH
FROM STATION
ORDER BY LEN(CITY), CITY

SELECT TOP 1 CITY, LEN(CITY) AS NAME_LENGTH
FROM STATION
ORDER BY LEN(CITY) DESC, CITY

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 6
--Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.

SELECT DISTINCT city
FROM STATION
WHERE UPPER(LEFT(CITY, 1)) IN ('A', 'E', 'I', 'O', 'U');

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 7
--Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.

SELECT DISTINCT city
FROM STATION
WHERE UPPER(RIGHT(CITY,1)) in ('A','E','I','O','U')

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 8
--Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates.

SELECT DISTINCT city
FROM STATION
WHERE UPPER(RIGHT(CITY,1)) in ('A','E','I','O','U') AND UPPER(LEFT(CITY,1)) in ('A','E','I','O','U') 

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 9
--Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.

SELECT DISTINCT city
FROM STATION
WHERE UPPER(LEFT(CITY,1)) NOT in ('A','E','I','O','U')

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 10
--Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.

SELECT DISTINCT city
FROM STATION
WHERE UPPER(RIGHT(CITY,1)) not in ('A','E','I','O','U')

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 11
--Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.

SELECT DISTINCT city
FROM STATION
WHERE UPPER(LEFT(CITY,1)) not in ('A','E','I','O','U') OR UPPER(RIGHT(CITY,1)) not in ('A','E','I','O','U') 

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 12
--Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.

SELECT DISTINCT city
FROM STATION
WHERE UPPER(LEFT(CITY,1)) not in ('A','E','I','O','U') AND UPPER(RIGHT(CITY,1)) not in ('A','E','I','O','U') 

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 13
--Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than 387880 and less than 1372345. Truncate your answer to 4 decimal places.

SELECT CAST(FLOOR(SUM(LAT_N) * 10000) / 10000 AS DECIMAL(10,4)) AS TruncatedSum
FROM STATION
WHERE LAT_N BETWEEN 38.7880 AND 137.2345

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 14
--Query the greatest value of the Northern Latitudes (LAT_N) from STATION that is less than 1372345. Truncate your answer to 4 decimal places.

SELECT CAST(FLOOR(MAX(LAT_N) * 10000) / 10000 AS DECIMAL(10,4)) AS TruncatedSum
FROM STATION
WHERE LAT_N < 137.2345

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 15
--Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that is less than 1372345. Round your answer to 4 decimal places.

SELECT CAST(LONG_W AS DECIMAL(10,4)) 
FROM STATION
WHERE LAT_N = (
    SELECT MAX(LAT_N)
    FROM STATION
    WHERE LAT_N < 137.2345

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 16
--Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 387780. Round your answer to 4 decimal places.

SELECT FORMAT(MIN(LAT_N), 'N4')
FROM STATION
WHERE LAT_N > 38.7780

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 17
--Query the Western Longitude (LONG_W)where the smallest Northern Latitude (LAT_N) in STATION is greater than 387780. Round your answer to 4 decimal places.

SELECT CAST(LONG_W AS DECIMAL(10,4)) 
FROM STATION
WHERE LAT_N = (
    SELECT MIN(LAT_N)
    FROM STATION
    WHERE LAT_N > 38.7780

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 18
--Consider P1(a,b) and P2(c,d) to be two points on a 2D plane.
--a happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
--b happens to equal the minimum value in Western Longitude (LONG_W in STATION).
--c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
--d happens to equal the maximum value in Western Longitude (LONG_W in STATION).
--Query the Manhattan Distance between points P1 and P2 and round it to a scale of 4 decimal places.

SELECT 
  CAST(
    FLOOR(
      (ABS(MIN(LAT_N) - MAX(LAT_N)) + ABS(MIN(LONG_W) - MAX(LONG_W))) * 10000
    ) AS FLOAT
  ) / 10000 AS ManhattanDistance
FROM STATION

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 19
--Consider P1(a,c) and P2(b,d) to be two points on a 2D plane where (a,b) are the respective minimum and maximum values of Northern Latitude (LAT_N) and (c,d) are the respective minimum and maximum values of Western Longitude (LONG_W) in STATION.
--Query the Euclidean Distance between points P1 and P2 and format your answer to display 4 decimal digits.

SELECT round(sqrt(power(max(LAT_N) - min(LAT_N), 2) + power(max(LONG_W) - min(LONG_W), 2)), 4)
FROM STATION

------------------------------------------------------------------------------------------------------------------------------------------

--Weather Observation Station 20
--A median is defined as a number separating the higher half of a data set from the lower half.
--Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to 4 decimal places.

SELECT TOP 1 CAST(
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY LAT_N) OVER (), 4)
    AS DECIMAL(10,4)
) AS median_latitude
FROM STATION;

------------------------------------------------------------------------------------------------------------------------------------------

--Higher Than 75 Marks
--Query the Name of any student in STUDENTS who scored higher than 75 Marks. Order your output by the last three characters of each name.
--If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.

SELECT name
FROM STUDENTS
WHERE marks > 75
ORDER BY RIGHT(Name, 3), ID

------------------------------------------------------------------------------------------------------------------------------------------

--Employee Names
--Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.
--Employee_id is an employee's ID number, name is their name, months is the total number of months they've been working for the company, and salary is their monthly salary.

SELECT name
FROM EMPLOYEE
ORDER BY name

------------------------------------------------------------------------------------------------------------------------------------------

--Employee Salaries
--Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee having a salary greater than  per month who have been employees for less than  months.
--Sort your result by ascending employee_id.
--Employee_id is an employee's ID number, name is their name, months is the total number of months they've been working for the company, and salary is the their monthly salary.

SELECT name
FROM Employee
WHERE salary > 2000 AND months < 10

------------------------------------------------------------------------------------------------------------------------------------------

--Type of Triangle
--Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. Output one of the following statements for each record in the table:
--Equilateral: It's a triangle with  sides of equal length.
--Isosceles: It's a triangle with  sides of equal length.
--Scalene: It's a triangle with  sides of differing lengths.
--Not A Triangle: The given values of A, B, and C don't form a triangle.
--Each row in the table denotes the lengths of each of a triangle's three sides.

SELECT 
       CASE 
           WHEN A + B <= C OR A + C <= B OR B + C <= A THEN 'Not A Triangle'
           WHEN A = B AND B = C THEN 'Equilateral'
           WHEN A = B OR A = C OR B = C THEN 'Isosceles'
           ELSE 'Scalene'
       END AS Triangle_Type
FROM TRIANGLES

------------------------------------------------------------------------------------------------------------------------------------------

--The PADS
--Generate the following two result sets:
--Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession as a parenthetical (i.e.: enclosed in parentheses). For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).
--Query the number of ocurrences of each occupation in OCCUPATIONS. Sort the occurrences in ascending order, and output them in the following format:
--There are a total of [occupation_count] [occupation]s.
--where [occupation_count] is the number of occurrences of an occupation in OCCUPATIONS and [occupation] is the lowercase occupation name.
--If more than one Occupation has the same [occupation_count], they should be ordered alphabetically.
--Note: There will be at least two entries in the table for each type of occupation.

SELECT Name + '(' + LEFT(Occupation, 1) +')' 
FROM OCCUPATIONS
ORDER BY Name;

SELECT 'There are a total of ' + CAST(COUNT(*) AS VARCHAR) + ' ' + LOWER(Occupation) + 's.'
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY COUNT(*), Occupation

------------------------------------------------------------------------------------------------------------------------------------------

--Revising Aggregations - The Count Function
--Query a count of the number of cities in CITY having a Population larger than 100000.
SELECT count(*)
FROM CITY
Where population > 100000

------------------------------------------------------------------------------------------------------------------------------------------

--Revising Aggregations - The Sum Function
--Query the total population of all cities in CITY where District is California.

SELECT SUM(population)
FROM CITY
WHERE district = 'California'

------------------------------------------------------------------------------------------------------------------------------------------

--Revising Aggregations - Averages
--Query the average population of all cities in CITY where District is California.

SELECT AVG(population)
FROM CITY
WHERE district = 'California'

------------------------------------------------------------------------------------------------------------------------------------------
--Average Population
--Query the average population for all cities in CITY, rounded down to the nearest integer.

SELECT FLOOR(AVG(Population))
FROM CITY;

------------------------------------------------------------------------------------------------------------------------------------------

--Japan Population
--Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.

SELECT SUM(population)
FROM City
WHERE Countrycode = 'JPN'

------------------------------------------------------------------------------------------------------------------------------------------

--Population Density Difference
--Query the difference between the maximum and minimum populations in CITY.

SELECT (MAX(population) - MIN(population))
FROM City

------------------------------------------------------------------------------------------------------------------------------------------

--African Cities
--Given the CITY and COUNTRY tables, query the names of all cities where the CONTINENT is 'Africa'.
--Note: CITY.CountryCode and COUNTRY.Code are matching key columns.

SELECT city.name
FROM City
INNER JOIN COUNTRY ON CITY.CountryCode = COUNTRY.Code
WHERE Continent = 'Africa'

------------------------------------------------------------------------------------------------------------------------------------------

--Average Population of Each Continent
--Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer.
--Note: CITY.CountryCode and COUNTRY.Code are matching key columns.

SELECT COUNTRY.Continent, FLOOR(AVG(CITY.Population))
FROM Country
INNER JOIN CITY ON CITY.CountryCode = COUNTRY.Code
GROUP BY COUNTRY.Continent

------------------------------------------------------------------------------------------------------------------------------------------

--Population Census
--Given the CITY and COUNTRY tables, query the sum of the populations of all cities where the CONTINENT is 'Asia'.
--Note: CITY.CountryCode and COUNTRY.Code are matching key columns.

SELECT SUM(city.population)
FROM CITY
INNER JOIN COUNTRY ON CITY.CountryCode = COUNTRY.Code
WHERE country.continent = 'Asia'

------------------------------------------------------------------------------------------------------------------------------------------

--Top Earners
--We define an employee's total earnings to be their monthly "salary x months" worked, and the maximum total earnings to be the maximum total earnings for any employee in the Employee table.
--Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings.
--Then print these values as 2 space-separated integers.

SELECT MAX(total_earnings), COUNT(*)
FROM (
    SELECT salary * months AS total_earnings
    FROM Employee
) AS earnings
WHERE total_earnings = (
    SELECT MAX(salary * months)
    FROM Employee

------------------------------------------------------------------------------------------------------------------------------------------

--The Blunder
--Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, but did not realize her keyboard's 0 key was broken until after completing the calculation.
--She wants your help finding the difference between her miscalculation (using salaries with any zeros removed), and the actual average salary.
--Write a query calculating the amount of error (i.e.:actual-miscalculated  average monthly salaries), and round it up to the next integer.

SELECT CAST(
  CEILING(
    AVG(CAST(salary AS FLOAT)) - 
    AVG(CAST(REPLACE(CAST(salary AS VARCHAR), '0', '') AS FLOAT))
  ) AS INT
) AS error
FROM EMPLOYEES

------------------------------------------------------------------------------------------------------------------------------------------

--Draw The Triangle 1
--P(R) represents a pattern drawn by Julia in R rows.
--* * * * * 
--* * * * 
--* * * 
--* * 
--*
--Write a query to print the pattern P(20).

WITH pattern(n) AS (
    SELECT 20
    UNION ALL
    SELECT n - 1 FROM pattern WHERE n > 1
)
SELECT REPLICATE('* ', n)
FROM pattern

------------------------------------------------------------------------------------------------------------------------------------------

--Draw The Triangle 2
--P(R) represents a pattern drawn by Julia in R rows.
--* 
--* * 
--* * * 
--* * * * 
--* * * * *
--Write a query to print the pattern P(20).

WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 20
)
SELECT RTRIM(REPLICATE('* ', n)) AS Pattern
FROM Numbers

------------------------------------------------------------------------------------------------------------------------------------------

--Occupations
--Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation.
--The output should consist of four columns (Doctor, Professor, Singer, and Actor) in that specific order, with their respective names listed alphabetically under each column.
--Note: Print NULL when there are no more names corresponding to an occupation.

WITH RankedNames AS (
    SELECT
        Name,
        Occupation,
        ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
    FROM OCCUPATIONS
)

SELECT
    MAX(CASE WHEN Occupation = 'Doctor' THEN Name END) AS Doctor,
    MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
    MAX(CASE WHEN Occupation = 'Singer' THEN Name END) AS Singer,
    MAX(CASE WHEN Occupation = 'Actor' THEN Name END) AS Actor
FROM RankedNames
GROUP BY rn
ORDER BY rn

------------------------------------------------------------------------------------------------------------------------------------------

--Binary Tree Nodes
--You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.
--Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:
--Root: If node is root node.
--Leaf: If node is leaf node.
--Inner: If node is neither root nor leaf node.

SELECT
    N,
    CASE
        WHEN P IS NULL THEN 'Root'
        WHEN N NOT IN (SELECT P FROM BST WHERE P IS NOT NULL) THEN 'Leaf'
        ELSE 'Inner'
    END AS NodeType
FROM BST
ORDER BY N

------------------------------------------------------------------------------------------------------------------------------------------

--New Companies
--Amber's conglomerate corporation just acquired some new companies. Each of the companies follows this hierarchy: Founder-LeadManager-SeniorManager-Manager-Employee
--Write a query to print the company_code, founder name, total number of lead managers, total number of senior managers, total number of managers, and total number of employees. Order your output by ascending company_code.
--Notse:The tables may contain duplicate records.
--The company_code is string, so the sorting should not be numeric. For example, if the company_codes are C_1, C_2, and C_10, then the ascending company_codes will be C_1, C_10, and C_2.

SELECT
    c.company_code,
    c.founder,
    COUNT(DISTINCT lm.lead_manager_code) AS total_lead_managers,
    COUNT(DISTINCT sm.senior_manager_code) AS total_senior_managers,
    COUNT(DISTINCT m.manager_code) AS total_managers,
    COUNT(DISTINCT e.employee_code) AS total_employees
FROM Company c
LEFT JOIN Lead_Manager lm ON c.company_code = lm.company_code
LEFT JOIN Senior_Manager sm ON c.company_code = sm.company_code
LEFT JOIN Manager m ON c.company_code = m.company_code
LEFT JOIN Employee e ON c.company_code = e.company_code
GROUP BY c.company_code, c.founder
ORDER BY c.company_code

------------------------------------------------------------------------------------------------------------------------------------------

--Placements
--You are given three tables: Students, Friends and Packages.
--Students contains two columns: ID and Name. Friends contains two columns: ID and Friend_ID (ID of the ONLY best friend).
--Packages contains two columns: ID and Salary (offered salary in $ thousands per month).
--Write a query to output the names of those students whose best friends got offered a higher salary than them. Names must be ordered by the salary amount offered to the best friends.
--It is guaranteed that no two students got same salary offer.

SELECT s.Name
FROM Students s
JOIN Friends f ON s.ID = f.ID
JOIN Packages p ON s.ID = p.ID
JOIN Packages p2 ON f.Friend_ID = p2.ID
WHERE p2.Salary > p.Salary
ORDER BY p2.Salary

------------------------------------------------------------------------------------------------------------------------------------------

--Symmetric Pairs
--You are given a table, Functions, containing two columns: X and Y.
--Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs if X1 = Y2 and X2 = Y1.
--Write a query to output all such symmetric pairs in ascending order by the value of X. List the rows such that X1 <= Y1.

SELECT DISTINCT
    CASE WHEN f1.X < f1.Y THEN f1.X ELSE f1.Y END AS X1,
    CASE WHEN f1.X < f1.Y THEN f1.Y ELSE f1.X END AS Y1
FROM Functions f1
JOIN Functions f2 ON f1.X = f2.Y AND f1.Y = f2.X
WHERE f1.X <> f1.Y

UNION

SELECT
    X, Y
FROM Functions
GROUP BY X, Y
HAVING X = Y AND COUNT(*) > 1

ORDER BY X1

------------------------------------------------------------------------------------------------------------------------------------------

--Top Competitors
--Julia just finished conducting a coding contest, and she needs your help assembling the leaderboard!
--Write a query to print the respective hacker_id and name of hackers who achieved full scores for more than one challenge. Order your output in descending order by the total number of challenges in which the hacker earned a full score.
--If more than one hacker received full scores in same number of challenges, then sort them by ascending hacker_id.

WITH FullScore AS (
    SELECT DISTINCT
        s.hacker_id,
        s.challenge_id
    FROM
        Submissions s
        JOIN Challenges c ON s.challenge_id = c.challenge_id
        JOIN Difficulty d ON c.difficulty_level = d.difficulty_level
    WHERE
        s.score = d.score
)
SELECT
    h.hacker_id,
    h.name
FROM
    FullScore f
    JOIN Hackers h ON f.hacker_id = h.hacker_id
GROUP BY
    h.hacker_id,
    h.name
HAVING
    COUNT(DISTINCT f.challenge_id) > 1
ORDER BY
    COUNT(DISTINCT f.challenge_id) DESC,
    h.hacker_id ASC

------------------------------------------------------------------------------------------------------------------------------------------

--SQL Project Planning
--You are given a table, Projects, containing three columns: Task_ID, Start_Date and End_Date. It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table.
--If the End_Date of the tasks are consecutive, then they are part of the same project. Samantha is interested in finding the total number of different projects completed.
--Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order.
--If there is more than one project that have the same number of completion days, then order by the start date of the project.

WITH OrderedTasks AS (
    SELECT
        Task_ID,
        Start_Date,
        End_Date,
        LAG(End_Date) OVER (ORDER BY Start_Date) AS Prev_End_Date
    FROM Projects
),
Groups AS (
    SELECT
        Task_ID,
        Start_Date,
        End_Date,
        CASE 
            WHEN Prev_End_Date IS NULL OR DATEDIFF(day, Prev_End_Date, End_Date) > 1 THEN 1
            ELSE 0
        END AS NewGroupFlag
    FROM OrderedTasks
),
GroupNumber AS (
    SELECT
        Task_ID,
        Start_Date,
        End_Date,
        SUM(NewGroupFlag) OVER (ORDER BY Start_Date ROWS UNBOUNDED PRECEDING) AS GroupNum
    FROM Groups
)
SELECT
    MIN(Start_Date) AS Project_Start,
    MAX(End_Date) AS Project_End
FROM GroupNumber
GROUP BY GroupNum
ORDER BY 
    DATEDIFF(day, MIN(Start_Date), MAX(End_Date)) ASC,
    MIN(Start_Date) ASC

------------------------------------------------------------------------------------------------------------------------------------------

--Contest Leaderboard
--You did such a great job helping Julia with her last coding contest challenge that she wants you to work on this one, too!
--The total score of a hacker is the sum of their maximum scores for all of the challenges. Write a query to print the hacker_id, name, and total score of the hackers ordered by the descending score.
--If more than one hacker achieved the same total score, then sort the result by ascending hacker_id. Exclude all hackers with a total score of 0 from your result.

SELECT 
    h.hacker_id,
    h.name,
    SUM(max_scores.max_score) AS total_score
FROM 
    Hackers h
JOIN 
    (
        SELECT 
            hacker_id, 
            challenge_id, 
            MAX(score) AS max_score
        FROM 
            Submissions
        GROUP BY 
            hacker_id, challenge_id
    ) max_scores
ON h.hacker_id = max_scores.hacker_id
GROUP BY 
    h.hacker_id, h.name
HAVING 
    SUM(max_scores.max_score) > 0
ORDER BY 
    total_score DESC,
    h.hacker_id ASC

------------------------------------------------------------------------------------------------------------------------------------------

--Challenges
--Julia asked her students to create some coding challenges.
--Write a query to print the hacker_id, name, and the total number of challenges created by each student.
--Sort your results by the total number of challenges in descending order.
--If more than one student created the same number of challenges, then sort the result by hacker_id.
--If more than one student created the same number of challenges and the count is less than the maximum number of challenges created, then exclude those students from the result.

WITH ChallengeCounts AS (
    SELECT 
        c.hacker_id,
        COUNT(*) AS total_challenges
    FROM 
        Challenges c
    GROUP BY 
        c.hacker_id
),
MaxChallenges AS (
    SELECT MAX(total_challenges) AS max_challenges
    FROM ChallengeCounts
),
DuplicateCounts AS (
    SELECT total_challenges
    FROM ChallengeCounts
    GROUP BY total_challenges
    HAVING COUNT(*) > 1
),
FilteredHackers AS (
    SELECT cc.hacker_id, cc.total_challenges
    FROM ChallengeCounts cc
    CROSS JOIN MaxChallenges mc
    LEFT JOIN DuplicateCounts dc ON cc.total_challenges = dc.total_challenges
    WHERE 
        cc.total_challenges = mc.max_challenges
        OR dc.total_challenges IS NULL  -- keep only unique counts or max count
)
SELECT 
    fh.hacker_id,
    h.name,
    fh.total_challenges
FROM 
    FilteredHackers fh
JOIN 
    Hackers h ON fh.hacker_id = h.hacker_id
ORDER BY 
    fh.total_challenges DESC,
    fh.hacker_id ASC

------------------------------------------------------------------------------------------------------------------------------------------

--Ollivander's Inventory
--Harry Potter and his friends are at Ollivander's with Ron, finally replacing Charlie's old broken wand.
--Hermione decides the best way to choose is by determining the minimum number of gold galleons needed to buy each non-evil wand of high power and age.
--Write a query to print the id, age, coins_needed, and power of the wands that Ron's interested in, sorted in order of descending power.
--If more than one wand has same power, sort the result in order of descending age.

SELECT W.ID,
    WP.AGE,
    W.COINS_NEEDED,
    W.POWER,
    ROW_NUMBER() OVER (PARTITION BY WP.AGE, W.POWER ORDER BY W.COINS_NEEDED) AS [RN]
INTO WANDS_ALL
FROM WANDS W INNER JOIN WANDS_PROPERTY WP
ON W.CODE = WP.CODE
WHERE WP.IS_EVIL = 0

SELECT ID,
    AGE,
    COINS_NEEDED,
    POWER
FROM WANDS_ALL 
WHERE RN = 1
ORDER BY POWER DESC, AGE DESC

------------------------------------------------------------------------------------------------------------------------------------------

--The Report
--You are given two tables: Students and Grades. Students contains three columns ID, Name and Marks.
--Ketty gives Eve a task to generate a report containing three columns: Name, Grade and Mark. Ketty doesn't want the NAMES of those students who received a grade lower than 8.
--The report must be in descending order by grade -- i.e. higher grades are entered first. If there is more than one student with the same grade (8-10) assigned to them, order those particular students by their name alphabetically.
--Finally, if the grade is lower than 8, use "NULL" as their name and list them by their grades in descending order.
--If there is more than one student with the same grade (1-7) assigned to them, order those particular students by their marks in ascending order.
--Write a query to help Eve.

SELECT 
    CASE 
        WHEN Grade < 8 THEN NULL 
        ELSE Name 
    END AS Name,
    Grade,
    Marks
FROM 
    Students
JOIN 
    Grades 
    ON Marks BETWEEN Min_Mark AND Max_Mark
ORDER BY 
    Grade DESC, 
    Name

------------------------------------------------------------------------------------------------------------------------------------------

--Print Prime Numbers
--Write a query to print all prime numbers less than or equal to 1000. Print your result on a single line, and use the ampersand () character as your separator (instead of a space).

WITH ints AS (
    SELECT 2 AS num
    UNION ALL
    SELECT num + 1 
    FROM ints
    WHERE num < 1000
)

SELECT 
    STRING_AGG(num, '&') WITHIN GROUP (ORDER BY num) AS concat_result
FROM 
    ints
WHERE 
    num NOT IN (
        SELECT a.num
        FROM ints a
        JOIN ints b 
            ON FLOOR(SQRT(a.num)) >= b.num 
            AND a.num % b.num = 0
    )
OPTION (MAXRECURSION 1000)

------------------------------------------------------------------------------------------------------------------------------------------

--15 Days of Learning SQL
--Julia conducted a 15 days of learning SQL contest. The start date of the contest was March 01, 2016 and the end date was March 15, 2016.
-- Write a query to print total number of unique hackers who made at least 1 submission each day (starting on the first day of the contest), and find the hacker_id and name of the hacker who made maximum number of submissions each day.
--If more than one such hacker has a maximum number of submissions, print the lowest hacker_id.
--The query should print this information for each day of the contest, sorted by the date.

WITH
distinct_sub AS(
    SELECT DISTINCT submission_date, hacker_id
    FROM submissions),
sub_cnt AS(
    SELECT
        submission_date, 
    hacker_id,
        (
         SELECT COUNT(submission_date) 
     FROM distinct_sub t2
         WHERE t2.hacker_id = t1.hacker_id AND t2.submission_date <= t1.submission_date
        ) AS s_cnt
    FROM distinct_sub t1),
hacker_cnt AS(    
    SELECT submission_date, s_cnt, COUNT(*) AS h_cnt
    FROM sub_cnt
    GROUP BY submission_date, s_cnt
    HAVING s_cnt = DAY(submission_date)),

sub_ranked AS(
    SELECT 
        submission_date, s.hacker_id, h.name, COUNT(*) AS cnt,
        RANK() OVER(PARTITION BY s.submission_date ORDER BY COUNT(*) DESC, s.hacker_id) AS rnk
    FROM Submissions s JOIN Hackers h 
    ON s.hacker_id = h.hacker_id
    GROUP BY submission_date, s.hacker_id, h.name)
    
    
SELECT t3.submission_date, t3.h_cnt, t4.hacker_id, t4.name
FROM hacker_cnt t3 JOIN sub_ranked t4
ON t3.submission_date = t4.submission_date
WHERE t4.rnk = 1

------------------------------------------------------------------------------------------------------------------------------------------

--Interviews
--Samantha interviews many candidates from different colleges using coding challenges and contests. Write a query to print the contest_id, hacker_id, name, and the sums of total_submissions, total_accepted_submissions, total_views, and total_unique_views for each contest sorted by contest_id.
--Exclude the contest from the result if all four sums are 0.
--Note: A specific contest can be used to screen candidates at more than one college, but each college only holds  screening contest.

SELECT 
    c.contest_id, 
    c.hacker_id, 
    c.name, 
    COALESCE(SUM(ss.total_submissions), 0) AS total_submissions,
    COALESCE(SUM(ss.total_accepted_submissions), 0) AS total_accepted_submissions,
    COALESCE(SUM(vs.total_views), 0) AS total_views,
    COALESCE(SUM(vs.total_unique_views), 0) AS total_unique_views
FROM 
    contests c
JOIN 
    colleges co ON c.contest_id = co.contest_id
JOIN 
    challenges ch ON co.college_id = ch.college_id

LEFT JOIN (
    SELECT 
        challenge_id, 
        SUM(total_submissions) AS total_submissions,
        SUM(total_accepted_submissions) AS total_accepted_submissions
    FROM 
        submission_stats
    GROUP BY 
        challenge_id
) ss ON ch.challenge_id = ss.challenge_id

LEFT JOIN (
    SELECT 
        challenge_id, 
        SUM(total_views) AS total_views,
        SUM(total_unique_views) AS total_unique_views
    FROM 
        view_stats
    GROUP BY 
        challenge_id
) vs ON ch.challenge_id = vs.challenge_id

GROUP BY 
    c.contest_id, 
    c.hacker_id, 
    c.name
HAVING 
    COALESCE(SUM(ss.total_submissions), 0) > 0 OR
    COALESCE(SUM(ss.total_accepted_submissions), 0) > 0 OR
    COALESCE(SUM(vs.total_views), 0) > 0 OR
    COALESCE(SUM(vs.total_unique_views), 0) > 0
ORDER BY 
    c.contest_id