-- ================================================
-- IMDB MOVIES ANALYSIS - DATABASE SETUP
-- ================================================
-- Author: Kiran Rangu
-- Date: September 2025
-- Purpose: Create database structure for IMDB movies analysis
-- ================================================

-- Create database for the analysis
CREATE DATABASE IF NOT EXISTS imdb_analysis;
USE imdb_analysis;

-- ================================================
-- TABLE CREATION
-- ================================================

-- Drop table if exists (for clean setup)
DROP TABLE IF EXISTS imdb_movies;

-- Create main movies table with optimized data types
CREATE TABLE imdb_movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Poster_Link TEXT,
    Series_Title VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    Released_Year INT,
    Certificate VARCHAR(20),
    Runtime VARCHAR(20),
    Runtime_Minutes INT,
    Genre VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    IMDB_Rating DECIMAL(3,1),
    Overview TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    Meta_score INT,
    Director VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    Star1 VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    Star2 VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    Star3 VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    Star4 VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    No_of_Votes BIGINT,
    Gross BIGINT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================
-- INDEXES FOR PERFORMANCE
-- ================================================

-- Index on commonly used fields for faster queries
CREATE INDEX idx_released_year ON imdb_movies(Released_Year);
CREATE INDEX idx_imdb_rating ON imdb_movies(IMDB_Rating);
CREATE INDEX idx_director ON imdb_movies(Director);
CREATE INDEX idx_genre ON imdb_movies(Genre);
CREATE INDEX idx_votes ON imdb_movies(No_of_Votes);

-- ================================================
-- DATA IMPORT INSTRUCTIONS
-- ================================================

/*
PROFESSIONAL DATA IMPORT METHOD

METHOD 1: MySQL Workbench Table Data Import Wizard (RECOMMENDED)
1. Right-click on the table name in Navigator
2. Select "Table Data Import Wizard"
3. Choose your CSV file
4. Map columns appropriately
5. Handle data type conversions
6. Import data with validation

-- ================================================
-- DATA PREPROCESSING (Run after import)
-- ================================================

-- Extract runtime minutes from string format
UPDATE imdb_movies 
SET Runtime_Minutes = CAST(REPLACE(REPLACE(Runtime, ' min', ''), ' mins', '') AS UNSIGNED)
WHERE Runtime IS NOT NULL AND Runtime != '';

-- Clean up any data inconsistencies
UPDATE imdb_movies SET Certificate = NULL WHERE Certificate = '';
UPDATE imdb_movies SET Meta_score = NULL WHERE Meta_score = 0;
UPDATE imdb_movies SET Gross = NULL WHERE Gross = 0;

-- ================================================
-- BASIC VALIDATION QUERIES
-- ================================================

-- Verify table structure
DESCRIBE imdb_movies;

-- Check total records
SELECT COUNT(*) as total_records FROM imdb_movies;

-- Verify data ranges
SELECT 
    MIN(Released_Year) as earliest_year,
    MAX(Released_Year) as latest_year,
    MIN(IMDB_Rating) as min_rating,
    MAX(IMDB_Rating) as max_rating,
    COUNT(DISTINCT Director) as unique_directors
FROM imdb_movies;

-- Check for encoding issues
SELECT Series_Title 
FROM imdb_movies 
WHERE Series_Title LIKE '%?%' OR Series_Title LIKE '%â%'
LIMIT 5;

-- ================================================
-- READY FOR ANALYSIS
-- ================================================

-- Database setup complete!
-- Proceed to data exploration queries in 02_data_exploration.sql

SELECT 'Database setup completed successfully!' as status;
