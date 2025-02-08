/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

WITH product_report AS (
SELECT
	    f.order_number,
        f.order_date,
		f.customer_key,
        f.sales_amount,
        f.quantity,
		p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL 
), product_segmentation AS
(
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
	DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS life_span,
	MAX(order_date) AS last_order_sales,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM product_report
GROUP BY
    product_key,
    product_name,
    category,
    subcategory,
    cost
)
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
	last_order_sales,
	DATEDIFF(MONTH,last_order_sales,GETDATE()) AS recency_in_months,
	CASE
	WHEN total_sales > 50000 THEN 'High Performance'
	WHEN total_sales <= 10000 THEN 'Mid-Range'
	ELSE 'Low-performance'
	END AS product_segment,
	life_span,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue,

	-- Average Monthly Revenue
	CASE
		WHEN life_span = 0 THEN total_sales
		ELSE total_sales / life_span
	END AS avg_monthly_revenue
	FROM product_segmentation

SELECT * FROM gold.report_products