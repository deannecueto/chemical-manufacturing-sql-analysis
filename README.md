# Chemical Manufacturing Sales \& Operations Analysis

## Project Overview

This project demonstrates an end-to-end SQL data analytics workflow using a fictional chemical manufacturing company dataset. The objective was to transform raw operational data into meaningful business insights by designing a relational database, validating and cleaning the data, writing analytical SQL queries, and communicating the results through visualizations and business recommendations.

Rather than focusing solely on SQL syntax, this project emphasizes how SQL can be used to answer real business questions across sales, manufacturing, supplier quality, and inventory management.

\---

## Project Objectives

* Build and populate a relational database from multiple CSV datasets.
* Perform data validation and cleaning before analysis.
* Use SQL to answer business-driven questions.
* Develop meaningful KPIs that support business decision-making.
* Present findings through visualizations and concise business recommendations.

\---

## Dataset

The project uses a synthetic dataset representing the operations of a chemical manufacturing company.

The database contains information on:

* Customers
* Products
* Orders
* Order Items
* Shipments
* Manufacturing Plants
* Production Batches
* Inventory Transactions
* Raw Materials
* Suppliers
* Batch Material Usage
* Quality Tests

\---

## Tools Used

* MySQL
* Power BI
* Git \& GitHub

\---

## Project Workflow

1. Database Creation
2. Data Import
3. Data Validation
4. Data Cleaning
5. Exploratory Data Analysis (EDA)
6. Business Question Development
7. SQL Analysis
8. Data Visualization
9. Business Findings and Recommendations

\---

## Business Questions

### 1\. Which products generate the most revenue?

Analyzed product-level revenue to identify the highest revenue-generating products.

### 2\. Which customers generate the highest revenue?

Compared customers by total revenue while evaluating order frequency and average order value.

### 3\. How do sales vary throughout the year?

Examined monthly sales trends to identify seasonal demand patterns.

### 4\. Which manufacturing plants operate most efficiently?

Compared production costs and evaluated plant efficiency using production cost per kilogram.

### 5\. Which suppliers are associated with the highest defect rates?

Calculated supplier defect rates using unique supplier-batch associations to evaluate supplier quality performance.

### 6\. Which products experience the highest inventory movement?

Analyzed inbound and outbound inventory movement together with net inventory change to identify products with the greatest inventory activity.

\---

## SQL Skills Demonstrated

* JOINs
* Aggregate Functions
* GROUP BY
* CASE Expressions
* Window Functions
* Common Table Expressions (CTEs)
* Conditional Aggregation
* Date Functions
* Data Validation
* Data Cleaning
* KPI Development

\---

## Repository Structure

```text
chemical-manufacturing-sql-analysis/
│
├── README.md
│
├── sql/
│   ├── 01_database_creation.sql
│   ├── 02_data_validation.sql
│   ├── 03_exploratory_data_analysis.sql
│   └── 04_business_questions.sql
│
├── documentation/
│   ├── entity-relationship-diagram.png
│   └── Chemical_Manufacturing_Project_Report.pdf
│
└── dashboards/
    └── chemical_manufacturing_dashboard.pbix
    └── dashboard_powerbi.png

\---

## Future Improvements
* Expand the dataset with more realistic operational variability.
* Incorporate additional business KPIs and trend analyses.

\---

## Author

This project was developed as part of my SQL portfolio to demonstrate practical SQL skills and business analysis techniques for entry-level Data Analyst roles.

