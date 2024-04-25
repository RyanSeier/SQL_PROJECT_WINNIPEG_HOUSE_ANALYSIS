/*
Question:
Which neighbourhoods have the most new houses built on or after 1980?
*/

-- Top 10 neighbourhoods with the highest count of houses built after 1980
SELECT
    "Neighbourhood Area",
    COUNT(CASE WHEN "Year Built" >= 1980 THEN 1 END) AS num_newer_houses,
    ROUND(AVG("Year Built"),0) AS avg_year_built
FROM property_cleaned
GROUP BY "Neighbourhood Area"
ORDER BY num_newer_houses DESC
LIMIT 10;

/*
Query Result:

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

Nifty - seems South Pointe and Sage Creek are newer neighbourhoods in general given that their average built years are so high.
I bet it costs a lot to live in either neighbourhood!
*/

-- For fun, let's check what the average cost and crime rates are for these newer neighbourhoods
WITH property_cte AS (
    SELECT
        "Neighbourhood Area",
        COUNT(CASE WHEN "Year Built" >= 1980 THEN 1 END) AS num_newer_houses,
        ROUND(AVG("Year Built"),0) AS avg_year_built,
        ROUND(AVG("Total Assessed Value")) AS avg_home_value
    FROM property_cleaned
    GROUP BY "Neighbourhood Area"
),
crime_cte AS (
    SELECT "Neighbourhoods", SUM("Count") AS num_crimes
    FROM crime_report_cleaned
    GROUP BY "Neighbourhoods"
    )

SELECT
    "Neighbourhood Area",
    num_newer_houses,
    avg_home_value,
    num_crimes
FROM property_cte prp
LEFT JOIN crime_cte crm
    ON crm."Neighbourhoods" = prp."Neighbourhood Area"
ORDER BY num_newer_houses DESC
LIMIT 10;

/*
Query Results:

| Neighbourhood Area | num_newer_houses | avg_home_value | num_crimes |
|--------------------|-------------------|----------------|------------|
| RIVER PARK SOUTH   | 3425              | 393892         | 266        |
| DAKOTA CROSSING    | 3309              | 446535         | 241        |
| SOUTH POINTE       | 2834              | 469771         | 172        |
| LINDEN WOODS       | 2755              | 577736         | 317        |
| WHYTE RIDGE        | 2361              | 485148         | 118        |
| ISLAND LAKES       | 2256              | 445036         | 87         |
| SAGE CREEK         | 2253              | 541526         | 150        |
| CANTERBURY PARK    | 2242              | 345290         | 161        |
| AMBER TRAILS       | 2118              | 475327         | 124        |
| RICHMOND WEST      | 2089              | 476746         | 310        |

Moderate/low crime rates everywhere as well, with no neighbourhood going above 1 crime report per day on average throughout the year.
Dang, Sage Creek and South Pointe are out of my price range.
Island Lakes however is looking appealing at first glance.
*/