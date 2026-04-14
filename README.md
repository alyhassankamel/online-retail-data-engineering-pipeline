# Online Retail II — Data Engineering Pipeline

An end-to-end data engineering pipeline built on the UCI Online Retail II dataset (1M+ transactions). The project focuses on ingesting raw Excel data, transforming and validating it through a structured ETL pipeline, and modeling it into a scalable data warehouse, with analytics and visualization as downstream consumers.

---

## 🚀 Tech Stack

* SQL Server 2022
* SSIS (SQL Server Integration Services)
* SSAS (Multidimensional)
* Power BI (consumption layer)
* SSMS

---

## 🏗️ Architecture

```
Excel XLSX → Staging Layer → Data Warehouse (Star Schema) → OLAP Cube → BI Consumption
```

---

## ⚙️ Pipeline Overview

### 1. Data Ingestion

* Extracted data from **two Excel sheets (2009–2011)**
* Unified inputs using SSIS **Union All**
* Loaded raw data into a **staging table (STG_OnlineRetail)**
* Forced all Excel columns to text to avoid type inference issues (e.g., alphanumeric stock codes)

---

### 2. Data Transformation (ETL)

* Built ETL pipeline in SSIS with modular Data Flow Tasks per table
* Applied strict data cleaning rules:

  * Removed NULL and malformed records using `TRY_CAST`
  * Filtered cancelled invoices (`Invoice LIKE 'C%'`)
  * Excluded negative quantities and zero prices
  * Trimmed and standardized string fields
* Documented and handled **80K+ corrupted rows** caused by Excel type issues

---

### 3. Data Modeling (Warehouse)

* Designed a **star schema** optimized for analytical workloads:

  * Dimensions: `DIM_COUNTRY`, `DIM_PRODUCT`, `DIM_CUSTOMER`, `DIM_DATE`
  * Fact table: `FACT_SALES`
* Loaded **714,382 clean fact rows** from **1,067,371 raw rows**
* Implemented:

  * **Surrogate keys** using `IDENTITY`
  * **Smart date key (YYYYMMDD)**
  * **Computed column** for `TotalAmount`
* Optimized schema by linking **Country directly to Fact table** (performance improvement)

---

### 4. Data Loading Strategy

* Implemented **incremental loading** using `NOT EXISTS`
* Ensured **idempotent pipeline execution** (safe reruns without duplication)
* Used **Lookup transformations** to resolve:

  * ProductID (via StockCode)
  * CountryID (via CountryName)
* Applied aggregation (`GROUP BY`) to prevent composite key violations

---

## 🧪 Data Quality & Validation

### Data Cleaning

* Null handling via SQL filters and `TRY_CAST`
* Duplicate handling:

  * Dimensions → `DISTINCT` / `GROUP BY`
  * Fact → aggregation on business keys
* Cancelled & return filtering:

  * Removed invoices starting with `'C'`
  * Excluded Quantity ≤ 0 and Price ≤ 0

### Data Integrity Checks

* Row count validation across all tables
* Referential integrity validation:

  * No orphaned foreign keys in fact table
* Verified full population of star schema

---

## 🧊 Analytical Layer (OLAP)

* Built a **Multidimensional SSAS cube**
* Defined hierarchies:

  * Date: Year → Month → Day
  * Geography: Country Group → Country Name
* Measures:

  * Quantity
  * Unit Price
  * Total Amount
  * Transaction Count
* Enabled fast aggregations for analytical queries
* Developed MDX queries to validate business logic

---

## 📊 Data Consumption

* Connected Power BI via **live connection to SSAS**
* Treated visualization strictly as a **downstream consumer**
* Dashboards include:

  * Product performance
  * Sales trends over time
  * Geographic revenue distribution
  * KPI summaries

---

## 🎯 Key Engineering Outcomes

* Built a **production-style ETL pipeline** from messy Excel data
* Enforced **data quality, consistency, and referential integrity**
* Designed a **scalable dimensional model** for analytics
* Implemented **incremental, rerunnable data loads**
* Separated concerns across **staging → warehouse → consumption layers**

---

## 🧠 Key Learnings

* Handling real-world dirty data (Excel type issues, nulls, duplicates)
* Designing reliable ETL pipelines with SSIS
* Implementing incremental loading strategies
* Building dimensional models for analytical systems
* Working with SSAS multidimensional cubes and MDX

---

## 📌 Future Improvements

* Implement **SCD Type 2** for historical tracking
* Add orchestration (SQL Server Agent / Airflow)
* Introduce automated data quality checks
* Migrate pipeline to a **cloud-based architecture (Azure / Snowflake / BigQuery)**

---

## 📎 Dataset

UCI Machine Learning Repository — Online Retail II Dataset
https://archive.ics.uci.edu/dataset/502/online+retail+ii
