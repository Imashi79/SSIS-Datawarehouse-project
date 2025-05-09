# 🛍️ Global Fashion Retail Sales Data Warehouse Project

This project is developed as part of the **Data Warehousing and Business Intelligence** course. It involves designing and building a data warehouse system for a global fashion retail company using **SQL Server** and **SSIS**.

## 📌 Project Objective

To build a structured and efficient Data Warehouse (DW) that consolidates sales, customer, and product data from multiple sources, enabling data analysis and business intelligence reporting.

### Solution Architecture
![Solution Architecture](doc/Solution%20Architecture.png)

## 📥 Dataset Source

The original dataset used in this project is available at:

🔗 [Global Fashion Retail Sales Dataset – Kaggle](https://www.kaggle.com/datasets/ricgomes/global-fashion-retail-stores-dataset)

## 🗂️ Folder Structure

```plaintext
Global_Fashion_Retail_DW_Project/
├── datasets/                # Raw flat files (CSV, TXT)
├── Scripts/                 # SQL scripts for DB objects and ETL
├── SSIS/                    # SSIS packages (.dtsx, .sln, etc.)
├── report/                  # Project report (PDF or DOCX)
├── docs/                    # Diagrams or additional docs
├── .gitignore               # Git ignore file
└── README.md                # Project description and documentation
```
## 🔗 Data Sources

### 🗄️ Source Database: `Global_Fashion_Retail_Sales_SourceDB`
- This source database was created by importing structured CSV and TXT files.
- Tables: `customers`, `employees`, `ProductCategory`, `ProductSubCategory`, `Product`, `transactions`

### 📄 Flat Files Used to Build Source DB
- `Stores.csv`: Store metadata (Store name, city, ZIP, latitude, longitude, etc.)
- `Country.txt`: Country reference data
- `Customer_Location.txt`: Customer location details (Customer ID, city, country, etc.)
- `products.csv`, `transactions.csv`, etc. (Include your actual file names here if different)

## 🏗️ Architecture

1. **Data Staging** – `Global_Fashion_Retail_Sales_Staging`  
   Stores raw, untransformed data from all sources.

2. **Data Warehouse** – `Global_Fashion_Retail_Sales_DW`  
   Transformed and normalized data using a **Snowflake Schema** for detailed analysis.

3. **ETL** – Developed using **SQL Server Integration Services (SSIS)**

---

## 🌐 Schema Design: Snowflake Schema

To reduce redundancy and improve data organization, a **Snowflake Schema** is used.

### ✅ Normalization Highlights
- **Store Dimension**: Country data moved to a separate `DimCountry` table for regional analysis.
- **Product Dimension**: Product hierarchy split into `DimProductCategory`, `DimProductSubCategory`, and `DimProducts`.

---

## 🧩 Dimension and Fact Tables

1. **DimCustomer** – Customer details (Name, Email, Phone, City)  
   - `CustomerSK`: Surrogate Key

2. **DimEmployees** – Employee details (Name, Position, Store association)  
   - `EmployeeSK`: Surrogate Key

3. **DimStores** – Store info (City, ZIP, No. of Employees, Geo-location)  
   - `StoreSK`: Surrogate Key

4. **DimProducts** – Product attributes (Size, Color, Multilingual descriptions)  
   - `ProductSK`: Surrogate Key

5. **DimProductSubCategory** – Linked to products  
   - `SubCategorySK`

6. **DimProductCategory** – Linked to subcategories  
   - `ProductCategorySK`

7. **DimCountry** – Regional grouping  
   - `CountrySK`

8. **DimDate** – Date attributes (Day, Month, Year, Holiday flag, etc.)  
   - `DateKey`

9. **FactTransactions** – Transactional sales data with foreign keys to dimension tables  
   - Fields include: `InvoiceID`, `ProductID`, `CustomerID`, `StoreID`, `EmployeeID`, `DateKey`, `Quantity`, `Unit Price`, `Line Total`, `Payment Method`, `Currency Symbol`

---

## 🔄 Slowly Changing Dimensions (SCD)

To preserve historical data and allow accurate analysis over time, selected dimensions are tracked using SCD logic.

### 🧍 DimCustomer  
- **Historical**: City, Country  
- **Changing**: Telephone, Email, Gender

### 👩‍💼 DimEmployees  
- **Historical**: Position  
- **Changing**: StoreID, StartDate, EndDate

### 🏬 DimStores  
- **Historical**: City, ZIP Code, Country  
- **Changing**: Store Name, Number of Employees

---

## 📊 Technologies Used

- Microsoft SQL Server 2020
- SQL Server Integration Services (SSIS)
- T-SQL
- Visual Studio 2022
- Git & GitHub

