/*
Question:
Which neighbourhoods in Winnipeg have the least crime?
*/

-- Top 10 neighbourhoods with the least amount of crime
SELECT 
    "Neighbourhoods",
    SUM("Count") AS num_crimes
FROM crime_report_cleaned
GROUP BY "Neighbourhoods"
ORDER BY num_crimes ASC
LIMIT 10;

/*
Query Output:

| Neighbourhood           | Number of Crimes |
|-------------------------|------------------|
| PERRAULT                | 1                |
| THE MINT                | 4                |
| LA BARRIERE             | 5                |
| TURNBULL DRIVE          | 5                |
| TRAPPISTES              | 6                |
| CLOUTIER DRIVE          | 6                |
| MAPLE GROVE PARK        | 7                |
| NORTH TRANSCONA YARDS   | 8                |
| GRIFFIN                 | 9                |
| RIDGEDALE               | 9                |

That's great, but are there many residential houses in these neighbourhoods?  I'm not sure many houses are around The Mint, are there?
Not to mention "North Transcona Yards" sounds like an industrial district.
*/

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

/*
Query Output:

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

Much better!  These seem like nice neighbourhoods to live and walk around.
*/