/*====================================================
Row Count Validation
====================================================*/

SELECT COUNT(*) FROM batch_material_usage;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM inventory_transactions;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM plants;
SELECT COUNT(*) FROM production_batches;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM quality_tests;
SELECT COUNT(*) FROM raw_materials;
SELECT COUNT(*) FROM shipments;
SELECT COUNT(*) FROM suppliers;

/*====================================================
Missing / NULL Value Validation
====================================================*/

SELECT *
FROM batch_material_usage
WHERE usage_id IS NULL OR usage_id = ''
	OR batch_id IS NULL OR batch_id = ''
    OR material_id IS NULL OR material_id = ''
    OR quantity_used_kg IS NULL OR quantity_used_kg = '';

SELECT *
FROM customers
WHERE customer_id IS NULL OR customer_id = ''
	OR company_name IS NULL OR company_name = ''
    OR industry IS NULL OR industry = ''
    OR country IS NULL OR country = ''
    OR customer_tier IS NULL OR customer_tier = '';
    

SELECT *
FROM inventory_transactions
WHERE transaction_id IS NULL OR transaction_id = ''
	OR product_id IS NULL OR product_id = ''
    OR transaction_date IS NULL 
    OR transaction_type IS NULL OR transaction_type = ''
    OR quantity_kg IS NULL OR quantity_kg = '';

SELECT *
FROM order_items
WHERE order_item_id IS NULL OR order_item_id = ''
	OR order_id IS NULL OR order_id = ''
    OR product_id IS NULL OR product_id = ''
    OR quantity_kg IS NULL OR quantity_kg = ''
    OR unit_price IS NULL OR unit_price = '';


SELECT * 
FROM orders
WHERE order_id IS NULL OR order_id = ''
	OR customer_id IS NULL OR customer_id = ''
    OR order_date IS NULL;


SELECT * 
FROM plants
WHERE plant_id IS NULL OR plant_id = ''
	OR plant_name IS NULL OR plant_name = ''
    OR location IS NULL OR location = '';


SELECT * 
FROM production_batches
WHERE batch_id IS NULL OR batch_id = ''
	OR plant_id IS NULL OR plant_id = ''
    OR product_id IS NULL OR product_id = ''
    OR production_date IS NULL
    OR quantity_produced_kg IS NULL OR quantity_produced_kg = ''
	OR production_cost IS NULL OR production_cost = '';


SELECT * 
FROM products
WHERE product_id IS NULL OR product_id = ''
	OR product_name IS NULL OR product_name = ''
    OR category IS NULL OR category = ''
    OR unit IS NULL OR unit = ''
    OR selling_price_per_kg IS NULL OR selling_price_per_kg = '';


SELECT * 
FROM quality_tests
WHERE test_id IS NULL OR test_id = ''
	OR batch_id IS NULL OR batch_id = ''
    OR purity_percent IS NULL OR purity_percent = ''
    OR yield_percent IS NULL OR yield_percent = ''
    OR passed IS NULL
	OR defect_reason IS NULL OR defect_reason = '';

-- Found that passed tests should have no defect reason so I looked for not passed with no defect reason

SELECT *
FROM quality_tests
WHERE passed != 1 AND defect_reason = '';

SELECT *
FROM raw_materials
WHERE material_id IS NULL OR material_id = ''
	OR material_name IS NULL OR material_name = ''
    OR supplier_id IS NULL OR supplier_id = ''
    OR unit_cost IS NULL OR unit_cost = '';

SELECT *
FROM shipments
WHERE shipment_id IS NULL OR shipment_id = ''
	OR order_id IS NULL OR order_id = ''
    OR ship_date IS NULL
    OR delivery_dates IS NULL
    OR freight_cost IS NULL OR freight_cost = '';


SELECT * 
FROM suppliers
WHERE supplier_id IS NULL OR supplier_id = ''
	OR supplier_name IS NULL OR supplier_name = ''
    OR country IS NULL OR country = ''
    OR supplier_rating IS NULL OR supplier_rating = '';

