DROP DATABASE IF EXISTS chemsolutions;
CREATE DATABASE chemsolutions;
USE chemsolutions;

CREATE TABLE customers (

    customer_id INT AUTO_INCREMENT PRIMARY KEY,

    company_name VARCHAR(100) NOT NULL,

    industry VARCHAR(50),

    country VARCHAR(50),

    customer_tier ENUM('Standard','Premium')

);

CREATE TABLE products (

    product_id INT AUTO_INCREMENT PRIMARY KEY,

    product_name VARCHAR(100) NOT NULL,

    category VARCHAR(50),

    unit VARCHAR(20),

    selling_price_per_kg DECIMAL(10,2)

);

CREATE TABLE plants (

    plant_id INT AUTO_INCREMENT PRIMARY KEY,

    plant_name VARCHAR(50),

    location VARCHAR(50)

);

CREATE TABLE suppliers (

    supplier_id INT AUTO_INCREMENT PRIMARY KEY,

    supplier_name VARCHAR(100),

    country VARCHAR(50),

    supplier_rating DECIMAL(3,2)

);

CREATE TABLE raw_materials (

    material_id INT AUTO_INCREMENT PRIMARY KEY,

    material_name VARCHAR(100),

    supplier_id INT,

    unit_cost DECIMAL(10,2),

    FOREIGN KEY (supplier_id)

    REFERENCES suppliers(supplier_id)

);

CREATE TABLE orders (

    order_id INT AUTO_INCREMENT PRIMARY KEY,

    customer_id INT,

    order_date DATE,

    FOREIGN KEY (customer_id)

    REFERENCES customers(customer_id)

);

CREATE TABLE order_items (

    order_item_id INT AUTO_INCREMENT PRIMARY KEY,

    order_id INT,

    product_id INT,

    quantity_kg DECIMAL(10,3),

    unit_price DECIMAL(10,2),

    FOREIGN KEY (order_id)

    REFERENCES orders(order_id),

    FOREIGN KEY (product_id)

    REFERENCES products(product_id)

);

CREATE TABLE production_batches (

    batch_id INT AUTO_INCREMENT PRIMARY KEY,

    plant_id INT,

    product_id INT,

    production_date DATE,

    quantity_produced_kg DECIMAL(10,3),

    production_cost DECIMAL(10,2),

    FOREIGN KEY (plant_id)

    REFERENCES plants(plant_id),

    FOREIGN KEY (product_id)

    REFERENCES products(product_id)

);

CREATE TABLE batch_material_usage (

    usage_id INT AUTO_INCREMENT PRIMARY KEY,

    batch_id INT,

    material_id INT,

    quantity_used_kg DECIMAL(10,3),

    FOREIGN KEY (batch_id)

    REFERENCES production_batches(batch_id),

    FOREIGN KEY (material_id)

    REFERENCES raw_materials(material_id)

);

CREATE TABLE quality_tests (

    test_id INT AUTO_INCREMENT PRIMARY KEY,

    batch_id INT,

    purity_percent DECIMAL(5,2),

    yield_percent DECIMAL(5,2),

    passed BOOLEAN,

    defect_reason VARCHAR(100),

    FOREIGN KEY (batch_id)

    REFERENCES production_batches(batch_id)

);

CREATE TABLE shipments (

    shipment_id INT AUTO_INCREMENT PRIMARY KEY,

    order_id INT,

    ship_date DATE,

    delivery_dates INT,

    freight_cost DECIMAL(10,2),

    FOREIGN KEY (order_id)

    REFERENCES orders(order_id)

);

CREATE TABLE inventory_transactions (

    transaction_id INT AUTO_INCREMENT PRIMARY KEY,

    product_id INT,

    transaction_date DATE,

    transaction_type ENUM('IN','OUT'),

    quantity_kg DECIMAL(10,3),

    FOREIGN KEY (product_id)

    REFERENCES products(product_id)

);

CREATE INDEX idx_orders_customer
ON orders(customer_id);

CREATE INDEX idx_orders_date
ON orders(order_date);

CREATE INDEX idx_orderitems_product
ON order_items(product_id);

CREATE INDEX idx_batches_product
ON production_batches(product_id);

CREATE INDEX idx_batches_date
ON production_batches(production_date);

CREATE INDEX idx_inventory_product
ON inventory_transactions(product_id);

CREATE INDEX idx_shipments_order
ON shipments(order_id);



