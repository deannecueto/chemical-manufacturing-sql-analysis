/*
===========================================
EXPLORATORY DATA ANALYSIS
===========================================

Business Question 1
Which products generate the highest revenue?

Business Question 2
Which customers generate the highest revenue?

Business Question 3
How do monthly sales and order volumes change over time?

Business Question 4
How do manufacturing plants compare in terms of production cost and cost efficiency?

Business Question 5
Which suppliers are associated with the highest quality defect rates?

Business Question 6
Which products experience the highest inventory movement?

Business Question 7
Which customers purchase the widest variety of products?

Business Question 8
How efficient is the order fulfillment process?

===========================================
*/

/*====================================================
Business Question 1:
Which products generate the highest revenue?
====================================================*/


SELECT p.product_name, ROUND(SUM(oi.quantity_kg*oi.unit_price), 2) AS revenue_per_product
FROM order_items AS oi 
JOIN products AS p
	ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue_per_product DESC;
 
 /*====================================================
Business Question 2:
Which customers generate the highest revenue?
- Average order value of customers also calculated and ranked
 ====================================================*/
 
 -- Determining customer revenue
 SELECT
    c.company_name,
    ROUND(SUM(oi.quantity_kg * oi.unit_price),2) AS total_revenue
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.company_name
ORDER BY total_revenue DESC;
 
 -- Determining whether revenue comes from many orders.
 SELECT
    c.company_name,
    COUNT(DISTINCT o.order_id) AS number_of_orders
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.company_name
ORDER BY number_of_orders DESC;
 
 -- Calculating average order value (AOV)
SELECT
    company_name,
    ROUND(total_revenue / number_of_orders,2) AS average_order_value
FROM (
    SELECT
        c.company_name,
        SUM(oi.quantity_kg * oi.unit_price) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS number_of_orders
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.company_name
) AS customer_summary
ORDER BY average_order_value DESC;

-- Quantity purchased
SELECT
    c.company_name,
    ROUND(SUM(oi.quantity_kg),2) AS total_quantity_purchased
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.company_name
ORDER BY total_quantity_purchased DESC;

-- Ranking AOV
SELECT
    c.customer_id, c.company_name, c.industry, c.country,
	ROUND(SUM(oi.quantity_kg * oi.unit_price), 2) AS total_revenue,
    DENSE_RANK() OVER (ORDER by SUM(oi.quantity_kg * oi.unit_price) DESC) AS revenue_rank,
    COUNT(DISTINCT oi.order_id) AS number_of_orders,
    ROUND(SUM(oi.quantity_kg * oi.unit_price) / COUNT(DISTINCT oi.order_id), 2) AS AOV,
    DENSE_RANK() OVER (ORDER by ROUND(SUM(oi.quantity_kg * oi.unit_price) / COUNT(DISTINCT oi.order_id)) DESC) AS AOV_rank
FROM order_items AS oi
JOIN orders AS o
    ON oi.order_id = o.order_id
JOIN customers AS c
	ON o.customer_id = c.customer_id
GROUP BY 
	c.customer_id, c.company_name, c.industry, c.country
ORDER BY total_revenue DESC;


/*====================================================
Business Question 3:
How do monthly sales and order volumes change over time?
====================================================*/ 

-- Orders by month
SELECT
    MONTH(order_date) AS month_orders,
    COUNT(*) AS number_of_orders
FROM orders
GROUP BY MONTH(order_date)
ORDER BY month_orders;

-- Revenue by month
SELECT
    MONTH(o.order_date) AS month_orders,
    ROUND(SUM(oi.quantity_kg * oi.unit_price),2) AS monthly_revenue
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY MONTH(o.order_date)
ORDER BY month_orders;

-- Ranking by number of orders and total revenue per month
SELECT 
	MONTH(order_date) AS month_orders, 
    COUNT(DISTINCT o.order_id) AS number_of_orders,
    DENSE_RANK () OVER(ORDER BY COUNT(DISTINCT o.order_id) DESC) AS monthly_orders_rank,
    ROUND(SUM(oi.quantity_kg * oi.unit_price), 2) AS total_revenue,
    DENSE_RANK() OVER (ORDER by SUM(oi.quantity_kg * oi.unit_price) DESC) AS revenue_rank
FROM orders AS o
LEFT JOIN order_items AS oi
	ON o.order_id = oi.order_id
GROUP BY MONTH(order_date);