/*====================================================
Duplicate Record Validation
====================================================*/

SELECT
    usage_id,
    COUNT(*) AS duplicate_count
FROM batch_material_usage
GROUP BY usage_id
HAVING COUNT(*) > 1;

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT
    transaction_id,
    COUNT(*) AS duplicate_count
FROM inventory_transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;

SELECT
    order_item_id,
    COUNT(*) AS duplicate_count
FROM order_items
GROUP BY order_item_id
HAVING COUNT(*) > 1;

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT
    plant_id,
    COUNT(*) AS duplicate_count
FROM plants
GROUP BY plant_id
HAVING COUNT(*) > 1;

SELECT
    batch_id,
    COUNT(*) AS duplicate_count
FROM production_batches
GROUP BY batch_id
HAVING COUNT(*) > 1;

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT
    test_id,
    COUNT(*) AS duplicate_count
FROM quality_tests
GROUP BY test_id
HAVING COUNT(*) > 1;

SELECT
    material_id,
    COUNT(*) AS duplicate_count
FROM raw_materials
GROUP BY material_id
HAVING COUNT(*) > 1;

SELECT
    shipment_id,
    COUNT(*) AS duplicate_count
FROM shipments
GROUP BY shipment_id
HAVING COUNT(*) > 1;

SELECT
    supplier_id,
    COUNT(*) AS duplicate_count
FROM suppliers
GROUP BY supplier_id
HAVING COUNT(*) > 1;

/*====================================================
Categorical Value Validation
====================================================*/

SELECT COUNT(*) 
FROM batch_material_usage
WHERE quantity_used_kg < 0;

SELECT COUNT(*)  
FROM inventory_transactions
WHERE quantity_kg < 0;

SELECT COUNT(*)  
FROM order_items
WHERE quantity_kg < 0;

SELECT COUNT(*)  
FROM order_items
WHERE unit_price < 0;

SELECT COUNT(*)  
FROM production_batches
WHERE quantity_produced_kg < 0;

SELECT COUNT(*)  
FROM production_batches
WHERE production_cost < 0;

SELECT COUNT(*)  
FROM products
WHERE selling_price_per_kg < 0;

SELECT COUNT(*)  
FROM quality_tests
WHERE purity_percent < 0;

SELECT COUNT(*)  
FROM quality_tests
WHERE yield_percent < 0;

SELECT COUNT(*)  
FROM raw_materials
WHERE unit_cost < 0;

SELECT COUNT(*)  
FROM shipments
WHERE freight_cost < 0;

/*====================================================
Date Validation
====================================================*/

SELECT shipments.order_id, orders.order_id, shipment_id, order_date, ship_date
FROM shipments
JOIN orders
	ON shipments.order_id = orders.order_id
WHERE ship_date < order_date;


SELECT *
FROM shipments;

/*====================================================
Outlier Detection
====================================================*/

SELECT shipments.order_id, orders.order_id, shipment_id, ship_date, order_date, delivery_dates
FROM shipments
JOIN orders
	ON shipments.order_id = orders.order_id
WHERE delivery_dates > 8;

/*====================================================
Referential Integrity Validation
====================================================*/

SELECT DISTINCT company_name
FROM customers
ORDER BY company_name;

SELECT DISTINCT industry
FROM customers
ORDER BY industry;

SELECT DISTINCT country
FROM customers
ORDER BY country;

SELECT DISTINCT customer_tier
FROM customers
ORDER BY customer_tier;

SELECT DISTINCT plant_name
FROM plants
ORDER BY plant_name;

SELECT DISTINCT location
FROM plants
ORDER BY location;

SELECT DISTINCT product_name
FROM products
ORDER BY product_name;

SELECT DISTINCT category
FROM products
ORDER BY category;

SELECT DISTINCT material_name
FROM raw_materials
ORDER BY material_name;

SELECT DISTINCT supplier_name
FROM suppliers
ORDER BY supplier_name;

SELECT DISTINCT country
FROM suppliers
ORDER BY country;



