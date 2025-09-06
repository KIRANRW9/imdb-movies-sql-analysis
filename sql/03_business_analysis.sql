-- ================================================
-- IMDB MOVIES ANALYSIS - BUSINESS ANALYSIS
-- ================================================
-- Author: Kiran Rangu
-- Date: September 2025
-- Purpose: Advanced business insights and analytical queries
-- Skills: Complex JOINs, window functions, business metrics
-- ================================================

USE imdb_analysis;

-- ================================================
-- 🎭 GENRE ANALYSIS
-- ================================================

-- 1. Genre performance analysis (handling multiple genres)
SELECT 
    CASE 
        WHEN Genre LIKE '%Drama%' THEN 'Drama'
        WHEN Genre LIKE '%Action%' THEN 'Action'
        WHEN Genre LIKE '%Comedy%' THEN 'Comedy'
        WHEN Genre LIKE '%Crime%' THEN 'Crime'
        WHEN Genre LIKE '%Adventure%' THEN 'Adventure'
        WHEN Genre LIKE '%Thriller%' THEN 'Thriller'
        WHEN Genre LIKE '%Biography%' THEN 'Biography'
        WHEN Genre LIKE '%Romance%' THEN 'Romance'
        WHEN Genre LIKE '%Sci-Fi%' THEN 'Sci-Fi'
        WHEN Genre LIKE '%Fantasy%' THEN 'Fantasy'
        WHEN Genre LIKE '%Horror%' THEN 'Horror'
        WHEN Genre LIKE '%Western%' THEN 'Western'
        ELSE 'Other'
    END as primary_genre,
    COUNT(*) as movie_count,
    ROUND(AVG(IMDB_Rating), 2) as avg_rating,
    ROUND(AVG(CASE WHEN Gross > 0 THEN Gross END)/1000000, 1) as avg_revenue_millions,
    FORMAT(SUM(No_of_Votes), 0) as total_votes
FROM imdb_movies
WHERE Genre IS NOT NULL
GROUP BY 
    CASE 
        WHEN Genre LIKE '%Drama%' THEN 'Drama'
        WHEN Genre LIKE '%Action%' THEN 'Action'
        WHEN Genre LIKE '%Comedy%' THEN 'Comedy'
        WHEN Genre LIKE '%Crime%' THEN 'Crime'
        WHEN Genre LIKE '%Adventure%' THEN 'Adventure'
        WHEN Genre LIKE '%Thriller%' THEN 'Thriller'
        WHEN Genre LIKE '%Biography%' THEN 'Biography'
        WHEN Genre LIKE '%Romance%' THEN 'Romance'
        WHEN Genre LIKE '%Sci-Fi%' THEN 'Sci-Fi'
        WHEN Genre LIKE '%Fantasy%' THEN 'Fantasy'
        WHEN Genre LIKE '%Horror%' THEN 'Horror'
        WHEN Genre LIKE '%Western%' THEN 'Western'
        ELSE 'Other'
    END
HAVING movie_count >= 10
ORDER BY avg_rating DESC;

-- ================================================
-- 💰 REVENUE ANALYSIS
-- ================================================

-- 2. Critical acclaim vs commercial success
SELECT 
    Series_Title,
    Released_Year,
    IMDB_Rating,
    CONCAT('$', FORMAT(Gross/1000000, 1), 'M') as revenue_millions,
    FORMAT(No_of_Votes, 0) as votes,
    CASE 
        WHEN IMDB_Rating >= 8.5 AND Gross >= 300000000 THEN 'Blockbuster Masterpiece'
        WHEN IMDB_Rating >= 8.5 AND Gross >= 100000000 THEN 'Critical & Commercial Hit'
        WHEN IMDB_Rating >= 8.5 THEN 'Critical Darling'
        WHEN Gross >= 500000000 THEN 'Box Office Giant'
        WHEN Gross >= 200000000 THEN 'Commercial Success'
        ELSE 'Quality Film'
    END as success_category
FROM imdb_movies
WHERE Gross IS NOT NULL AND IMDB_Rating >= 7.5
ORDER BY IMDB_Rating DESC, Gross DESC
LIMIT 25;

-- 3. Revenue trends by decade
SELECT 
    FLOOR(Released_Year/10)*10 as decade,
    COUNT(CASE WHEN Gross IS NOT NULL THEN 1 END) as movies_with_revenue,
    CONCAT('$', FORMAT(AVG(CASE WHEN Gross > 0 THEN Gross END)/1000000, 0), 'M') as avg_revenue,
    CONCAT('$', FORMAT(MAX(Gross)/1000000, 0), 'M') as highest_revenue,
    (SELECT Series_Title FROM imdb_movies i 
     WHERE i.Gross IS NOT NULL 
     AND FLOOR(i.Released_Year/10)*10 = FLOOR(imdb_movies.Released_Year/10)*10
     ORDER BY i.Gross DESC LIMIT 1) as top_earner