/*====================================================
Business Question 4:
How do manufacturing plants compare in terms of production cost and cost efficiency?
====================================================*/
-- Production cost
SELECT
    plant_name,
    ROUND(SUM(production_cost),2) AS total_production_cost,
    COUNT(batch_id) AS production_batches,
    ROUND(AVG(production_cost),2) AS average_production_cost
FROM production_batches AS pb
JOIN plants AS p
    ON pb.plant_id = p.plant_id
GROUP BY plant_name;

-- Total quantity produced in kg
SELECT
    plant_name,
    ROUND(SUM(quantity_produced_kg),2) AS total_quantity_produced
FROM production_batches AS pb
JOIN plants AS p
    ON pb.plant_id = p.plant_id
GROUP BY plant_name;

-- Production cost per kg
SELECT 
	p.plant_id, p.plant_name, 
	ROUND(SUM(production_cost), 2) AS total_production_cost,
    COUNT(batch_id) AS production_batches,
    ROUND(AVG(production_cost), 2) AS avg_production_cost,
    ROUND(SUM(quantity_produced_kg), 2) AS total_quantity_produced_kg,
    ROUND(SUM(production_cost) / SUM(quantity_produced_kg), 2) AS production_cost_per_kg
FROM plants AS p
JOIN production_batches AS pb
	ON p.plant_id = pb.plant_id
GROUP BY p.plant_id, p.plant_name  
ORDER BY total_production_cost DESC  
;

/*====================================================
Business Question 5
Which suppliers are associated with the highest quality defect rates?
====================================================*/

SELECT *
FROM quality_tests
WHERE passed = 0;

-- Supplier-batch associations
SELECT DISTINCT
    rm.supplier_id,
    qt.batch_id,
    qt.passed
FROM quality_tests AS qt
JOIN batch_material_usage AS bmu
    ON qt.batch_id = bmu.batch_id
JOIN raw_materials AS rm
    ON bmu.material_id = rm.material_id;

-- Counting total supplier-batch associations and getting the defect rate
WITH supplier_batch_associations AS
(
SELECT DISTINCT
	rm.supplier_id, qt.batch_id, s.supplier_name, qt.passed 
FROM quality_tests AS qt 
JOIN batch_material_usage AS bmu 
	ON qt.batch_id = bmu.batch_id 
JOIN raw_materials AS rm 
	ON bmu.material_id = rm.material_id
JOIN suppliers AS s  
	ON rm.supplier_id = s.supplier_id
)
SELECT supplier_name,
	SUM(CASE WHEN passed = '0' THEN 1 ELSE 0 END) AS failed_associated_batches,
	COUNT(batch_id) AS total_associated_batches,
    ROUND(SUM(CASE WHEN passed = '0' THEN 1 ELSE 0 END) / COUNT(batch_id) * 100, 2) AS defect_rate
FROM supplier_batch_associations
GROUP BY supplier_name
ORDER BY defect_rate DESC
;

/*====================================================
Business Question 6
Which products experience the highest inventory movement?
====================================================*/
-- Inventory movement by transaction type
SELECT
    p.product_name,
    transaction_type,
    SUM(quantity_kg) AS quantity
FROM inventory_transactions AS it
JOIN products AS p
    ON it.product_id = p.product_id
GROUP BY
    p.product_name,
    transaction_type;
    
-- Total inventory movement
SELECT
    p.product_name,
    SUM(quantity_kg) AS total_inventory_movement
FROM inventory_transactions AS it
JOIN products AS p
    ON it.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_inventory_movement DESC;

-- Calculating net inventory change
SELECT 
	it.product_id, 
    product_name,
	SUM(CASE WHEN it.transaction_type = 'IN'
		THEN it.quantity_kg ELSE 0 END) AS total_in,
	SUM(CASE WHEN it.transaction_type = 'OUT'
		THEN it.quantity_kg ELSE 0 END) AS total_out,
	SUM(it.quantity_kg) AS total_movement, 
    SUM(CASE WHEN it.transaction_type = 'IN' THEN it.quantity_kg ELSE 0 END)
    -
    SUM(CASE WHEN it.transaction_type = 'OUT' THEN it.quantity_kg ELSE 0 END) 
    AS net_inventory_change
FROM inventory_transactions AS it
JOIN products AS p
	ON it.product_id = p.product_id
GROUP BY it.product_id
; 