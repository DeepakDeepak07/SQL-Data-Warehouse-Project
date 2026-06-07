# 🚀 SQL Data Warehouse Project

### Building a Modern Data Warehouse with SQL Server using ETL Processes, Data Modeling, and Analytics Engineering

<p align="center">

![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge\&logo=microsoftsqlserver\&logoColor=white)
![Data Warehouse](https://img.shields.io/badge/Data_Warehouse-005571?style=for-the-badge)
![ETL](https://img.shields.io/badge/ETL-FF6F00?style=for-the-badge)
![Analytics Engineering](https://img.shields.io/badge/Analytics_Engineering-4285F4?style=for-the-badge)

</p>

<p align="center">
<img src="https://readme-typing-svg.herokuapp.com?font=Fira+Code&weight=600&size=22&pause=1000&color=36BCF7&center=true&vCenter=true&width=750&lines=Building+a+Modern+Data+Warehouse;Bronze+Silver+Gold+Architecture;ETL+Pipelines+with+SQL+Server;Data+Engineering+Project;Turning+Raw+Data+Into+Business+Insights" />
</p>

---

# 📖 Overview

This project demonstrates the development of a modern SQL Server Data Warehouse using the Medallion Architecture (**Bronze → Silver → Gold**).

The solution ingests raw data from ERP and CRM systems, applies data cleansing and transformation processes, and organizes information into business-ready structures suitable for analytics and reporting.

### Key Highlights

* 📥 Data Ingestion from ERP & CRM systems
* ⚙️ ETL Pipeline Development using T-SQL
* 🏗️ Medallion Architecture Implementation
* 📊 Dimensional Data Modeling
* ✅ Data Quality Validation
* 📚 Comprehensive Technical Documentation
* 🔄 Scalable Data Warehouse Design

---

# 🏗️ Project Architecture

<p align="center">
  <img src="Docs/DWH-Architecture.png" width="950">
</p>

---

# 🎯 Project Objective

The objective of this project is to build a modern data warehouse using SQL Server that:

✔ Consolidates ERP and CRM source data

✔ Implements Bronze, Silver, and Gold layers

✔ Supports scalable ETL workflows

✔ Applies data quality validation rules

✔ Creates business-ready analytical structures

✔ Follows modern data engineering best practices

---

# 📂 Project Structure

```text
SQL-Data-Warehouse-Project
│
├── Datasets/
│
├── Scripts/
│   ├── Bronze/
│   │   ├── ddl_bronze.sql
│   │   └── procedure_load_bronze.sql
│   │
│   ├── Silver/
│   │   ├── ddl_silver.sql
│   │   └── procedure_load_silver.sql
│   │
│   └── Gold/
│       └── ddl_gold.sql
│
├── Tests/
│   ├── quality_checks_silver.sql
│   └── quality_checks_gold.sql
│
├── Docs/
│   ├── DWH-Architecture.png
│   ├── data_flow.png
│   ├── data_integration.png
│   ├── data_model.png
│   ├── data_catalog.md
│   └── naming_conventions.md
│
└── README.md
```

---

# 🗄️ Data Warehouse Layers

## 🥉 Bronze Layer

Raw ingestion layer that stores source data exactly as received.

### Purpose

* Import CSV source files
* Preserve original data
* Maintain historical records
* Minimize transformations

### Scripts

🔗 **[DDL Bronze](https://github.com/DeepakDeepak07/SQL-Data-Warehouse-Project/blob/main/Scripts/Bronze/ddl_bronze.sql)**

🔗 **[Load Bronze Procedures](https://github.com/DeepakDeepak07/SQL-Data-Warehouse-Project/blob/main/Scripts/Bronze/procedure_load_bronze.sql)**

---

## 🥈 Silver Layer

Data cleansing, transformation, and standardization layer.

### Purpose

* Standardize formats
* Remove duplicates
* Resolve data quality issues
* Apply transformation logic

### Scripts

🔗 **[DDL Silver](https://github.com/DeepakDeepak07/SQL-Data-Warehouse-Project/blob/main/Scripts/Silver/ddl_silver.sql)**

🔗 **[Load Silver Procedures](https://github.com/DeepakDeepak07/SQL-Data-Warehouse-Project/blob/main/Scripts/Silver/procedure_load_silver.sql)**

---

## 🥇 Gold Layer

Business-ready presentation layer optimized for analytics.

### Purpose

* Dimensional modeling
* Fact and dimension tables
* Analytical reporting structures
* Business consumption layer

### Scripts

🔗 **[DDL Gold](https://github.com/DeepakDeepak07/SQL-Data-Warehouse-Project/tree/main/Scripts/Gold)**

---

# 📑 Documentation

All technical documentation can be accessed directly below.

<table>
<tr>
<td align="center" width="50%">

### 🔄 Data Flow Diagram

Illustrates how data moves through Bronze, Silver, and Gold layers.

📄 **[View Diagram](https://github.com/DeepakDeepak07/SQL-Data-Warehouse-Project/blob/main/Docs/data_flow.png)**

</td>

<td align="center" width="50%">

### 🔗 Data Integration Diagram

Shows how ERP and CRM systems are integrated into the warehouse.

📄 **[View Diagram](https://github.com/DeepakDeepak07/SQL-Data-Warehouse-Project/blob/main/Docs/data_integration.png)**

</td>
</tr>

<tr>
<td align="center">

### 🗂️ Data Model Diagram

Displays relationships between warehouse entities.

📄 **[View Diagram](https://github.com/DeepakDeepak07/SQL-Data-Warehouse-Project/blob/main/Docs/data_model.png)**

</td>

<td align="center">

### 📚 Data Catalog

Business definitions, tables, and column descriptions.

📄 **[View Documentation](https://github.com/DeepakDeepak07/SQL-Data-Warehouse-Project/blob/main/Docs/data_catalog.md)**

</td>
</tr>

<tr>
<td align="center">

### 📏 Naming Conventions

Standards used across the project.

📄 **[View Standards](https://github.com/DeepakDeepak07/SQL-Data-Warehouse-Project/blob/main/Docs/naming_conventions.md)**

</td>

<td align="center">

### 📖 Full Project Documentation

Detailed project walkthrough and implementation notes.

📄 **[Open Notion Documentation](https://app.notion.com/p/SQL-Data-Warehouse-Project-2b444f85434383e4a26f8110020fe4cd?source=copy_link)**

</td>
</tr>
</table>

---

# ✅ Data Quality Testing

The project includes SQL-based validation checks to ensure data integrity and consistency.

### Silver Layer Tests

* Null value validation
* Duplicate detection
* Data consistency checks
* Transformation verification

### Gold Layer Tests

* Referential integrity validation
* Business rule validation
* Data completeness checks

```text
Tests/
├── quality_checks_silver.sql
└── quality_checks_gold.sql
```

---

# 📂 Source Datasets

The repository contains CSV files used as source data for the ETL process.

```text
Datasets/
```

These files simulate ERP and CRM source systems used throughout the project.

---

# 🛠️ Technology Stack

| Category        | Technology             |
| --------------- | ---------------------- |
| Database        | SQL Server             |
| ETL             | T-SQL                  |
| Data Modeling   | Star Schema            |
| Architecture    | Medallion Architecture |
| Documentation   | Markdown               |
| Version Control | Git & GitHub           |

---

# 🎓 Skills Demonstrated

* SQL Server Development
* ETL Pipeline Development
* Data Warehousing
* Data Modeling
* Medallion Architecture
* Data Quality Testing
* Stored Procedures
* Documentation
* Git & GitHub
* Analytics Engineering

---

# 👨‍💻 Author

### Deepak

**Business Administration (Accounting) Graduate**

📊 Aspiring Data Analyst

📈 Future CPA

---

<p align="center">

### ⭐ If you found this project useful, consider giving it a star!

</p>
