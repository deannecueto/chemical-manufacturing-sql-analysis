/*====================================================
Exploratory Data Analysis
Chemical Manufacturing Sales & Operations Database

The purpose of this script is to understand the
structure and characteristics of the dataset before
answering the business questions.
====================================================*/

/*====================================================
Database Overview
====================================================*/
-- Number of customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Number of products
SELECT COUNT(*) AS total_products
FROM products;

-- Number of orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Number of production batches 
SELECT COUNT(*) AS total_production_batches
FROM production_batches;

/*====================================================
Customer Exploration
====================================================*/
-- Customer distribution by industry
SELECT
    industry,
    COUNT(*) AS customers
FROM customers
GROUP BY industry
ORDER BY customers DESC;

-- Customer distribution by country 
SELECT
    country,
    COUNT(*) AS customers
FROM customers
GROUP BY country
ORDER BY customers DESC;

-- Customer tier distribution
SELECT
    customer_tier,
    COUNT(*) AS customers
FROM customers
GROUP BY customer_tier;

/*====================================================
Product Exploration
====================================================*/
-- Products per category 
SELECT
    category,
    COUNT(*) AS number_of_products
FROM products
GROUP BY category
ORDER BY number_of_products DESC;

-- Average selling price by category 
SELECT
    category,
    ROUND(AVG(selling_price_per_kg),2) AS avg_price_per_kg
FROM products
GROUP BY category
ORDER BY avg_price_per_kg DESC;

/*====================================================
Sales Exploration
====================================================*/
-- Revenue by product category 
SELECT
    p.category,
    ROUND(SUM(oi.quantity_kg * oi.unit_price),2) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- Orders by month 
SELECT
    MONTH(order_date) AS order_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY MONTH(order_date)
ORDER BY order_month;

-- Monthly revenue
SELECT
    MONTH(o.order_date) AS order_month,
    ROUND(SUM(oi.quantity_kg * oi.unit_price),2) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY MONTH(o.order_date)
ORDER BY order_month;

/*====================================================
Manufacturing Exploration
====================================================*/
-- Production volumer per plant
SELECT
    p.plant_name,
    ROUND(SUM(pb.quantity_produced_kg),2) AS quantity_produced
FROM production_batches pb
JOIN plants p
ON pb.plant_id = p.plant_id
GROUP BY p.plant_name
ORDER BY quantity_produced DESC;

-- Aveerage production cost per batch
SELECT
    p.plant_name,
    ROUND(AVG(pb.production_cost),2) AS avg_batch_cost
FROM production_batches pb
JOIN plants p
ON pb.plant_id = p.plant_id
GROUP BY p.plant_name;

/*====================================================
Supplier Exploration
====================================================*/
-- Number of raw materials supplied
SELECT
    s.supplier_name,
    COUNT(*) AS materials_supplied
FROM suppliers s
JOIN raw_materials rm
ON s.supplier_id = rm.supplier_id
GROUP BY s.supplier_name
ORDER BY materials_supplied DESC;


/*====================================================
Inventory Exploration
====================================================*/
-- Total inventory movement by product
SELECT
    p.product_name,
    ROUND(SUM(it.quantity_kg),2) AS total_quantity_moved
FROM inventory_transactions it
JOIN products p
ON it.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_moved DESC;

-- Inventory transactions by type
SELECT
    transaction_type,
    COUNT(*) AS transactions
FROM inventory_transactions
GROUP BY transaction_type;

/*====================================================
Quality Exploration
====================================================*/
-- Quality test pass rate
SELECT
    passed,
    COUNT(*) AS total_tests
FROM quality_tests
GROUP BY passed;

-- Average purity and yield
SELECT
    ROUND(AVG(purity_percent),2) AS avg_purity,
    ROUND(AVG(yield_percent),2) AS avg_yield
FROM quality_tests;