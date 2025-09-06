-- ================================================
-- IMDB MOVIES ANALYSIS - DATA EXPLORATION
-- ================================================
-- Author: Kiran Rangu
-- Date: September 2025
-- Purpose: Basic data exploration and quality assessment
-- Skills: SELECT, aggregations, data profiling
-- ================================================

USE imdb_analysis;

-- ================================================
-- 📊 DATASET OVERVIEW
-- ================================================

-- 1. Basic dataset statistics
SELECT 
    COUNT(*) as total_movies,
    MIN(Released_Year) as earliest_movie,
    MAX(Released_Year) as latest_movie,
    ROUND(AVG(IMDB_Rating), 2) as average_rating,
    ROUND(AVG(Runtime_Minutes), 0) as average_runtime_minutes
FROM imdb_movies;

-- 2. Data completeness analysis  
SELECT 
    COUNT(*) as total_records,
    COUNT(Series_Title) as movies_with_titles,
    COUNT(IMDB_Rating) as movies_with_ratings,
    COUNT(Director) as movies_with_directors,
    COUNT(Gross) as movies_with_revenue,
    COUNT(Meta_score) as movies_with_metacritic,
    ROUND(COUNT(Gross) * 100.0 / COUNT(*), 1) as revenue_data_percentage,
    ROUND(COUNT(Meta_score) * 100.0 / COUNT(*), 1) as metacritic_data_percentage
FROM imdb_movies;

-- 3. Rating distribution analysis
SELECT 
    CASE 
        WHEN IMDB_Rating >= 9.0 THEN '9.0+ (Exceptional)'
        WHEN IMDB_Rating >= 8.5 THEN '8.5-8.9 (Excellent)'
        WHEN IMDB_Rating >= 8.0 THEN '8.0-8.4 (Very Good)'
        WHEN IMDB_Rating >= 7.5 THEN '7.5-7.9 (Good)'
        ELSE 'Below 7.5 (Average)'
    END as rating_category,
    COUNT(*) as movie_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM imdb_movies), 1) as percentage
FROM imdb_movies
GROUP BY 
    CASE 
        WHEN IMDB_Rating >= 9.0 THEN '9.0+ (Exceptional)'
        WHEN IMDB_Rating >= 8.5 THEN '8.5-8.9 (Excellent)'
        WHEN IMDB_Rating >= 8.0 THEN '8.0-8.4 (Very Good)'
        WHEN IMDB_Rating >= 7.5 THEN '7.5-7.9 (Good)'
        ELSE 'Below 7.5 (Average)'
    END
ORDER BY MIN(IMDB_Rating) DESC;

-- ================================================
-- 🎬 TOP PERFORMERS ANALYSIS
-- ================================================

-- 4. Top 15 highest rated movies
SELECT 
    Series_Title,
    Released_Year,
    IMDB_Rating,
    Director,
    FORMAT(No_of_Votes, 0) as formatted_votes,
    CASE 
        WHEN Gross IS NOT NULL THEN CONCAT('$', FORMAT(Gross/1000000, 1), 'M')
        ELSE 'No data'
    END as revenue
FROM imdb_movies
ORDER BY IMDB_Rating DESC, No_of_Votes DESC
LIMIT 15;

-- 5. Most prolific directors
SELECT 
    Director,
    COUNT(*) as movie_count,
    ROUND(AVG(IMDB_Rating), 2) as avg_rating,
    MIN(IMDB_Rating) as lowest_rating,
    MAX(IMDB_Rating) as highest_rating,
    FORMAT(SUM(No_of_Votes), 0) as total_votes
FROM imdb_movies
WHERE Director IS NOT NULL
GROUP BY Director
HAVING COUNT(*) >= 3
ORDER BY movie_count DESC, avg_rating DESC
LIMIT 15;

-- 6. Box office top performers
SELECT 
    Series_Title,
    Released_Year,
    Director,
    IMDB_Rating,
    CONCAT('$', FORMAT(Gross/1000000, 0), 'M') as revenue_millions,
    FORMAT(No_of_Votes, 0) as votes
