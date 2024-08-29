# WORK IN PROGRESS

Context:
Must haves:
I am looking to buy a house in the coming years in the 300k - 450k price range
I want to live in an area that has the bottom 30% of crime rates in Winnipeg
I want to live in a relatively newer house, built after 1960

Desired property features:
- Price between 300,000 - 450,000
- Basement
- Living area over 1,100 sqft
- Garage
- 2+ bedrooms
- 2+ bathrooms
- Low crime rate neighbourhood (relative to City of Winnipeg average)


Questions:
1. What areas of the city suit my price range?
2. Which areas of the city have the most crime?
3. Which areas of the city have the least crime?
4. Which areas have newer properties built after 1980?
5. Which areas have the most houses that include property features I would like my house to have?
6. What are the top 5 optimal areas of the city for me to live in?
7. What types of crimes are most likely in my selected top 5 areas to live in?


# Introduction

The primary purpose of this project is to exercise my SQL skills and demonstrates them in a public way as part of my personal portfolio detailing work I've done.  The secondary purpose of this project is to investigate neighbourhoods and houses in the City of Winnipeg, with the goal of determining which neighbourhoods would best suite my living needs based on the criteria I provide with my ideal house.  The most important factors under consideration are housing costs, the age of the house, desirable property features, and crime rates.  These criteria will be sifted through using data provided by the City of Winnipeg (referenced later) stored on a local PostgreSQL database, with querying code available for review in this repository here on GitHub.


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

# Data Analysis


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
1. Top 3 neighbourhoods with the most properties that fit my price range are Windsor Park, Tyndall Park, and The Maples.
2. The top ranking neighbourhood for affordability has nearly double the number of properties than the 10th ranking neighbourhood
3. The 10th ranking neighbourhood still has a decent number of properties fitting my price range
4. While not immediately noticable to those unfamiliar with Winnipeg, quite a few of the top ranking houses are in areas known for higher crime rates
5. While not immediately noticable to those unfamiliar with Winnipeg, many of the top ranking neighbourhoods are in the north end of the city

### <span style="color:tan">Result Interpretation:</span>
The largest number of homes that fit my price range seem to be in the north end, with a couple of neighbourhoods (Windsor Park, Tyndall Park) that I know have higher than average city crime rates.  That said, there's still many properties in the other neighbourhoods, with well over 1000 in Garden City, ranked 10th, which is quite a nice area in my personal experience.  So even though the neighbourhoods with the largest numbers of properties in my price range are in high crime rate areas, when we start applying additional filters to address my other criteria we may be able to get new insights into neighbourhoods were interested in, along with different recommendations.

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
1. None of the top 10 properties in our ideal price range have appeared in the lowest 10 crime rate neighbourhood list
2. All of the low crime rate neighbourhoods have a low number of total residential houses located within them
3. The neighbourhood in this low crime rate list with the most houses, Royalwood, still has lower property numbers than our 10th highest neighbourhood in our price range

### <span style="color:tan">Result Interpretation:</span>
Most of the residential property count in each neighbourhood is relatively low, to the point that each neighbourhood's total number of houses is less than the filtered number of houses in each property we found for our ideal price range.  This makes sense, as one would imagine that crime rates in an area are proportionate to the population within that same area.  This is actually why we included a filter criteria where we only obtained results for neighbourhoods that contained at least 500 residential units, which was an arbitrarily determined number for now.  

In future iterations, we may want to instead explore crime states based on the number of properties present within an area as opposed to total crime within a neighbourhood.  This would allow our results to include population levels and not be immediately skewed towards neighbourhoods with low housing levels, thereby producing less biased results.  This could be achieved quite easily with a division-based formula in the WHERE section of our SQL code, such as (num_crimes / num_houses), to get a ratio of the number of crimes that occur per number of properties in each neighbourhood.

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
1. The highest ranking numberhood for crime (West Alexander) has nearly 3 crimes committed per residential property.
2. Unlike the previous query regarding neighourhoods with the lowest crime rates, crime numbers aren't as strictly tied to population
3. Spence, despite having the lowest number of total residential properties in any neighbourhood we've seen in any query output so far, is ranked 4th for highest crime - also nearly triple the number of crimes per property.
4. Aside from Rossmere-A, none of the neighbourhoods in this highest crime ranking list appeared in our number of houses within $300,000 - $450,000 price range list

### <span style="color:tan">Result Interpretation:</span>
The results were a bit surprising here in that, given the previous query around low crime neighbourhoods, I expected crime to go up proportionally with the number of residential homes in a neighbourhood.  While this generally still seems true given most of these high crime neighbourhoods have over 1000 properties, whereas few had over 1000 properties in the low crime ranking list, there are some clear outliers.  West Alexander and Spence in particular have some of the lowest residential property counts in their neighbourhood, but are also extraodinarily high in crime.  While it's hard to determine at a glance exactly why that is right now, it is a good indicator that neither West Alexander nor Spence areas I am interested in living in given the conditions.  Additionally, not many neighbourhoods within my price range made it into the high crime list, giving me increased confidence that the areas that match my affordability may match my ideal house attributes.

