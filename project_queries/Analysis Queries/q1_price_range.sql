/*
Question:
Which neighbourhoods in Winnipeg have the most homes I can afford to live in?
*/
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

/*
Query output:

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
*/