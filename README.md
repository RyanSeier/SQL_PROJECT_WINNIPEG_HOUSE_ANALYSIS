# WORK IN PROGRESS

Context:
Must haves:
I am looking to buy a house in the coming years in the 300k - 450k price range
I want to live in an area that has the bottom 30% of crime rates in Winnipeg
I want to live in a relatively newer house, built after 1960

Desired property features:
- Basement
- Living area over 1,100 sqft
- Garage
- 2+ bedrooms
- 2+ bathrooms


Questions:
1. What areas of the city suit my price range?
2. Which areas of the city have the most crime?
3. Which areas of the city have the least crime?
4. Which areas have newer properties built after 1980?
5. Which areas have the most houses that include property features I would like my house to have?
6. What are the top 5 optimal areas of the city for me to live in?
7. What types of crimes are most likely in my selected top 5 areas to live in?


# Introduction

The purpose of this project is to investigate neighbourhoods and houses in the City of Winnipeg, with the goal of determining which neighbourhoods would best suite my living needs based on the criteria I provide with my ideal house.  The most important factors under consideration are housing costs, the age of the house, desirable property features, and crime rates.  These criteria will be sifted through using data provided by the City of Winnipeg (referenced later) stored on a local PostgreSQL database, with querying code available for review in this repository here on GitHub.


# Background

