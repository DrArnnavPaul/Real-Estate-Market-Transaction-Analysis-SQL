# 🏡 Real Estate Market Analysis Using SQL

## Overview

This project analyzes a real estate dataset containing **20,000 property listings** across **six major U.S. cities**—Chicago, Los Angeles, Miami, New York, San Francisco, and Seattle—from **2019 to 2023**. The objective is to uncover trends in housing demand, property prices, investor activity, construction, affordability, and interest rates using SQL.

The project demonstrates advanced SQL techniques including **aggregations, Common Table Expressions (CTEs), window functions, ranking functions, conditional aggregation, and analytical queries** to transform raw data into meaningful business insights.

---

# Objectives

The primary objectives of this project are to:

* Analyze housing demand across different cities.
* Study investor activity trends over time.
* Evaluate affordability using the Price-to-Annual-Rent Ratio.
* Compare listing prices across cities and years.
* Analyze construction activity and market concentration.
* Measure investor activity volatility.
* Examine the effect of interest rates on home prices.
* Identify investment opportunities based on multiple market indicators.

---

# Dataset Overview

The dataset contains approximately **20,000 residential property records** collected from **2019–2023**.

### Cities Included

* Chicago
* Los Angeles
* Miami
* New York
* San Francisco
* Seattle

### Property Types

* House
* Apartment
* Condo
* Townhouse
* Other

### Key Attributes

* Property ID
* City
* Year
* Listing Price
* Rental Price
* Housing Demand Index
* Investor Activity Score
* Property Size (SqFt)
* Interest Rate
* Property Type
* Income Bracket
* New Construction Status

---

# Tools & Technologies

* MySQL
* SQL Window Functions
* CTEs (Common Table Expressions)
* Aggregate Functions
* Ranking Functions
* Conditional Aggregation
* GitHub
* Excel (Data Validation)

---

# SQL Concepts Used

* SELECT
* WHERE
* GROUP BY
* HAVING
* ORDER BY
* CASE WHEN
* COUNT()
* SUM()
* AVG()
* MIN()
* MAX()
* ROW_NUMBER()
* RANK()
* DENSE_RANK()
* LAG()
* LEAD()
* CTEs
* Window Functions
* Conditional Aggregation

---

# Project Analysis

## 1. Housing Demand Analysis

Housing demand varied considerably among cities.

San Francisco recorded the highest Housing Demand Index (**162.35**), followed by Chicago (**129.52**) and Seattle (**122.11**). New York recorded the lowest demand (**98.63**).

### Key Insight

Higher housing demand generally corresponded with higher home prices, indicating stronger competition among buyers.

---

## 2. Investor Activity Analysis

Average investor activity increased from

* **2019:** 3.35
* **2020:** 4.57
* **2021:** 4.90 (Peak)
* **2022:** 4.75
* **2023:** 4.13

### YoY Change

* 2020: +1.22
* 2021: +0.33
* 2022: −0.15
* 2023: −0.62

### Insight

Investor participation grew rapidly during 2020–2021 before slowing in 2022–2023, suggesting a cooling market after the post-pandemic surge.

---

## 3. Income Bracket Analysis

All income brackets contained:

* 30 records
* Average Home Price: **$660,225.76**
* Average Investor Activity: **4.34**

### Insight

The dataset shows no significant variation in investor activity across income brackets, indicating balanced investment participation.

---

## 4. Affordability Analysis

Price-to-Annual-Rent Ratio:

| City          | Ratio |
| ------------- | ----: |
| Miami         | 25.85 |
| Chicago       | 22.45 |
| San Francisco | 17.60 |
| New York      | 17.01 |
| Los Angeles   | 13.88 |
| Seattle       | 12.98 |

### Insight

* Miami and Chicago appear more expensive relative to rental income.
* Seattle and Los Angeles provide comparatively stronger rental investment opportunities due to lower ratios.

---

## 5. High Demand Investment Opportunities

Cities identified as having both high demand and affordability opportunities:

* San Francisco
* Chicago

These cities combine strong buyer demand with attractive investment potential.

---

## 6. Construction Activity

New constructions by city:

| City          | New Constructions |
| ------------- | ----------------: |
| Los Angeles   |            13,696 |
| Seattle       |            12,604 |
| Chicago       |            10,736 |
| San Francisco |            10,156 |
| Miami         |            10,092 |
| New York      |             7,844 |

### Market Share

* Los Angeles: **21.03%**
* Seattle: **19.35%**
* Chicago: **16.48%**
* San Francisco: **15.59%**
* Miami: **15.50%**
* New York: **12.04%**

### Insight

