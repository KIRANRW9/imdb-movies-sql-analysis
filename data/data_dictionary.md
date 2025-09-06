# 📊 Data Dictionary - IMDB Top 1000 Movies Dataset

## 🎬 Dataset Overview
- **Source**: IMDB (Internet Movie Database) Top 1000 Movies
- **Time Period**: 1920 - 2020 (100 years of cinema)
- **Total Records**: 1,000 movies (highest-rated films)
- **Data Quality**: Premium selection, professionally curated
- **Analysis Purpose**: Demonstrate SQL skills for Data Analyst portfolio

## 🗃️ Database Schema

### Table: `imdb_movies`
**Engine**: InnoDB  
**Character Set**: UTF8MB4 (supports international characters)  
**Primary Key**: `id` (Auto-increment)

## 📋 Column Specifications

| Column Name | Data Type | Description | Example Value | Business Purpose | Data Quality |
|-------------|-----------|-------------|---------------|------------------|--------------|
| **id** | INT AUTO_INCREMENT | Primary key identifier | 1, 2, 3... | Database indexing | 100% Complete |
| **Poster_Link** | TEXT | URL to movie poster image | https://m.media-amazon.com/... | Visual reference, web scraping source | 100% Complete |
| **Series_Title** | VARCHAR(500) | Official movie title | "The Shawshank Redemption" | Primary identifier, text analysis | 100% Complete |
| **Released_Year** | INT | Year of theatrical release | 1994 | Temporal analysis, trend identification | 100% Complete |
| **Certificate** | VARCHAR(20) | Age rating/certification | "A", "U", "UA", "R", "PG-13" | Audience targeting, content analysis | ~95% Complete |
| **Runtime** | VARCHAR(20) | Movie duration (original format) | "142 min" | Source data preservation | 100% Complete |
| **Runtime_Minutes** | INT | Duration in minutes (calculated) | 142 | Quantitative analysis, statistical operations | 100% Complete |
| **Genre** | VARCHAR(200) | Movie genres (comma-separated) | "Crime, Drama" | Market segmentation, preference analysis | 100% Complete |
| **IMDB_Rating** | DECIMAL(3,1) | IMDB user rating | 9.3 | Quality benchmark, ranking criteria | 100% Complete |
| **Overview** | TEXT | Movie plot summary/synopsis | "Two imprisoned men bond over..." | Content analysis, NLP opportunities | 100% Complete |
| **Meta_score** | INT | Metacritic critic score | 80 | Professional critic consensus | ~70% Complete |
| **Director** | VARCHAR(200) | Primary director name | "Frank Darabont" | Creative talent analysis | ~98% Complete |
| **Star1** | VARCHAR(200) | Lead actor/actress | "Tim Robbins" | Star power analysis, casting insights | ~95% Complete |
| **Star2** | VARCHAR(200) | Second lead performer | "Morgan Freeman" | Supporting cast analysis | ~90% Complete |
| **Star3** | VARCHAR(200) | Third lead performer | "Bob Gunton" | Ensemble cast analysis | ~85% Complete |
| **Star4** | VARCHAR(200) | Fourth lead performer | "William Sadler" | Full cast representation | ~80% Complete |
| **No_of_Votes** | BIGINT | Total IMDB user votes | 2,343,110 | Popularity metric, engagement indicator | 100% Complete |
| **Gross** | BIGINT | Box office revenue (USD) | 16,000,000 | Commercial success metric | ~60% Complete |

## 🔍 Data Quality Assessment

### Completeness Analysis
| Field Category | Completeness | Impact on Analysis | Handling Strategy |
|----------------|--------------|-------------------|-------------------|
| **Core Identifiers** | 100% | Critical ✅ | No issues |
| **Quality Metrics** | 100% | Critical ✅ | Primary analysis foundation |
| **Temporal Data** | 100% | High ✅ | Trend analysis ready |
| **Creative Talent** | 95-98% | High ✅ | Minor NULL handling needed |
| **Financial Data** | 60% | Medium ⚠️ | Focus on available data, note limitations |
| **Critical Scores** | 70% | Medium ⚠️ | Supplementary analysis only |

### Data Integrity Checks
- ✅ **Rating Range**: All IMDB ratings between 1.0-10.0
- ✅ **Year Validation**: All release years between 1920-2020
- ✅ **Runtime Logic**: All runtimes between 45-240 minutes (reasonable range)
- ✅ **Vote Counts**: All vote counts > 25,000 (ensures statistical significance)
- ✅ **Text Encoding**: UTF8MB4 handles international characters properly

## 📈 Business Context & Usage

### Primary Analysis Applications
1. **Quality Benchmarking**: IMDB ratings as excellence standard
2. **Trend Analysis**: Decade-by-decade cinema evolution
3. **Talent Assessment**: Director and actor success patterns
4. **Market Intelligence**: Genre performance and audience preferences
5. **Investment Insights**: Revenue correlation with quality metrics

### Key Business Questions Answered
- Which genres consistently deliver quality content?
- How has cinema quality evolved over decades?
- What characteristics define successful directors?
- Is there correlation between critical acclaim and box office?
- Which eras produced the most enduring classics?

## 🎯 Technical Implementation Notes