### Dataset
Two core datasets were used in this project, one of which is the City of Winnipeg Housing Assessment Parcel Dataset which records property assessment values, property features, and other individual house attributes for thousands of residential properties. The other dataset used is City of Winnipeg Crime Report dataset, which covers crime rates and types by neighbourhood on an annual basis for the 2022 and 2023 years.  You can find the link to both datasets in the [reference](#references) section of this README.

### Project Goal
The goal of this project is to analyze a collection of Winnipeg houses and neighbourhoods based on property features, prices, and crime rates, to find a list of neighbourhoods that fit my desired criteria for a living area.  The hopes to obtain outputs of a selection of neighbourhoods that can simplify my future house hunting process by showcasing areas of houses that are most likely to appeal to me.  The requirements in a home that I am currently looking for are listed below.

Ideal home requirements:
- Low crime rate neighbourhood (relative to City of Winnipeg average)
- Has a price range between $300,000 and $450,000
- Has a basement
- Has a garage
- Living area over 1,100 sqft
- 2+ bedrooms
- 2+ bathrooms

#### The main questions I aim to answer in this project are below, with links to their associated queries:
We want to first find out which neighbourhoods in Winnipeg best suit my needs in relation to price range, property age, features, and crime rate.  Then we'll create a query to suggest what our top 5 neighbourhood choices are based on our previous findings.  Finally, we'll delve into the most common crimes for those chosen neighbourhoods to get a rough understanding of worst case scenarios we could experience if living there.  Below is a list of these questions in point form, with links to the appropriate queries and results.

Questions:
1. [Which neighbourhoods best suit my price range?](/project_queries/Analysis%20Queries/q1_price_range.sql)
2. [Which neighbourhoods have the lowest crime rates?](/project_queries/Analysis%20Queries/q2_least_crime.sql)
3. [Which neighbourhoods have the highest crime rates?](/project_queries/Analysis%20Queries/q3_most_crime.sql)
4. [Which neighbourhoods have newer properties built after 1980?](/project_queries/Analysis%20Queries/q4_newer_houses.sql)
5. [Which neighbourhoods have the most houses that include property features I would like my house to have?](/project_queries/Analysis%20Queries/q5_desired_features.sql)
6. [Based on the findings in questions 1-5, what are the top 5 optimal neighbourhoods of the city for me to live in?](/project_queries/Analysis%20Queries/q6_optimal_neighbourhoods.sql)
7. [What types of crimes are most likely in my selected top 5 areas to live in?](/project_queries/Analysis%20Queries/q7_crime_types_optimal_neighbourhoods.sql)

# Tools Used
The following seven tools were used to query and analyze the data:<br>

1. **SQL:** My preferred language of choice for querying and sifting through databases for analysis.
2. **PostgreSQL:** The primary database management tool used for this project due its popularity and ease of use, used for all queries in the  [project_queries](/project_queries/) folder.
3. **Visual Studio Code:** My favorite code editor for SQL queries and Python scripts, chosen for its ease of use and my familiarity with using it for the last 1-2 years.
4. **Git, GitHub Desktop, and GitHub:** Used for project sharing, tracking, and future project collaboration efforts.  Chosen due to past experience with these tools, and their current popularity amongst analysts.
5. **ChatGPT:** Used for quickly creating markdown tables for query results

# The Analysis


### [Which neighbourhoods best suit my price range?](/project_queries/Analysis%20Queries/q1_price_range.sql)
<details>
<summary>Click to expand/collapse</summary>

### <span style="color:tan">Query Used:</span>
```sql
-- Top 10 neighbourhoods with the most properties that fit my ideal price range
SELECT 
    "Neighbourhood Area",
    COUNT("Neighbourhood Area") as num_houses
FROM property_cleaned
WHERE "Total Proposed Assessment Value" >= 300000
    AND "Total Proposed Assessment Value" <= 450000
GROUP BY
    "Neighbourhood Area"
ORDER BY
    num_houses DESC
LIMIT 10;
```

### <span style="color:tan">Query Output:</span>
| Neighbourhood Area | num_houses |
|--------------------|------------|
| WINDSOR PARK       | 3020       |
| TYNDALL PARK       | 2807       |
| THE MAPLES         | 2440       |
| ROSSMERE-A         | 2346       |
| RIVER PARK SOUTH   | 2223       |
| WESTWOOD           | 2071       |
| RIVER EAST         | 1903       |
| CRESTVIEW          | 1848       |
| FORT RICHMOND      | 1819       |
| GARDEN CITY        | 1761       |

### <span style="color:tan">Query Highlights:</span>


### <span style="color:tan">Result Interpretation:</span>

</details>

### [Which neighbourhoods have the lowest crime rates?](/project_queries/Analysis%20Queries/q2_least_crime.sql)
<details>
<summary>Click to expand/collapse</summary>

### <span style="color:tan">Query Used:</span>
```sql
-- Check top 10 neighbourhoods for least amount of crime that have at least 500 residential buildings in that neighbourhood
WITH crime_cte AS (
    SELECT "Neighbourhoods", SUM("Count") AS num_crimes
    FROM crime_report_cleaned
    GROUP BY "Neighbourhoods"
    ),

property_cte AS (
    SELECT "Neighbourhood Area", COUNT("Roll Number") AS num_houses
    FROM property_cleaned
    GROUP BY "Neighbourhood Area"
    )

SELECT
    "Neighbourhoods",
    num_crimes,
    num_houses
FROM crime_cte crm
LEFT JOIN property_cte prp
    ON crm."Neighbourhoods" = prp."Neighbourhood Area"
WHERE num_houses > 500
ORDER BY num_crimes ASC
LIMIT 10;
```

### <span style="color:tan">Query Output:</span>
| Neighbourhood             | num_crimes | num_houses |
|---------------------------|------------|------------|
| NIAKWA PLACE              | 32         | 754        |
| ERIC COY                  | 32         | 950        |
| RIDGEWOOD SOUTH           | 32         | 855        |
| RICHMOND LAKES            | 35         | 622        |
| ROSSER-OLD KILDONAN       | 39         | 788        |
| FRAIPONT                  | 41         | 1237       |
| BRIDGWATER LAKES          | 44         | 1194       |
| ST. VITAL PERIMETER SOUTH | 44         | 627        |
| PARC LA SALLE             | 48         | 806        |
| ROYALWOOD                 | 56         | 1725       |

### <span style="color:tan">Query Highlights</span>


### <span style="color:tan">Result Interpretation:</span>

</details>

### [Which neighbourhoods have the highest crime rates?](/project_queries/Analysis%20Queries/q3_most_crime.sql)
<details>
<summary>Click to expand/collapse</summary>

### <span style="color:tan">Query Used:</span>
```sql
-- Top 10 neighbourhoods with at least 500 residential buildings and the most amount of crime
WITH crime_cte AS (
    SELECT "Neighbourhoods", SUM("Count") AS num_crimes
    FROM crime_report_cleaned
    GROUP BY "Neighbourhoods"
    ),

property_cte AS (
    SELECT "Neighbourhood Area", COUNT("Roll Number") AS num_houses
    FROM property_cleaned
    GROUP BY "Neighbourhood Area"
    )

SELECT
    "Neighbourhoods",
    num_crimes,
    num_houses
FROM crime_cte crm
LEFT JOIN property_cte prp
    ON crm."Neighbourhoods" = prp."Neighbourhood Area"
WHERE num_houses > 500
ORDER BY num_crimes DESC
LIMIT 10;
```

### <span style="color:tan">Query Output:</span>
| Neighbourhood         | num_crimes | num_houses |
|-----------------------|------------|------------|
| WEST ALEXANDER        | 2242       | 800        |
| DANIEL MCINTYRE       | 1957       | 2293       |
| WILLIAM WHYTE         | 1849       | 1759       |
| SPENCE                | 1788       | 617        |
| ST. JOHN'S            | 1390       | 2370       |
| CHALMERS              | 1215       | 2883       |
| ST. MATTHEWS          | 1165       | 1518       |
| CENTRAL ST. BONIFACE  | 879        | 1154       |
| ROSSMERE-A            | 822        | 3366       |
| WESTON                | 784        | 1786       |

### <span style="color:tan">Query Highlights:</span>


### <span style="color:tan">Result Interpretation:</span>

</details>

### [Which neighbourhoods have newer properties built after 1980?](/project_queries/Analysis%20Queries/q4_newer_houses.sql)
<details>
<summary>Click to expand/collapse</summary>

### <span style="color:tan">Query Used:</span>
```sql
-- Top 10 neighbourhoods with the highest count of houses built after 1980, along with the average year built of all houses in each neighbourhood
SELECT
    "Neighbourhood Area",
    COUNT(CASE WHEN "Year Built" >= 1980 THEN 1 END) AS num_newer_houses,
    ROUND(AVG("Year Built"),0) AS avg_year_built
FROM property_cleaned
GROUP BY "Neighbourhood Area"
ORDER BY num_newer_houses DESC
LIMIT 10;
```
### <span style="color:tan">Query Output:</span>
| Neighbourhood Area | num_newer_houses | avg_year_built |
|--------------------|-------------------|----------------|
| RIVER PARK SOUTH   | 3425              | 1991           |
| DAKOTA CROSSING    | 3309              | 1998           |
| SOUTH POINTE       | 2834              | 2016           |
| LINDEN WOODS       | 2755              | 1992           |
| WHYTE RIDGE        | 2361              | 1994           |
| ISLAND LAKES       | 2256              | 1995           |
| SAGE CREEK         | 2253              | 2015           |
| CANTERBURY PARK    | 2242              | 1996           |
| AMBER TRAILS       | 2118              | 2009           |
| RICHMOND WEST      | 2089              | 1993           |

### <span style="color:tan">Query Highlights:</span>


### <span style="color:tan">Result Interpretations:</span>

</details>

### [Which neighbourhoods have the most houses that include property features I would like my house to have?](/project_queries/Analysis%20Queries/q5_desired_features.sql)
<details>
<summary>Click to expand/collapse</summary>

### <span style="color:tan">Query Used:</span>
```sql
-- Top 10 neighbourhoods with the most houses that fits all of my desired property attributes
SELECT
    "Neighbourhood Area",
    COUNT("Roll Number") as num_houses_all_features
FROM property_cleaned
WHERE
    "Basement" = 'YES'
    AND "Rooms" >= 4
    AND "Total Living Area" >= 800
    AND ("Attached Garage" = 'YES' OR "Detached Garage" = 'YES')
    AND "Year Built" >= 1980
    AND ("Total Assessed Value" >= 300000 AND "Total Assessed Value" <= 450000)
GROUP BY
    "Neighbourhood Area"
ORDER BY
    num_houses_all_features DESC
LIMIT 10;
```
### <span style="color:tan">Query Output:</span>
| Neighbourhood Area | num_houses_all_features |
|--------------------|-------------------------|
| RIVER PARK SOUTH   | 1715                    |
| DAKOTA CROSSING    | 1561                    |
| CANTERBURY PARK    | 1351                    |
| ISLAND LAKES       | 1207                    |
| RIVERBEND          | 1152                    |
| RICHMOND WEST      | 1152                    |
| PEGUIS             | 1066                    |
| MEADOWS            | 1025                    |
| WHYTE RIDGE        | 979                     |
| INKSTER GARDENS    | 950                     |

### <span style="color:tan">Query Highlights:</span>


### <span style="color:tan">Result Interpretations:</span>

</details><br>

### [Based on the findings in questions 1-5, what are the top 5 optimal neighbourhoods of the city for me to live in?](/project_queries/Analysis%20Queries/q6_optimal_neighbourhoods.sql)
<details>
<summary>Click to expand/collapse</summary>

### <span style="color:tan">Query Used:</span>
```sql
-- Count number of houses that have all my desired property features for each neighbourhood
WITH property_cte AS (
    SELECT
        "Neighbourhood Area",
        COUNT("Roll Number") AS num_houses
    FROM property_cleaned
    WHERE
        "Basement" = 'YES'
        AND ("Attached Garage" = 'YES' OR "Detached Garage" = 'YES')
        AND "Total Living Area" >= 1100
        AND "Rooms" >= 4
        AND "Year Built" >= 1980
    GROUP BY "Neighbourhood Area"
    ORDER BY num_houses DESC
),
-- Count total and violent crime reports for each neighbourhood
total_crime_cte AS (
    SELECT
        "Neighbourhoods",
        SUM("Count") AS total_crime,
        SUM(CASE WHEN "Crime Category" = 'VIOLENT CRIME' THEN "Count" ELSE 0 END) AS total_violent
    FROM crime_report_cleaned
    GROUP BY "Neighbourhoods"
),
-- Get the 50th (total crime) and 30th (violent crime) percentile values used for filtering out neighbourhoods based on percentile of crime that occurs
percentile_crime_cte AS (
    SELECT 
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_crime) fifty_percentile_total_crime,
        PERCENTILE_CONT(0.3) WITHIN GROUP (ORDER BY total_violent) AS thirty_percentile_violent_crime
    FROM total_crime_cte
)
-- Find our top 5 optimal neighbourhoods
SELECT
    "Neighbourhood Area",
    num_houses,
    total_crime,
    total_violent
FROM property_cte prp
LEFT JOIN total_crime_cte tcrm
    ON prp."Neighbourhood Area" = tcrm."Neighbourhoods"
WHERE total_crime < (SELECT fifty_percentile_total_crime FROM percentile_crime_cte)
    AND total_violent < (SELECT thirty_percentile_violent_crime FROM percentile_crime_cte)
ORDER BY num_houses DESC
LIMIT 5;
```
### <span style="color:tan">Query Output:</span>
| Neighbourhood Area | num_houses | total_crime | total_violent |
|--------------------|------------|-------------|---------------|
| ROYALWOOD          | 1413       | 56          | 6             |
| BRIDGWATER TRAILS  | 1170       | 69          | 8             |
| BRIDGWATER LAKES   | 1159       | 44          | 5             |
| FRAIPONT           | 834        | 41          | 6             |
| RIDGEWOOD SOUTH    | 654        | 32          | 1             |

### <span style="color:tan">Query Highlights:</span>


### <span style="color:tan">Result Interpretations:</span>

</details><br>

### [What types of crimes are most likely in my selected top 5 areas to live in?](/project_queries/Analysis%20Queries/q7_crime_types_optimal_neighbourhoods.sql)
<details>
<summary>Click to expand/collapse</summary>

### <span style="color:tan">Query Used:</span>
```sql
-- Common crime types in top 5 optimal neighbourhoods
SELECT "Offence", SUM("Count") AS crime_count
FROM crime_report_cleaned
WHERE "Neighbourhoods" IN ('ROYALWOOD', 'BRIDGWATER TRAILS', 'BRIDGWATER LAKES', 'FRAIPONT', 'RIDGEWOOD SOUTH')
GROUP BY "Offence"
ORDER BY crime_count DESC
LIMIT 10;
```
### <span style="color:tan">Query Output:</span>
| Offence                                              | crime_count |
|------------------------------------------------------|-------------|
| BREAKING & ENTERING                                  | 57          |
| FRAUD                                                | 48          |
| THEFT $5000 OR UNDER (FROM MV OR OTHER)              | 32          |
| MISCHIEF - PROPERTY DAMAGE                           | 25          |
| MOTOR VEHICLE THEFT                                  | 20          |
| THEFT $5000 OR UNDER                                 | 17          |
| ASSAULT-LEVEL 1                                      | 10          |
| UTTERING THREATS                                     | 7           |
| POSSESSION STOLEN GOODS >$5000                       | 3           |
| ASSAULT WITH WEAPON OR CAUSING BODILY HARM-LEVEL 2   | 2           |

### <span style="color:tan">Query Highlights:</span>


### <span style="color:tan">Result Interpretations:</span>

</details><br>

# What I learned


# Conclusion


# References
