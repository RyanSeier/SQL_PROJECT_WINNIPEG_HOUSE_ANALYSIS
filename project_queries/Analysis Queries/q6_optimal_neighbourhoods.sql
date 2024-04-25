/*
Question:
What are the top 5 optimal areas of the city for me to live in?

Focus on houses with all of the below:
1. Houses with a basement, garage, 1100 sqft living area, and 4+ rooms
2. Within the price range of 300,000 - 450,000
3. Built more recently than 1980
4. Neighbourhood crime is lower than the city average
5. Violent crime in particular are in the 30th percentile or lower for the city
*/

-- Top 5 optimal neighbourhoods

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

/*
Query Output:

| Neighbourhood Area | num_houses | total_crime | total_violent |
|--------------------|------------|-------------|---------------|
| ROYALWOOD          | 1413       | 56          | 6             |
| BRIDGWATER TRAILS  | 1170       | 69          | 8             |
| BRIDGWATER LAKES   | 1159       | 44          | 5             |
| FRAIPONT           | 834        | 41          | 6             |
| RIDGEWOOD SOUTH    | 654        | 32          | 1             |

According to this query, the south end of the City best suits me.
Not bad, considering I like those areas - super cool!
*/