I still think that a better approach to crime rates would be a focus on crime per property in a given neighbourhood, which should be done in a future iteration.

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
1. Although our filter criteria was for top 10 neighbourhoods with houses built in 1980 or after, all of the neighbourhoods listed have an average year built of 1990 or later
2. All of the neighbourhoods with newer properties built after 1980 have a lot of properties relative to our previous queries total property counts.
3. Two neighbourhoods appear in this list that also appeared in our ideal price range (River Park South and Richmond West)
4. While not readily apparent at this time, I'm personally familiar with some property prices in Linden Woods, White Ridge, Island Lakes, and Sage Creek - all of which are pricier houses.

### <span style="color:tan">Result Interpretations:</span>
Quite a lot of houses have been built after 1980, relative to the number of total houses we've seen in previous queries when investigating other criteria.  Quite of a few of these newer areas are associated with higher priced properties and neighbourhoods that I am personally familiar with, such as Linden Woods, Whyte Ridge, Island Lakes, and Sage Creek.  Thankfully #1 on this list is River Park South, and #10 is Richmond West - both of which are neighbourhoods that contain a large number of properties that fall within our price range, as seen by query #1 above.  Neither Richmond West nor River Park South were on either crime query, which can be positive as it falls in neither the top 10 or bottom 10 extremes for crime rates and implies a more moderate amount.  As a result Richamond West and River Park South, so far, look like the most appealing neighbourhoods for me to research when looking for houses at this time.  But we should verify this by exercising a query that tests for all of our desired property attributes.

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
1. There are quite a few thousand houses in Winnipeg that have my ideal house features
2. River Park South contains the most residential properties that fulfill our desired criteria in owning a house
3. Both River Park South and Richmond West were neighbourhoods that appear both here and positively in other queries.
4. Island Lakes, Whyte Ridge, Canterbury Park and Dakota Crossing were also in our list of neighbourhoods that contained the most newer homes.
5. I had previous believed Island Lakes and Whyte Ridge to be outside my price range from personal experience, but we filtered for price and they're in the top 10 neighbourhoods, so there should be some property options in my price range there

### <span style="color:tan">Result Interpretations:</span>
As expected, River Park South and Richmond West continue to appear positively in our queries and give strong implications that they'll be top ringer neighbourhoods I should check out on first when looking for a home.  The only thing that potentially bothers me is that we got information on neither of these neighbourhoods when looking into crime rates.  Even if crimes are moderate, I still worry if they're on the higher end or lower end of that moderate spectrum relative to other neighbourhood crime rates - which could affect my purchasing decisions.  I also thought quite highly of Island Lakes and Whyte Ridge, thinking they were outside my price originally, but we filtered for that and they do have quite a few residential houses that fit my ideal property.

Also worth mentioning is that we have about 1,000-2,000 properties per neighbourhood in our ranking list for this query, which seems nice; but we don't actually know the total properties in each neighbourhood for comparison.  We have also yet to look into how many properties are in Winnipeg as a whole to get a better gauge of what % of Winnipeg houses actually meet my criteria.  That said, I don't think it's overly important to investigate that right now since our main questions were which neighbourhoods best contain my desired feature list in a house.  Knowing what percentage of city or neighbourhood properties meet my criteria would only be useful in gauging how realistic my expecations for a property are and give some insight into how likely I am to find a house if I go by those criteria I selected.  That could be interesting, but that is not a focus right now in this project.

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
| Neighbourhood Area                      | num_houses | total_crime | total_violent |
|----------------------------------------|------------|-------------|---------------|
| ROYALWOOD                              | 1413       | 56          | 6             |
| BRIDGWATER TRAILS                      | 1170       | 69          | 8             |
| BRIDGWATER LAKES                       | 1159       | 44          | 5             |
| FRAIPONT                               | 834        | 41          | 6             |
| RIDGEWOOD SOUTH                        | 654        | 32          | 1             |
| BETSWORTH                              | 455        | 78          | 8             |
| NORMAND PARK                           | 394        | 38          | 4             |
| ST. VITAL PERIMETER SOUTH              | 375        | 44          | 5             |
| SOUTHLAND PARK                         | 344        | 19          | 4             |
| LINDEN RIDGE                           | 314        | 29          | 0             |

### <span style="color:tan">Query Highlights:</span>
1. Neither River Park South nore Richmond West are in my top 10 optimal neighbourhood list
2. Quite a few of the neighbourhoods here are from our query to find neighbourhoods with lowest crime
2. Most of these neighbourhoods have less than 1,000 properties associated with them
3. Crime rates are extremely low for each neighbourhood

