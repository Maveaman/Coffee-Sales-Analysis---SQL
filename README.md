# ☕ Coffee Sales Analysis – SQL Project for Monday Coffee

## 📌 Overview

This project presents an end-to-end SQL-based data analysis of **Monday Coffee**, a growing online coffee brand that began operations in **January 2023**. The objective is to identify the **top 3 Indian cities** with the **highest market potential** for opening new physical coffee shop locations by analyzing consumer behavior, sales performance, and cost factors.

---

## 🎯 Objective

To analyze Monday Coffee's sales data and **recommend the top three major Indian cities** for launching new retail outlets based on:

* Consumer demand
* Sales performance
* Rent economics
* Customer volume

---

## ❓ Key Business Questions

1. **Coffee Consumers Count**

   * How many people in each city are estimated to consume coffee, assuming **25% of the population** drinks coffee?

2. **Total Revenue from Coffee Sales**

   * What is the **total revenue generated** in the **last quarter of 2023**?

3. **Sales Count per Product**

   * How many **units of each product** have been sold?

4. **Average Sales per City**

   * What is the **average sales amount per customer** in each city?

5. **City-Wise Market Potential**

   * Provide each **city’s population**, **estimated coffee consumers**, and **customer count**.

6. **Top Products by City**

   * What are the **top 3 selling coffee products** in each city?

7. **Customer Segmentation**

   * How many **unique customers** are there per city?

8. **Average Sale vs Rent**

   * What is the **average sale** and **average rent** per customer in each city?

9. **Monthly Sales Growth**

   * How is the **sales growth trending** month-over-month?

10. **Market Potential Summary**

    * Which **3 cities** show the **strongest market potential** based on revenue, rent, customer base, and consumer count?

---

## 🛠️ Tools & Technologies Used

| Tool                   | Purpose                        |
| ---------------------- | ------------------------------ |
| SQL (PostgreSQL/MySQL) | Core analysis and querying     |
| Google Sheets / Excel  | Data cleaning and input source |

---

## 📊 Key Insights

### ✅ Recommended Cities for Expansion

| City       | Reasoning                                                                                                                       |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **Pune**   | 🔹 Highest total revenue<br>🔹 Low average rent per customer<br>🔹 High average sales per customer                              |
| **Delhi**  | 🔹 Largest number of estimated coffee consumers (7.7M)<br>🔹 High customer count (68)<br>🔹 Reasonable rent per customer (₹330) |
| **Jaipur** | 🔹 Highest number of customers (69)<br>🔹 Very low average rent (₹156)<br>🔹 Strong average sales (₹11.6k per customer)         |

---

## 🧠 Sample SQL Snippet

```sql
SELECT 
    City,
    ROUND(SUM(Total_Sales) / COUNT(DISTINCT Customer_ID), 2) AS Avg_Sales_Per_Customer,
    ROUND(SUM(Rent) / COUNT(DISTINCT Customer_ID), 2) AS Avg_Rent_Per_Customer
FROM
    coffee_sales
GROUP BY
    City
ORDER BY
    Avg_Sales_Per_Customer DESC;
```

---

## 🧾 Repository Structure

```plaintext
📁 coffee-sales-analysis-sql/
├── 📄 README.md
├── 📊 dataset/
│   └── monday_coffee_data.csv
├── 📂 queries/
│   ├── coffee_consumers.sql
│   ├── quarterly_revenue.sql
│   ├── product_sales.sql
│   ├── average_sales_per_city.sql
│   ├── city_population_consumers.sql
│   ├── top_products_by_city.sql
│   ├── customer_segmentation.sql
│   ├── avg_sale_vs_rent.sql
│   ├── monthly_sales_growth.sql
│   └── market_potential_analysis.sql
```

---

## 🙋 Contact

**Created by Aman Kumar Sharma**
🔗 [LinkedIn](https://linkedin.com/in/amansharma270)
💻 [GitHub](https://github.com/Maveaman)
e-mail - aamansharma027@gmail.com