FROM imdb_movies
WHERE Gross IS NOT NULL
ORDER BY Gross DESC
LIMIT 15;

-- ================================================
-- 📅 TEMPORAL ANALYSIS
-- ================================================

-- 7. Movies per decade with quality trends
SELECT 
    CASE 
        WHEN Released_Year BETWEEN 1920 AND 1929 THEN '1920s'
        WHEN Released_Year BETWEEN 1930 AND 1939 THEN '1930s'
        WHEN Released_Year BETWEEN 1940 AND 1949 THEN '1940s'
        WHEN Released_Year BETWEEN 1950 AND 1959 THEN '1950s'
        WHEN Released_Year BETWEEN 1960 AND 1969 THEN '1960s'
        WHEN Released_Year BETWEEN 1970 AND 1979 THEN '1970s'
        WHEN Released_Year BETWEEN 1980 AND 1989 THEN '1980s'
        WHEN Released_Year BETWEEN 1990 AND 1999 THEN '1990s'
        WHEN Released_Year BETWEEN 2000 AND 2009 THEN '2000s'
        WHEN Released_Year BETWEEN 2010 AND 2019 THEN '2010s'
        ELSE '2020s'
    END as decade,
    COUNT(*) as movie_count,
    ROUND(AVG(IMDB_Rating), 2) as avg_rating,
    MIN(IMDB_Rating) as min_rating,
    MAX(IMDB_Rating) as max_rating
FROM imdb_movies
GROUP BY 
    CASE 
        WHEN Released_Year BETWEEN 1920 AND 1929 THEN '1920s'
        WHEN Released_Year BETWEEN 1930 AND 1939 THEN '1930s'
        WHEN Released_Year BETWEEN 1940 AND 1949 THEN '1940s'
        WHEN Released_Year BETWEEN 1950 AND 1959 THEN '1950s'
        WHEN Released_Year BETWEEN 1960 AND 1969 THEN '1960s'
        WHEN Released_Year BETWEEN 1970 AND 1979 THEN '1970s'
        WHEN Released_Year BETWEEN 1980 AND 1989 THEN '1980s'
        WHEN Released_Year BETWEEN 1990 AND 1999 THEN '1990s'
        WHEN Released_Year BETWEEN 2000 AND 2009 THEN '2000s'
        WHEN Released_Year BETWEEN 2010 AND 2019 THEN '2010s'
        ELSE '2020s'
    END
ORDER BY avg_rating DESC;

-- 8. Recent performance (2010-2020)
SELECT 
    Released_Year,
    COUNT(*) as movies_released,
    ROUND(AVG(IMDB_Rating), 2) as avg_rating,
    MAX(IMDB_Rating) as best_rating,
    (SELECT Series_Title FROM imdb_movies i 
     WHERE i.Released_Year = imdb_movies.Released_Year 
     ORDER BY IMDB_Rating DESC LIMIT 1) as top_movie
FROM imdb_movies
WHERE Released_Year BETWEEN 2010 AND 2020
GROUP BY Released_Year
ORDER BY Released_Year DESC;

-- ================================================
-- 🎭 CERTIFICATE ANALYSIS  
-- ================================================

-- 9. Movies by certification rating
SELECT 
    COALESCE(Certificate, 'Not Rated') as certificate,
    COUNT(*) as movie_count,
    ROUND(AVG(IMDB_Rating), 2) as avg_rating,
    ROUND(AVG(CASE WHEN Gross > 0 THEN Gross END)/1000000, 0) as avg_revenue_millions
FROM imdb_movies
GROUP BY COALESCE(Certificate, 'Not Rated')
HAVING COUNT(*) >= 5
ORDER BY avg_rating DESC;

-- ================================================
-- 📊 ENGAGEMENT METRICS
-- ================================================