### <span style="color:tan">Result Interpretations:</span>
Given that River Park South and Richmond West were always popping up in previous queries to fit our desired attributes, it is a bit shocking we don't see them here.  But then again, the same issue we had in an earlier query to find neighbourhoods with lowest rates is also appearing since smaller neighbourhoods generally seems to have less crime.  Because of this bias, I will most likely be revisiting this and the crime-related queries to rank neighbourhoods based on the proportion of number of crimes per property, as opposed to per neighbourhood.  This will let us better gauge relative crime rates and give a better comparison between neighbourhoods crime rates depending on their size.

</details><br>

### [What types of crimes are most likely in my selected top 5 areas to live in?](/project_queries/Analysis%20Queries/q7_crime_types_optimal_neighbourhoods.sql)
<details>
<summary>Click to expand/collapse</summary>

### <span style="color:tan">Query Used:</span>
```sql
-- Common crime types in top 10 optimal neighbourhoods
SELECT "Offence", SUM("Count") AS crime_count
FROM crime_report_cleaned
WHERE "Neighbourhoods" IN ('ROYALWOOD', 'BRIDGWATER TRAILS', 'BRIDGWATER LAKES', 'FRAIPONT', 'RIDGEWOOD SOUTH', 'BETSWORTH', 'NORMAND PARK', 'ST. VITAL PERIMETER SOUTH', 'LINDEN RIDGE')
GROUP BY "Offence"
ORDER BY crime_count DESC
LIMIT 10;
```
### <span style="color:tan">Query Output:</span>
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

### <span style="color:tan">Query Highlights:</span>
1. The top 2 crimes that occur in our 10 ideal neighbourhoods involve property-related offenses (breaking & entering, property damage)
2. There are two instances of "THEFT $5000 OR UNDER", with one related to "MV or other"
3. There is a relatively insignificant level of drug offenses or violent offenses in these neighbourhoods collectively

### <span style="color:tan">Result Interpretations:</span>
A quick Google search reveals that MV refers to Motor Vehicles, so theft related to "FROM MV OR OTHER" seems to relate to motor vehicles and other forms of theft.  Because the category of theft under $5,000 relating to MVs also includes the vague notion of other crimes, I'm unsure what the difference is.  Perhaps these are two like columns in this dataset that should be merged, but further investigation would be needed.  Aside from that, it seems the majority of crimes in these neighbourhoods relate to property thefts and motor vehicle thefts.  While these are annual crime rates across 10 neighbourhoods meaning these instances of crime are unlikely, I still believe this is a decent indicator that home protection services, such as an alarm system and garage (which we wanted anyway) would be prudent to further reduce risks of the offenses happening.

</details><br>

# Personal Project Takeaways & Recommendations for Improvement
While going through this project I generated a list of ideal neighbourhoods that can help guide my home purchasing decisions in the future.  If nothing else, the neighbourhoods generated can act as a starting point to help me find some initial properties that meet my criteria and potentially draw my interest.  In particular, I'm very interested in learning more about the neighbourhoods Richmond West and River Park South, along with the 10 neighbourhoods listed in the optimal neighbourhood ranking list that considered all of the criteria posted.  The reason I'm considering Richmond West and River Park South, despite not being on my optimal top 10 neighbourhood list, is because those two neighbourhoods specifically appeared in each other query I ran, in a positive light relative to my expectations.  Pairing that with the fact that I believe the crime-related stats are skewed because I searched for the raw number of crimes committed in a neighbourhood, as opposed to relative crime relates to property numbers in a neighbourhood, which has me less confident that the optimal neighbourhoods given are accurate, since we ranked them based on number of properties which may have been artificially reduced thanks to the crime filters.

As for what I would improve on this project in the future, I would re-do the crime related rankings we queries as I believe they are biased due our decision to search up raw numbers instead of relative numbers as mentioned above.  A part of me is tempted to correct this error now, since it is just a simple change to the WHERE statement, but I will refrain from now for two reasons: 1. I believe reflecting on ones work and demonstrating the ability to accept ones flaws is also important in a project, which this clearly demonstrates and 2. I do want to start focusing on projects related to other tools like Power BI and Python.  So, at least for now, I will leave the flaws in how I determined neighbourhood crime numbers, and potentially revisit it later.  I will also leave a note to myself to potentially investigate how many properties exist that meet my desired standards relative to all properties in a neighbourhood or even the entire City of Winnipeg.  Doing so would allow me to better understand how realistic my standards are, and tweaking those standards (like reducing number of rooms in a house) could open avenues to safer neighbourhoods and less expensive options, which could also be appealing.

# Conclusion
WORK IN PROGRESS - As of August 28, 2024

# References
1. [City of Winnipeg Property Data (AKA Parcel Assessment Dataset)](https://data.winnipeg.ca/Assessment-Taxation-Corporate/Assessment-Parcels/d4mq-wa44/data_preview)
2. [Winnipeg Police Service Crime Map](https://public.tableau.com/app/profile/winnipeg.police.service/viz/CrimeMaps_16527244424350/Disclaimer)