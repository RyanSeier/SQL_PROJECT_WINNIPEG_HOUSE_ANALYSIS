/*
Question:
Which neighbourhoods in Winnipeg have the most crime?
*/

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

/*
Query Output:

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

Wow, West Alexander gets roughly 6 criminal reports per day on average throughout the year.
That doesn't include criminal events that no one reports on either - scary!
I might want to avoid these places in the future.
*/