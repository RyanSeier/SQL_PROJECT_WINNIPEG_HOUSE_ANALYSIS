/*
Question:
What are the most common crime types in the top 5 optimal neighbourhoods my query is recommending to me?

As a reminder, q6 query output table is posted below:

| Neighbourhood Area | num_houses | total_crime | total_violent |
|--------------------|------------|-------------|---------------|
| ROYALWOOD          | 1413       | 56          | 6             |
| BRIDGWATER TRAILS  | 1170       | 69          | 8             |
| BRIDGWATER LAKES   | 1159       | 44          | 5             |
| FRAIPONT           | 834        | 41          | 6             |
| RIDGEWOOD SOUTH    | 654        | 32          | 1             |
*/

-- Common crime types in top 5 optimal neighbourhoods
SELECT "Offence", SUM("Count") AS crime_count
FROM crime_report_cleaned
WHERE "Neighbourhoods" IN ('ROYALWOOD', 'BRIDGWATER TRAILS', 'BRIDGWATER LAKES', 'FRAIPONT', 'RIDGEWOOD SOUTH', 'BETSWORTH', 'NORMAND PARK', 'ST. VITAL PERIMETER SOUTH', 'LINDEN RIDGE')
GROUP BY "Offence"
ORDER BY crime_count DESC
LIMIT 10;

/*
Query Results:

| Offence                                      | Crime Count |
|----------------------------------------------|-------------|
| BREAKING & ENTERING                          | 78          |
| MISCHIEF - PROPERTY DAMAGE                   | 71          |
| THEFT $5000 OR UNDER (FROM MV OR OTHER)      | 65          |
| FRAUD                                        | 65          |
| MOTOR VEHICLE THEFT                          | 37          |
| THEFT $5000 OR UNDER                         | 30          |
| ASSAULT-LEVEL 1                              | 18          |
| UTTERING THREATS                             | 7           |
| THEFT OVER $5000                             | 7           |
| BREACH OF RECOGNIZANCE                       | 5           |


Seems like individual assaults are extremely rare in these neighbourhoods, which is a relief for me - I like to feel safe walking around.
There has been a rise of B&E and car thefts across Canada, so it makes sense those would be high on this list given crimes in general are fairly low.
Overall, looks good!  Just might want to get property and car insurance, but I intended to anyway.
*/