FROM imdb_movies
WHERE Released_Year >= 1970  -- Focus on modern era with better revenue data
GROUP BY FLOOR(Released_Year/10)*10
ORDER BY decade;

-- ================================================
-- 👨‍🎬 DIRECTOR SUCCESS ANALYSIS
-- ================================================

-- 4. Most successful directors (quality + quantity)
SELECT 
    Director,
    COUNT(*) as total_movies,
    ROUND(AVG(IMDB_Rating), 2) as avg_rating,
    COUNT(CASE WHEN IMDB_Rating >= 8.0 THEN 1 END) as excellent_movies,
    ROUND(AVG(CASE WHEN Gross > 0 THEN Gross END)/1000000, 0) as avg_revenue_millions,
    FORMAT(SUM(No_of_Votes), 0) as total_audience_votes,
    ROUND(AVG(No_of_Votes), 0) as avg_votes_per_movie
FROM imdb_movies
WHERE Director IS NOT NULL
GROUP BY Director
HAVING COUNT(*) >= 3 AND AVG(IMDB_Rating) >= 8.0
ORDER BY avg_rating DESC, total_movies DESC
LIMIT 15;

-- 5. Directors with consistent box office success
SELECT 
    Director,
    COUNT(CASE WHEN Gross IS NOT NULL THEN 1 END) as movies_with_revenue,
    ROUND(AVG(CASE WHEN Gross > 0 THEN Gross END)/1000000, 0) as avg_revenue_millions,
    ROUND(AVG(IMDB_Rating), 2) as avg_rating,
    COUNT(CASE WHEN Gross >= 200000000 THEN 1 END) as blockbusters_200m_plus
FROM imdb_movies
WHERE Director IS NOT NULL
GROUP BY Director
HAVING COUNT(CASE WHEN Gross IS NOT NULL THEN 1 END) >= 3
ORDER BY avg_revenue_millions DESC, avg_rating DESC
LIMIT 15;

-- ================================================
-- ⭐ STAR PERFORMANCE ANALYSIS
-- ================================================

-- 6. Leading actors with highest average ratings
WITH actor_stats AS (
    SELECT Star1 as actor, IMDB_Rating, No_of_Votes, Gross FROM imdb_movies WHERE Star1 IS NOT NULL
    UNION ALL
    SELECT Star2 as actor, IMDB_Rating, No_of_Votes, Gross FROM imdb_movies WHERE Star2 IS NOT NULL
    UNION ALL
    SELECT Star3 as actor, IMDB_Rating, No_of_Votes, Gross FROM imdb_movies WHERE Star3 IS NOT NULL
    UNION ALL
    SELECT Star4 as actor, IMDB_Rating, No_of_Votes, Gross FROM imdb_movies WHERE Star4 IS NOT NULL
)
SELECT 
    actor,
    COUNT(*) as movie_appearances,
    ROUND(AVG(IMDB_Rating), 2) as avg_rating,
    COUNT(CASE WHEN IMDB_Rating >= 8.0 THEN 1 END) as excellent_movies,
    FORMAT(AVG(No_of_Votes), 0) as avg_votes,
    ROUND(AVG(CASE WHEN Gross > 0 THEN Gross END)/1000000, 0) as avg_revenue_millions
FROM actor_stats
WHERE actor IS NOT NULL AND actor != ''
GROUP BY actor
HAVING COUNT(*) >= 4  -- Actors with 4+ appearances in top movies
ORDER BY avg_rating DESC, movie_appearances DESC
LIMIT 20;

-- ================================================
-- 📊 RATING vs POPULARITY ANALYSIS
-- ================================================

-- 7. High rating vs high popularity correlation
SELECT 
    CASE 
        WHEN IMDB_Rating >= 8.5 AND No_of_Votes >= 500000 THEN 'Critical Acclaim + High Popularity'
        WHEN IMDB_Rating >= 8.5 THEN 'Critical Acclaim'
        WHEN No_of_Votes >= 1000000 THEN 'High Popularity'
        WHEN No_of_Votes >= 500000 THEN 'Moderate Popularity'
        ELSE 'Niche Appeal'
    END as movie_category,
    COUNT(*) as movie_count,
    ROUND(AVG(IMDB_Rating), 2) as avg_rating,
    FORMAT(AVG(No_of_Votes), 0) as avg_votes,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM imdb_movies), 1) as percentage_of_dataset
