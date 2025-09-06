# 🎬 IMDB Top 1000 Movies Analysis

### 📊 Project Overview
This project demonstrates SQL skills through comprehensive analysis of IMDB's top-rated movies dataset. It showcases data exploration, business insights, and analytical thinking.

### 🎯 Key Skills Demonstrated
- **SQL Fundamentals**: SELECT, WHERE, GROUP BY, ORDER BY, HAVING
- **Data Aggregation**: COUNT, AVG, SUM, MIN, MAX
- **String Operations**: LIKE, CASE statements, string functions
- **Business Analysis**: Revenue analysis, trend identification
- **Data Quality**: Missing value assessment, data validation
- **Reporting**: Executive summary queries, KPI calculations

### 📁 Repository Structure
```
imdb-movies-analysis/
├── README.md
├── data/
│   ├── imdb_topp_1000.csv
│   └── data_dictionary.md
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_data_exploration.sql
│   ├── 03_business_analysis.sql
│   └── 04_summary_insights.sql
└── results/
    ├── 02_data_exploration_csv_output/
    ├── 03_business_analysis_csv_output/
    ├── 04_summary_insights_csv_output/
    └── key_findings.md
```

### 🗄️ Dataset Information
- **Source**: IMDB Top 1000 Movies Dataset
- **Time Period**: 1920-2020
- **Records**: ~1000 movies
- **Key Fields**: Title, Year, Rating, Genre, Director, Cast, Revenue, Votes

### 🔍 Analysis Categories

#### 1. Data Exploration (02_data_exploration.sql)
- Dataset overview and statistics
- Data quality assessment
- Missing value analysis
- Basic trend identification

#### 2. Business Analysis (03_business_analysis.sql)  
- Top performers by various metrics
- Genre popularity and performance
- Director success analysis
- Revenue vs rating correlation
- Temporal trends and patterns

#### 3. Summary Insights (04_summary_insights.sql)
- Executive dashboard queries
- Key performance indicators
- Business recommendations
- Final summary statistics

### 📈 Key Findings
- **Golden Age**: Movies from the 1950s show highest average ratings
- **Genre Leaders**: Drama leads in both quantity and quality
- **Revenue vs Rating**: Not always correlated - some critically acclaimed films have modest box office
- **Runtime Sweet Spot**: 120-150 minute movies tend to have higher ratings
- **Director Impact**: Consistent directors show clear rating advantages

### 🛠️ Technical Implementation

#### Database Setup
```sql
CREATE DATABASE imdb_analysis;
USE imdb_analysis;

-- Table structure optimized for analysis
CREATE TABLE imdb_movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Series_Title VARCHAR(500),
    Released_Year INT,
    IMDB_Rating DECIMAL(3,1),
    Genre VARCHAR(200),
    Director VARCHAR(200),
    -- Additional fields...
);
```

#### Data Import Methods Used
- **MySQL Workbench**: Table Data Import Wizard (Recommended)
- **LOAD DATA INFILE**: For large datasets
- **CSV Import**: Direct import from file system

### 🎯 Business Value
This analysis provides insights for:
- **Movie Studios**: Understanding successful patterns
- **Investors**: ROI analysis and risk assessment  
- **Streaming Platforms**: Content acquisition strategies
- **Film Critics**: Historical context and trends

### 🚀 Future Enhancements
- Sentiment analysis on movie overviews
- Seasonal release pattern analysis
- Actor network analysis
- Predictive modeling for ratings
- International market analysis

### 📊 Sample Queries
```sql
-- Top rated movies by decade
SELECT 
    FLOOR(Released_Year/10)*10 as decade,
    COUNT(*) as movie_count,
    ROUND(AVG(IMDB_Rating), 2) as avg_rating
FROM imdb_movies
GROUP BY FLOOR(Released_Year/10)*10
ORDER BY avg_rating DESC;
```

### 🔧 Technologies Used
- **Database**: MySQL 8.0
- **Tools**: MySQL Workbench
- **Languages**: SQL
- **Data Processing**: CSV import utilities

### 📝 How to Use
1. Clone this repository
2. Import the dataset using MySQL Workbench
3. Run the SQL scripts in order (01 → 04)
4. Review results and insights

### 🤝 Connect
This project demonstrates my analytical skills and SQL proficiency for data analyst positions. Feel free to explore the code and findings!

---
