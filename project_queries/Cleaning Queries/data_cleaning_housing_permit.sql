-- IMPORTANT NOTE:
-- This dataset only has 20 out of 236 neighbourhoods in Winnipeg, so it's not that useful.
-- As such, I won't be using this dataset, but I'm keeping the work I did to showcase it.

/* 
Dataset's Purpose:
We want to use housing permit data to get an idea of the number of new houses being built in each neighbourhood.

SQL Script Purpose:
Staging and cleaning housing_permit_raw dataset for analysis.
*/

-- Look over dataset
SELECT *
FROM housing_permit_raw;

/*
Notable issues:
- No primary key
- Dataset includes permits for plumbing and electrical jobs, not just constructing houses
- "Location" column has geo location data that is bulky and unnecessary for our use
- There's only some data for 20 neighbourhoods out of the 236 neighbourhoods in Winnipeg
*/

-- Create staging table to preserve original table
DROP TABLE IF EXISTS housing_permit_staging;

CREATE TABLE housing_permit_staging AS
    TABLE housing_permit_raw;

-- Delete all records whose "Inspection Type" is not 'Residential Building' to focus on building permits
Delete
FROM housing_permit_staging
WHERE "Inspection Type" NOT LIKE '%Building%';

-- Drop "Location" column (large size, and unnecessary for our analysis)
ALTER TABLE housing_permit_staging
DROP COLUMN "Location";

-- We'll use "Year" and "Ward" as a composite key, to show how many permits there were for each neighbourhood per year
-- Let's ensure there's no duplicates for our composite key prior to creating it
SELECT 
    "Year",
    "Ward",
    COUNT("Ward") AS num_appearances
FROM
    housing_permit_staging
GROUP BY
    "Year",
    "Ward"
HAVING
    COUNT("Ward") > 1;

/*
NOTE: Unfortunately 11 neighbourhoods are mentioned twice for the year 2018, so we cannot make "Year" and "Ward" our combined pkey yet.
Let's investigate the duplicates, and see how/if we can get rid of them
*/
SELECT *
FROM housing_permit_staging stg
LEFT JOIN (
        SELECT 
            "Year",
            "Ward",
            COUNT("Ward") AS num_appearances
        FROM
            housing_permit_staging
        GROUP BY
            "Year",
            "Ward"
        HAVING
            COUNT("Ward") > 1) AS dup
    ON stg."Year" = dup."Year" and
    stg."Ward" = dup."Ward"
WHERE 
    dup.num_appearances > 1
ORDER BY stg."Ward" DESC;

/*
NOTE: Looks like each duplicate was unintentional, and holds different permit/inspection/defect counts that (probably) should have been added to the total instead of inserted as a new record.
Let's rectify this by adding those counts together and deleting the duplicate "Year" and "Ward" rows.

Please note that we are assuming these duplicate counts should be added together for the project, but in reality we would have to contact the city to know for sure
*/

-- Combine appropriate count columns by ward and year for the 2018 period
SELECT 
    "Year",
    "Ward",
    SUM("Permit Count") AS "Permit Count",
    SUM("Inspection Count") AS "Inspection Count",
    SUM("Defect Count") AS "Defect Count"
FROM
    housing_permit_staging
WHERE
    "Year" = 2018
GROUP BY
    "Year",
    "Ward"
ORDER BY
    "Ward" DESC;

-- Since all of our duplicates are for the 2018 year, let's just remove all 2018 data and replace with our duplicate-free version
DELETE FROM housing_permit_staging
WHERE "Year" = 2018;

INSERT INTO housing_permit_staging
SELECT 
    "Year",
    "Inspection Type",
    "Ward",
    SUM("Permit Count") AS "Permit Count",
    SUM("Inspection Count") AS "Inspection Count",
    SUM("Defect Count") AS "Defect Count"
FROM
    housing_permit_raw -- Note: We insert from original dataset since we just deleted 2018 data from staging table
WHERE
    "Year" = 2018 AND
    "Inspection Type" = 'Residential Building'
GROUP BY
    "Year",
    "Inspection Type",
    "Ward";

-- Set combined primary key
ALTER TABLE housing_permit_staging
ADD PRIMARY KEY ("Year", "Ward");

-- Trim text data to remove potential trailing/leading spaces
UPDATE housing_permit_staging
SET
    "Inspection Type" = TRIM("Inspection Type"),
    "Ward" = TRIM("Ward");

-- Standardize text data to be upper case, since property and crime reports are as well
UPDATE housing_permit_staging
SET
    "Inspection Type" = UPPER("Inspection Type"),
    "Ward" = UPPER("Ward");

-- Looks like our data is good to go!  Moved from staging table to cleaned table
DROP TABLE IF EXISTS housing_permit_cleaned;

CREATE TABLE housing_permit_cleaned AS
    TABLE housing_permit_staging;