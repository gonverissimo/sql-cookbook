USE DataWarehouseAnalytics
GO

-- ANALYZE SALES PERFORMANCE OVER TIME
SELECT
    order_date,
    SUM(sales_amount) AS total_Sales
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY order_date
ORDER BY order_date

SELECT
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_Sales
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

SELECT
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_Sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

SELECT
    MONTH(order_date) AS order_year,
    SUM(sales_amount) AS total_Sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date)

-- CALCULATE THE TOTAL SALES PER MONTH AND THE RUNNING TOTAL OF SALES OVER TIME
-- WINDOW FUNCTION
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
FROM (
    SELECT
        DATETRUNC(month, order_date) AS order_date,
        SUM(sales_amount) AS total_sales
    FROM [gold.fact_sales]
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
) t

-- RESET PER YEAR
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (PARTITION BY order_date ORDER BY order_date) AS running_total_sales
FROM (
    SELECT
        DATETRUNC(month, order_date) AS order_date,
        SUM(sales_amount) AS total_sales
    FROM [gold.fact_sales]
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
) t

-- ANALYZE THE YEARLY PERFORMANCE OF PRODUCTS BY COMPARING EACH PRODUCT'S SALES TO BOTH ITS AVERAGE SALES PERFORMANCE AND THE PREVIOUS YEAR'S SALES
WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM [gold.fact_sales] f
    LEFT JOIN [gold.dim_products] p ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(f.order_date), p.product_name
)
SELECT
    order_year,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
    CASE
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Average'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Average'
        ELSE 'Average'
    END AS avg_change
FROM yearly_product_sales
ORDER BY product_name, order_year

-- YEAR OVER YEAR ANALYSIS
WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM [gold.fact_sales] f
    LEFT JOIN [gold.dim_products] p ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(f.order_date), p.product_name
)
SELECT
    order_year,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
    CASE
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Average'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Average'
        ELSE 'Average'
    END AS avg_change,
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
    CASE
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
FROM yearly_product_sales
ORDER BY product_name, order_year

-- WHICH CATEGORIES CONTRIBUTE THE MOST TO OVERALL SALES
WITH category_sales AS (
    SELECT
        category,
        SUM(sales_amount) AS total_sales
    FROM [gold.fact_sales] f
    LEFT JOIN [gold.dim_products] p ON p.product_key = f.product_key
    GROUP BY category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2), '%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC

-- SEGMENT PRODUCTS INTO COST RANGES AND COUNT HOW MANY PRODUCTS FALL INTO EACH SEGMENT
WITH products_segment AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM [gold.dim_products]
)
SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM products_segment
GROUP BY cost_range
ORDER BY total_products DESC

-- DATA SEGMENTATION
-- GROUP CUSTOMERS INTO THREE SEGMENTS BASED ON THEIR SPENDING BEHAVIOR:
-- VIP: CUSTOMERS WITH AT LEAST 12 MONTHS OF HISTORY AND SPENDING MORE THAN 5000€
-- REGULAR: CUSTOMERS WITH AT LEAST 12 MONTHS OF HISTORY BUT SPENDING 5000€ OR LESS
-- NEW: CUSTOMERS WITH A LIFESPAN LESS THAN 12 MONTHS
-- AND FIND THE TOTAL NUMBER OF CUSTOMERS BY EACH GROUP
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM [gold.fact_sales] f
    LEFT JOIN [gold.dim_customers] c ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT 
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT
        customer_key,
        CASE
            WHEN lifespan > 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'REGULAR'
            ELSE 'NEW'
        END AS customer_segment
    FROM customer_spending
) t
GROUP BY customer_segment
ORDER BY total_customers DESC

-- CUSTOMER REPORT:
-- THIS REPORT CONSOLIDATES KEY CUSTOMER METRICS AND BEHAVIORS
-- HIGHLIGHTS:
-- 1. GATHERS ESSENTIAL FIELDS SUCH AS NAMES, AGES AND TRANSACTION DETAILS
-- 2. SEGMENTS CUSTOMERS INTO CATEGORIES (VIP, REGULAR, NEW) AND AGE GROUPS
-- 3. AGGREGATES CUSTOMER-LEVEL METRICS: TOTAL ORDERS, TOTAL SALES, TOTAL QUANTITY PURCHASED, TOTAL PRODUCTS, LIFESPAN IN MONTHS
-- 4. CALCULATES VALUABLE KPIS: RECENCY, AVERAGE ORDER VALUE AND AVERAGE MONTHLY SPEND

WITH base_query AS (
    -- 1. BASE QUERY: RETRIEVES CORE COLUMNS FROM TABLES
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        c.first_name,
        c.last_name,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.birthdate,
        DATEDIFF(year, c.birthdate, GETDATE()) AS age
    FROM [gold.fact_sales] f
    LEFT JOIN [gold.dim_customers] c ON c.customer_key = f.customer_key
    WHERE order_date IS NOT NULL
),
customer_aggregation AS (
    -- 3. AGGREGATES CUSTOMER-LEVEL METRICS
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY customer_key, customer_number, customer_name, age
)
-- 2. SEGMENTS CUSTOMERS INTO CATEGORIES
SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,
    CASE
        WHEN age < 20 THEN 'UNDER 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 AND ABOVE'
    END AS age_group,
    CASE
        WHEN lifespan > 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'REGULAR'
        ELSE 'NEW'
    END AS customer_segment,
    last_order_date,
    -- 4. CALCULATES VALUABLE KPIS. Recency first
    DATEDIFF(month, last_order_date, GETDATE()) AS recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,
    -- Compute average order value
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,
    -- Compute average monthly spend
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_montly_spend
FROM customer_aggregation