Los Angeles dominated construction activity, while New York recorded the lowest share of new developments.

---

## 7. Investor Activity Volatility

| City          | Avg Activity | Volatility |
| ------------- | -----------: | ---------: |
| Los Angeles   |         5.13 |       2.57 |
| Chicago       |         5.01 |       1.70 |
| Miami         |         4.57 |       1.84 |
| Seattle       |         4.54 |       2.32 |
| San Francisco |         3.64 |       2.82 |
| New York      |         3.12 |       2.91 |

### Insight

New York exhibited the highest volatility, indicating more unpredictable investor behavior, whereas Chicago showed relatively stable investor activity.

---

## 8. Investor Activity Change

| City          | % Change |
| ------------- | -------: |
| Los Angeles   | +858.11% |
| New York      | +237.04% |
| San Francisco |  +10.10% |
| Chicago       |  −33.64% |
| Miami         |  −45.69% |
| Seattle       |  −66.37% |

### Insight

Los Angeles experienced exceptional investor growth, while Seattle showed the sharpest decline.

---

## 9. Listing Price Trends (2019–2023)

Average listing prices fluctuated considerably across all cities.

Highlights include:

* San Francisco peaked above **$1.09 million** during 2021–2022.
* Los Angeles experienced a sharp increase in 2022 before falling in 2023.
* Miami remained one of the strongest performing markets in 2023.
* New York recovered after a significant decline in 2021.

---

## 10. Year-over-Year Price Changes

Notable movements:

* Los Angeles:

  * 2022: **+430.45%**
  * 2023: **−80.29%**

* Seattle:

  * 2022: **+190.72%**
  * 2023: **−64.65%**

* San Francisco:

  * 2020: **+58.49%**
  * 2021: **+64.52%**

### Insight

Property prices displayed substantial volatility, reflecting changing market conditions over the five-year period.

---

## 11. Property Type Distribution

Property types were distributed fairly evenly.

Examples:

### Chicago

* Condo: 24.67%
* Apartment: 24.64%
* Townhouse: 24.20%
* House: 24.17%

### Seattle

* Apartment: 26.47%
* Townhouse: 24.50%
* House: 23.92%
* Condo: 22.59%

### Insight

No single property type dominated the market, suggesting a balanced housing inventory across cities.

---

## 12. Interest Rate Analysis

Interest Rate Bands:

| Band | Average Home Price |
| ---- | -----------------: |
| 3–5% |        $630,723.54 |
| 5–7% |        $704,479.08 |

Although prices remained high, several cities showed slower or negative price growth as interest rates increased.

### Insight

Higher borrowing costs contributed to slower price appreciation in many markets.

---

## 13. Property Size Analysis

The dataset contains properties ranging from approximately **500 sq ft** to **4,999 sq ft**.

Examples of the largest properties include listings in Seattle, Chicago, Los Angeles, Miami, New York, and San Francisco.

### Insight

Large luxury properties are distributed across all major cities rather than being concentrated in a single market.

---

# Business Insights

* San Francisco has the strongest housing demand.
* Los Angeles leads in construction and investor growth.
* Miami remains one of the most expensive rental markets.
* Seattle offers attractive rental affordability but experienced declining investor activity.
* Chicago combines strong housing demand with relatively stable investor behavior.
* Investor activity peaked during 2021 before moderating in subsequent years.
* Interest rate increases coincided with slower property price growth in several markets.
* Property inventory is well diversified across housing types.

---

# Conclusion

This project demonstrates how SQL can be used to transform large-scale real estate data into meaningful business insights. By applying advanced SQL techniques—including window functions, CTEs, ranking functions, and analytical aggregations—the analysis identified trends in housing demand, pricing, investor behavior, construction activity, affordability, and market volatility.

The results show that **San Francisco** leads in housing demand, **Los Angeles** dominates construction activity and investor growth, **Miami** maintains premium property values, and **Chicago** offers a balanced combination of demand and market stability. Investor activity increased significantly through 2021 before easing in later years, while rising interest rates were associated with slower price growth in many markets.

Overall, the project highlights how SQL-based analysis supports informed decision-making for investors, developers, financial institutions, and policymakers by revealing market opportunities and emerging real estate trends.

---

# Future Enhancements

* Develop an interactive Power BI dashboard.
* Build predictive models for future property prices.
* Incorporate demographic and economic indicators.
* Analyze neighborhood-level trends.
* Add geospatial visualizations using GIS tools.
* Integrate real-time housing market data through APIs.

---

# Author
Dr.Arnnav Paul

An end-to-end SQL analytics project demonstrating advanced querying, business intelligence, and data-driven decision-making on a multi-city real estate dataset.
