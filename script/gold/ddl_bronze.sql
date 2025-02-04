/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO
CREATE VIEW gold.dim_customers AS
SELECT
ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	ci.cst_marital_status AS marital_status,
	ca.bdate AS birth_date,
	la.cntry AS country,
		CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr			---- Having CRM as master table
		ELSE COALESCE(ca.gen, 'n/a') 
	END AS gender,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON   ci.cst_key =ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid;

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO
CREATE VIEW gold.dim_products AS
SELECT 
ROW_NUMBER() OVER (ORDER BY pr.prd_start_dt,pr.prd_key ) AS product_key,
pr.prd_id AS product_id,
pr.prd_key AS product_number,
pr.prd_nm AS product_name,
pr.cat_id AS category_id,
pc.cat AS category,
pc.subcat AS sub_category,
pc.maintenance ,
pr.prd_cost AS cost,
pr.prd_line AS product_line,
pr.prd_start_dt AS start_date
FROM silver.crm_prd_info pr
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pr.cat_id = pc.id
WHERE pr.prd_end_dt IS NULL;
 --- Filter out product with end date (Historical data)
-- =============================================================================
-- Create Dimension: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO
CREATE VIEW gold.fact_sales AS
SELECT 
	cs.sls_ord_num AS order_number ,
	pr.product_number,
	ct.customer_id,
	cs.sls_order_dt AS order_date,
	cs.sls_ship_dt AS shipping_date,
	cs.sls_due_dt AS due_date,
	cs.sls_sales AS sales_amount,
	cs.sls_quantity AS quantity,
	cs.sls_price AS price
FROM silver.crm_sales_details cs
LEFT JOIN gold.dim_products pr
ON cs.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers ct
ON cs.sls_cust_id = ct.customer_id


