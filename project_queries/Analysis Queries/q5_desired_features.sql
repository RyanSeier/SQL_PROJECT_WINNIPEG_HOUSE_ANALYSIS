/*
Question:
Which neighbourhoods have the most houses with the features I desire?

2 Parts:
1. Do a general search for neighbourhoods with the most of my desired features
2. Which neighbourhoods have the most houses that meet all of my feature criteria?  Include my price range (300-450k) and desired house age (1980+)

Desired property feature list:
1. Basement
2. Living area over 1,100 sqft
3. Garage
4. 4+ Rooms
*/

-- Part 1: Top 10 neighbourhoods with the most desired features
WITH feature_cte AS (
    SELECT 
        "Neighbourhood Area",
        "Basement",
        "Total Living Area",
        (CASE WHEN "Attached Garage" = 'YES' THEN 'YES' WHEN "Detached Garage" = 'YES' THEN 'YES' ELSE 'NO' END) AS any_garage,
        "Rooms"
    FROM property_cleaned
),

feature_count_cte AS (
    SELECT
        "Neighbourhood Area",
        COUNT(CASE WHEN "Basement" = 'YES' THEN 1 END) AS num_basements,
        COUNT(CASE WHEN "Total Living Area" >= 1100 THEN 1 END) AS num_ideal_sqft,
        COUNT(CASE WHEN "any_garage" = 'YES' THEN 1 END) AS num_garages,
        COUNT(CASE WHEN "Rooms" >= 4 THEN 1 END) AS num_ideal_rooms
    FROM feature_cte
    GROUP BY
        "Neighbourhood Area"
)

SELECT
    "Neighbourhood Area",
    (num_basements + num_ideal_sqft + num_garages + num_ideal_rooms) AS neighbourhood_score
--    ,num_basements,
--    num_garages,
--    num_ideal_rooms,
--    num_ideal_sqft
FROM feature_count_cte
ORDER BY neighbourhood_score DESC
LIMIT 10;

/*
Query Result:

| Neighbourhood Area | neighbourhood_score |
|--------------------|---------------------|
| RIVER PARK SOUTH   | 13169               |
| DAKOTA CROSSING    | 11849               |
| LINDEN WOODS       | 10636               |
| TYNDALL PARK       | 10583               |
| SOUTH POINTE       | 10458               |
| ROSSMERE-A         | 10376               |
| WINDSOR PARK       | 10002               |
| THE MAPLES         | 9968                |
| RIVER EAST         | 9870                |
| CANTERBURY PARK    | 9544                |
*/

-- Part 2: Which neighbourhoods have the most houses that meet all of my feature criteria?
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

/*
Query Result:

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

Cool, River Park South and Dakota Crossing seem to be great places to look for my ideal.
*/