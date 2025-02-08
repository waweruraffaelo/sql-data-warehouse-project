/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================

IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS


WITH customer_report AS (

SELECT
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_key,
	customer_number,
	CONCAT(first_name, ' ' , last_name) AS  customer_name,
	DATEDIFF(YEAR, c.birthdate,GETDATE()) AS age
FROM gold.fact_sales f
LEFT JOIN  gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL
), customer_aggregation AS (
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
	DATEDIFF(MONTH, MIN(order_date),MAX(order_date)) AS life_span
FROM customer_report
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age
)

SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE
		WHEN age < 20 THEN 'Below 20'
		WHEN age BETWEEN 20 AND 29 THEN '20 -29'
		WHEN age BETWEEN 30 AND 39 THEN '30 -39'
		WHEN age BETWEEN 40 AND 49 THEN '30 -49'
		ELSE '50 and above'
	END AS age_group,
	CASE 
		WHEN life_span > = 12 AND total_sales >5000 THEN 'VIP'
		WHEN life_span > = 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segmentation,
	last_order_date,
	DATEDIFF(MONTH,last_order_date,GETDATE()) AS recency,
	total_orders,
	total_sales,
	total_quantity,
	total_products
	life_span,
	-- Compuate average order value (AVO)
-- Compuate average order value (AVO)
CASE WHEN total_sales = 0 THEN 0
	 ELSE total_sales / total_orders
END AS avg_order_value,
-- Compuate average monthly spend
CASE WHEN life_span = 0 THEN total_sales
     ELSE total_sales / life_span
END AS avg_monthly_spend

FROM customer_aggregation