FROM imdb_movies
GROUP BY 
    CASE 
        WHEN IMDB_Rating >= 8.5 AND No_of_Votes >= 500000 THEN 'Critical Acclaim + High Popularity'
        WHEN IMDB_Rating >= 8.5 THEN 'Critical Acclaim'
        WHEN No_of_Votes >= 1000000 THEN 'High Popularity'
        WHEN No_of_Votes >= 500000 THEN 'Moderate Popularity'
        ELSE 'Niche Appeal'
    END
ORDER BY avg_rating DESC;

-- ================================================
-- 🎯 BUSINESS RECOMMENDATIONS
-- ================================================

-- 8. Investment sweet spots (Rating vs Revenue potential)
SELECT 
    primary_genre,
    runtime_category,
    COUNT(*) as sample_size,
    ROUND(AVG(IMDB_Rating), 2) as avg_rating,
    ROUND(AVG(CASE WHEN Gross > 0 THEN Gross END)/1000000, 0) as avg_revenue_millions,
    'Recommended' as investment_advice
FROM (
    SELECT 
        CASE 
            WHEN Genre LIKE '%Drama%' THEN 'Drama'
            WHEN Genre LIKE '%Action%' THEN 'Action'
            WHEN Genre LIKE '%Comedy%' THEN 'Comedy'
            WHEN Genre LIKE '%Crime%' THEN 'Crime'
            ELSE 'Other'
        END as primary_genre,
        CASE 
            WHEN Runtime_Minutes BETWEEN 90 AND 120 THEN 'Standard Length'
            WHEN Runtime_Minutes BETWEEN 121 AND 150 THEN 'Long Format'
            ELSE 'Other Length'
        END as runtime_category,
        IMDB_Rating,
        Gross
    FROM imdb_movies
    WHERE Genre IS NOT NULL AND Runtime_Minutes IS NOT NULL
) as categorized_movies
WHERE primary_genre != 'Other' AND runtime_category != 'Other Length'
GROUP BY primary_genre, runtime_category
HAVING COUNT(*) >= 5 AND AVG(IMDB_Rating) >= 8.0
ORDER BY avg_rating DESC, avg_revenue_millions DESC;

-- ================================================
-- 📈 MODERN TRENDS (2000-2020)
-- ================================================

-- 9. Recent success patterns
SELECT 
    Released_Year,
    COUNT(*) as total_movies,
    ROUND(AVG(IMDB_Rating), 2) as avg_rating,
    COUNT(CASE WHEN Gross >= 200000000 THEN 1 END) as blockbusters,
    ROUND(AVG(CASE WHEN Gross > 0 THEN Gross END)/1000000, 0) as avg_revenue_millions,
    (SELECT Genre FROM imdb_movies i 
     WHERE i.Released_Year = imdb_movies.Released_Year 
     ORDER BY i.IMDB_Rating DESC LIMIT 1) as top_genre_that_year
FROM imdb_movies
WHERE Released_Year BETWEEN 2000 AND 2020
GROUP BY Released_Year
ORDER BY Released_Year DESC;

-- 10. Metacritic vs IMDB correlation
SELECT 
    CASE 
        WHEN Meta_score >= 80 THEN 'Universal Acclaim (80+)'
        WHEN Meta_score >= 60 THEN 'Generally Favorable (60-79)'
        WHEN Meta_score >= 40 THEN 'Mixed Reviews (40-59)'
        ELSE 'Unfavorable (Below 40)'
    END as metacritic_category,
    COUNT(*) as movie_count,
    ROUND(AVG(IMDB_Rating), 2) as avg_imdb_rating,
    ROUND(AVG(Meta_score), 0) as avg_metacritic_score,
    ROUND(AVG(CASE WHEN Gross > 0 THEN Gross END)/1000000, 0) as avg_revenue_millions
FROM imdb_movies
WHERE Meta_score IS NOT NULL
GROUP BY 
    CASE 
        WHEN Meta_score >= 80 THEN 'Universal Acclaim (80+)'
        WHEN Meta_score >= 60 THEN 'Generally Favorable (60-79)'
        WHEN Meta_score >= 40 THEN 'Mixed Reviews (40-59)'
        ELSE 'Unfavorable (Below 40)'
    END
ORDER BY avg_imdb_rating DESC;

-- Business analysis complete! 
-- Proceed to summary insights in 04_summary_insights.sql