-- 10. Audience engagement analysis
SELECT 
    CASE 
        WHEN No_of_Votes >= 1000000 THEN 'Highly Popular (1M+ votes)'
        WHEN No_of_Votes >= 500000 THEN 'Popular (500K+ votes)'
        WHEN No_of_Votes >= 250000 THEN 'Well-Known (250K+ votes)'
        WHEN No_of_Votes >= 100000 THEN 'Moderate Following (100K+ votes)'
        ELSE 'Limited Following'
    END as popularity_level,
    COUNT(*) as movie_count,
    ROUND(AVG(IMDB_Rating), 2) as avg_rating,
    FORMAT(AVG(No_of_Votes), 0) as avg_votes,
    FORMAT(MIN(No_of_Votes), 0) as min_votes,
    FORMAT(MAX(No_of_Votes), 0) as max_votes
FROM imdb_movies
GROUP BY 
    CASE 
        WHEN No_of_Votes >= 1000000 THEN 'Highly Popular (1M+ votes)'
        WHEN No_of_Votes >= 500000 THEN 'Popular (500K+ votes)'
        WHEN No_of_Votes >= 250000 THEN 'Well-Known (250K+ votes)'
        WHEN No_of_Votes >= 100000 THEN 'Moderate Following (100K+ votes)'
        ELSE 'Limited Following'
    END
ORDER BY AVG(IMDB_Rating) DESC;

-- ================================================
-- 🔍 DATA QUALITY INSIGHTS
-- ================================================

-- 11. Missing data patterns by decade
SELECT 
    FLOOR(Released_Year/10)*10 as decade,
    COUNT(*) as total_movies,
    COUNT(Gross) as movies_with_revenue,
    COUNT(Meta_score) as movies_with_metacritic,
    ROUND(COUNT(Gross)*100.0/COUNT(*), 1) as revenue_coverage_percent,
    ROUND(COUNT(Meta_score)*100.0/COUNT(*), 1) as metacritic_coverage_percent
FROM imdb_movies
GROUP BY FLOOR(Released_Year/10)*10
ORDER BY decade;

-- 12. Runtime distribution analysis
SELECT 
    CASE 
        WHEN Runtime_Minutes < 90 THEN 'Short (< 90 min)'
        WHEN Runtime_Minutes BETWEEN 90 AND 120 THEN 'Standard (90-120 min)'
        WHEN Runtime_Minutes BETWEEN 121 AND 150 THEN 'Long (121-150 min)'
        WHEN Runtime_Minutes BETWEEN 151 AND 180 THEN 'Very Long (151-180 min)'
        ELSE 'Epic (180+ min)'
    END as runtime_category,
    COUNT(*) as movie_count,
    ROUND(AVG(IMDB_Rating), 2) as avg_rating,
    ROUND(AVG(Runtime_Minutes), 0) as avg_runtime,
    MIN(Runtime_Minutes) as min_runtime,
    MAX(Runtime_Minutes) as max_runtime
FROM imdb_movies
WHERE Runtime_Minutes IS NOT NULL
GROUP BY 
    CASE 
        WHEN Runtime_Minutes < 90 THEN 'Short (< 90 min)'
        WHEN Runtime_Minutes BETWEEN 90 AND 120 THEN 'Standard (90-120 min)'
        WHEN Runtime_Minutes BETWEEN 121 AND 150 THEN 'Long (121-150 min)'
        WHEN Runtime_Minutes BETWEEN 151 AND 180 THEN 'Very Long (151-180 min)'
        ELSE 'Epic (180+ min)'
    END
ORDER BY avg_rating DESC;

-- ================================================
-- 📈 EXPLORATION SUMMARY
-- ================================================

-- 13. Quick exploration summary
SELECT 
    'Data Exploration Complete' as status,
    CONCAT(
        'Dataset contains ', COUNT(*), ' movies spanning ',
        MAX(Released_Year) - MIN(Released_Year) + 1, ' years (',
        MIN(Released_Year), '-', MAX(Released_Year), ')'
    ) as summary,
    CONCAT(
        'Average rating: ', ROUND(AVG(IMDB_Rating), 2),
        ', Revenue data: ', ROUND(COUNT(Gross)*100.0/COUNT(*), 0), '%'
    ) as key_stats
FROM imdb_movies;

-- Ready for business analysis in 03_business_analysis.sql!