### SQL Optimization Considerations
```sql
-- Indexes created for performance
CREATE INDEX idx_released_year ON imdb_movies(Released_Year);
CREATE INDEX idx_imdb_rating ON imdb_movies(IMDB_Rating);
CREATE INDEX idx_director ON imdb_movies(Director);
CREATE INDEX idx_genre ON imdb_movies(Genre);
CREATE INDEX idx_votes ON imdb_movies(No_of_Votes);
```

### Data Type Justifications
- **DECIMAL(3,1)** for ratings: Preserves precision, enables accurate calculations
- **BIGINT** for votes/revenue: Handles large numbers without overflow
- **VARCHAR(500)** for titles: Accommodates long international titles
- **TEXT** for overviews: Variable-length content without size limits

### Character Encoding Strategy
- **UTF8MB4**: Full Unicode support for international film titles
- **Collation**: utf8mb4_unicode_ci for proper sorting and comparison
- **Special Characters**: Handles accents, non-Latin scripts, emojis

## 📊 Statistical Overview

### Dataset Characteristics
- **Average Rating**: ~8.25/10 (top-tier selection)
- **Median Runtime**: ~130 minutes (standard feature length)
- **Genre Distribution**: Drama-heavy (45%), balanced representation
- **Temporal Spread**: Weighted toward modern era (post-2000)
- **Revenue Range**: $1M - $850M+ (wide commercial spectrum)

### Analytical Strengths
- **High Quality Standard**: All films pre-screened for excellence
- **Rich Metadata**: Multiple dimensions for analysis
- **Temporal Depth**: Century-spanning historical context
- **Commercial Mix**: Both art house and blockbuster representation
- **Cultural Diversity**: International films included

### Known Limitations
- **Selection Bias**: Only highest-rated films (not representative of all cinema)
- **Revenue Gaps**: Older films often missing box office data
- **Geographic Bias**: English-language/Western films over-represented
- **Recency Bias**: Modern films have more complete metadata
- **Currency Issues**: No inflation adjustment for historical revenue

## 🔧 Data Analyst Workflow Integration

### Import Process
```sql
-- Professional data import using MySQL Workbench
-- Table Data Import Wizard recommended for CSV files
-- LOAD DATA INFILE for command-line bulk imports
-- Always validate row counts and data types post-import
```

### Quality Validation Queries
```sql
-- Check for anomalies
SELECT COUNT(*) FROM imdb_movies WHERE IMDB_Rating < 1 OR IMDB_Rating > 10;
SELECT COUNT(*) FROM imdb_movies WHERE Released_Year < 1888 OR Released_Year > 2025;
SELECT COUNT(*) FROM imdb_movies WHERE Runtime_Minutes < 1 OR Runtime_Minutes > 600;
```

### Business Analysis Preparation
```sql
-- Create calculated fields for analysis
UPDATE imdb_movies SET Runtime_Minutes = 
  CAST(REPLACE(REPLACE(Runtime, ' min', ''), ' mins', '') AS UNSIGNED)
WHERE Runtime IS NOT NULL;
```

## 📋 Project Portfolio Context

This data dictionary demonstrates:
- **Technical Documentation Skills**: Professional metadata documentation
- **Business Understanding**: Context-aware field descriptions  
- **Data Quality Awareness**: Completeness and integrity assessment
- **Analytical Thinking**: Consideration of limitations and biases
- **Professional Standards**: Enterprise-level documentation practices

Perfect for showcasing data analyst capabilities to recruiters and employers in the entertainment, media, or business intelligence sectors.

---

*This data dictionary serves as the foundation for comprehensive SQL analysis demonstrating data exploration, business intelligence, and strategic insight generation suitable for entry-level Data Analyst positions.*

## Data Quality Notes

### Missing Values
- **Gross**: ~40% of records missing (older films, international releases)
- **Meta_score**: ~30% of records missing (not all films reviewed by Metacritic)
- **Certificate**: ~5% missing or inconsistent formats

### Data Consistency
- **Genres**: Comma-separated, inconsistent spacing
- **Runtime**: All in "XXX min" format, requires parsing
- **Currency**: All revenue in USD, not adjusted for inflation
- **Names**: UTF-8 encoded to handle international characters

### Key Constraints
- **IMDB_Rating**: Always present, range 1.0-10.0
- **Released_Year**: Always present, validated range
- **Series_Title**: Always present, unique identifiers
- **No_of_Votes**: Always present, minimum threshold for inclusion

## Analysis Considerations

### Temporal Bias
- Dataset skewed toward recent films (2000+)
- Earlier films may have fewer votes/reviews
- Revenue data more complete for recent releases

### Geographic Bias  
- Primarily English-language films
- US box office figures (domestic market)
- Western/Hollywood-centric selection

### Selection Bias
- "Top 1000" represents highest-rated films
- Not representative of all cinema
- Popularity and critical acclaim conflated

## Usage Recommendations

### For Analysis
- Use `Runtime_Minutes` instead of `Runtime` for calculations
- Handle NULL values in `Gross` and `Meta_score` appropriately  
- Consider vote count as engagement/popularity metric
- Genre analysis requires string parsing/splitting

### For Visualization
- Group years into decades for trend analysis
- Use consistent color coding for genres
- Consider logarithmic scales for revenue/votes
- Filter low-vote-count films for reliability

### For Business Intelligence
- Focus on post-2000 data for current market insights
- Combine rating and revenue for success metrics
- Use director/star data for talent analysis
- Consider seasonal release patterns
