/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH product_yearly_sales AS (

SELECT
	YEAR(f.order_date) AS order_date,
	p.product_name,
	SUM(f.sales_amount) AS current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key  = p.product_key
  WHERE f.order_date IS NOT NULL
    GROUP BY 
        YEAR(f.order_date),
        p.product_name
)
SELECT
    order_date,
    product_name,
    current_sales,
	AVG(current_sales) OVER(PARTITION BY product_name ) AS avg_sales ,
	CASE
	WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name ) > 0 THEN 'Above avg'
	WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name ) < 0 THEN 'Below avg'
	ELSE 'Avg'
	END AS avg_change,
	-- Year-over-Year Analysis
	LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date) AS py_sales,
	current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date) AS diff_py,
	CASE 
	WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date) > 0 THEN 'Increase'
	WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date) < 0 THEN 'Decrease'
	ELSE 'No Change'
	END AS py_change
FROM product_yearly_sales
ORDER BY product_name, order_date;