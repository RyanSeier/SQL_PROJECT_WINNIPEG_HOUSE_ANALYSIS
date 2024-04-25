/* 
Dataset's Purpose:
We want to use the property_raw table to identify neighbourhoods with affordable housing (for my budget) that also have property features that I may be interested in (basement, garage, pool, etc.)

SQL Script Purpose:
Staging and cleaning property_raw dataset for analysis.
*/

-- Look over dataset
SELECT *
FROM property_raw
LIMIT 100;

/*
Notable dataset issues:
- A lot of columns, many of which we don't need for our neighbourhood-based analysis
- A lot of null values, which may or may not be a problem
- "Market Region" has both its region number and name in the same column
- "Property Use Code" values implies this dataset has both residential and commercial property assessments
- There are multiple copies of columns like "Assessed Value 1, 2, 3...", "Property Class 1, 2, 3..." and "Status 1, 2, 3...", most of which look empty at first glance
- There are multiple copies of columns like "Proposed Assessed Value 1, 2, 3...", "Proposed Property Class 1, 2, 3..." and "Proposed Status 1, 2, 3...", most of which look empty at first glance
- Our foreign key that relates this table to the crime table (Neighbourhood Area) has a different column name and does not have id numbers, like "Market Region" does
*/

-- Create staging table to preserve original table
DROP TABLE IF EXISTS property_staging;

CREATE TABLE property_staging AS
    TABLE property_raw;

-- Add a foreign key column to relate this table to others via neighbourhood, called "Neighbourhood Number"
ALTER TABLE property_staging
ADD COLUMN "Neighbourhood Number" INT;

-- Quick check to ensure neighbourhood values have the same spelling and formatting
SELECT DISTINCT "Neighbourhood Area"
FROM property_staging
ORDER BY "Neighbourhood Area";

-- Count number of columns (there's 68)
SELECT COUNT(*)
FROM information_schema.columns
WHERE table_name = 'property_staging';

-- Remove columns unnecessary for our analysis (reduced from 68 to 30)
ALTER TABLE property_staging
    DROP COLUMN "Street Number",
    DROP COLUMN "Unit Number",
    DROP COLUMN "Street Suffix",
    DROP COLUMN "Street Direction",
    DROP COLUMN "Street Name",
    DROP COLUMN "Street Type",
    DROP COLUMN "Full Address",
    DROP COLUMN "Assessment Date",
    DROP COLUMN "Detail URL",
    DROP COLUMN "Property Class 2",
    DROP COLUMN "Status 2",
    DROP COLUMN "Assessed Value 2",
    DROP COLUMN "Property Class 3",
    DROP COLUMN "Status 3",
    DROP COLUMN "Assessed Value 3",
    DROP COLUMN "Property Class 4",
    DROP COLUMN "Status 4",
    DROP COLUMN "Assessed Value 4",
    DROP COLUMN "Property Class 5",
    DROP COLUMN "Status 5",
    DROP COLUMN "Assessed Value 5",
    DROP COLUMN "Proposed Assessment Year",
    DROP COLUMN "Proposed Property Class 1",
    DROP COLUMN "Proposed Status 1",
    DROP COLUMN "Proposed Assessment Value 1",
    DROP COLUMN "Proposed Property Class 2",
    DROP COLUMN "Proposed Status 2",
    DROP COLUMN "Proposed Assessment Value 2",
    DROP COLUMN "Proposed Property Class 3",
    DROP COLUMN "Proposed Status 3",
    DROP COLUMN "Proposed Assessment Value 3",
    DROP COLUMN "Proposed Property Class 4",
    DROP COLUMN "Proposed Status 4",
    DROP COLUMN "Proposed Assessment Value 4",
    DROP COLUMN "Proposed Property Class 5",
    DROP COLUMN "Proposed Status 5",
    DROP COLUMN "Proposed Assessment Value 5",
    DROP COLUMN "Proposed Assessment Date",
    DROP COLUMN "Geometry";

-- Separate "Market Region" into "Market Region Number" and "Market Region"
ALTER TABLE
    property_staging
ADD COLUMN 
    "Market Region Number" TEXT;

UPDATE 
    property_staging
SET
    "Market Region Number" = SPLIT_PART("Market Region", ',', 1),
    "Market Region" = SPLIT_PART("Market Region", ',', 2);

/*
Filter out non-residential properties by excluding all records where 'RES' is not in "Property Use Code", "Property Class 1", "Zoning", and any industrial neighbourhoods
Reason being that I only want to look at primarily residential houses and areas, not ones that double as a farm, business, or next to factories
(Number of records reduced from 242,141 to 203,818)
*/

DELETE
FROM property_staging
WHERE "Property Use Code" NOT LIKE '%RES%' OR
    "Property Class 1" NOT LIKE '%RES%' OR
    "Zoning" NOT LIKE '%RES%' OR
    "Neighbourhood Area" LIKE '%INDUST%';

-- Standardize text columns by uppercasing and trimming them
UPDATE property_staging
SET
    "Neighbourhood Area" = UPPER(TRIM("Neighbourhood Area")),
    "Market Region" = UPPER(TRIM("Market Region")),
    "Building Type" = UPPER(TRIM("Building Type")),
    "Basement" = UPPER(TRIM("Basement")),
    "Basement Finish" = UPPER(TRIM("Basement Finish")),
    "Air Conditioning" = UPPER(TRIM("Air Conditioning")),
    "Fire Place" = UPPER(TRIM("Fire Place")),
    "Attached Garage" = UPPER(TRIM("Attached Garage")),
    "Detached Garage" = UPPER(TRIM("Detached Garage")),
    "Pool" = UPPER(TRIM("Pool")),
    "Property Use Code" = UPPER(TRIM("Property Use Code")),
    "Property Influences" = UPPER(TRIM("Property Influences")),
    "Zoning" = UPPER(TRIM("Zoning")),
    "Property Class 1" = UPPER(TRIM("Property Class 1")),
    "Status 1" = UPPER(TRIM("Status 1")),
    "Multiple Residences" = UPPER(TRIM("Multiple Residences")),
    "Market Region Number" = UPPER(TRIM("Market Region Number"));

-- Check for NULL values in key columns (text type columns we plan to group and/or relate to other tables with)
SELECT
    "Neighbourhood Area",
    "Market Region",
    "Total Assessed Value",
    "Property Use Code",
    "Property Class 1",
    "Zoning"
FROM property_staging
WHERE
    "Neighbourhood Area" IS NULL
    OR "Market Region" IS NULL
    OR "Total Assessed Value" IS NULL
    OR "Property Use Code" IS NULL
    OR "Property Class 1" IS NULL
    OR "Zoning" IS NULL;

-- There's only NULL values in "Zoning", but it seems to only be for condos, vacant houses, and apartments.  
-- I don't mind keeping these since they're still primarily residential buildings.

/*
The following is extra work to get neighbourhood numbers on this table for reference.
Neighbourhood names alone would suffice and be faster, but I get to try out different techniques this way.
Let's speed up this work by creating some quick indexes
*/
DROP INDEX IF EXISTS property_neigh_idx;
DROP INDEX IF EXISTS crime_neigh_idx;
DROP INDEX IF EXISTS crime_neigh_num_idx;
CREATE INDEX property_neigh_idx ON property_staging ("Neighbourhood Area");
CREATE INDEX crime_neigh_idx ON crime_report_cleaned ("Neighbourhoods");
CREATE INDEX crime_neigh_num_idx ON crime_report_cleaned ("Neighbourhood Number");

-- Make sure "Neighbourhood Area" spelling and format matches with crime_report_cleaned's "Neighbourhoods" column for joins (12 neighbourhoods not matching)
SELECT DISTINCT
    "Neighbourhood Area",
    "Neighbourhoods"
FROM property_staging prp
LEFT JOIN crime_report_cleaned crm
    ON prp."Neighbourhood Area" = crm."Neighbourhoods"
WHERE "Neighbourhood Area" IS NULL
    OR "Neighbourhoods" IS NULL
ORDER BY "Neighbourhood Area";

-- Up to 6 non-matches are due to a lacking period after "ST", so let's add it to them (9 non-matches remaining)
UPDATE property_staging
SET "Neighbourhood Area" = REPLACE("Neighbourhood Area", 'ST ', 'ST. ')
WHERE "Neighbourhood Area" LIKE 'ST %';

-- Manually adjusting the remaining column names with LIKE statements since I don't see a clear pattern in the discrepencies between the other 9 mismatches
UPDATE property_staging
SET "Neighbourhood Area" = "Neighbourhoods"
FROM crime_report_cleaned
WHERE "Neighbourhood Area" LIKE '%CENTRAL RIVER H%'
    AND "Neighbourhoods" LIKE '%CENTRAL RIVER H%';

UPDATE property_staging
SET "Neighbourhood Area" = "Neighbourhoods"
FROM crime_report_cleaned
WHERE "Neighbourhood Area" LIKE '%CENTRAL ST%'
    AND "Neighbourhoods" LIKE '%CENTRAL ST%';

UPDATE property_staging
SET "Neighbourhood Area" = "Neighbourhoods"
FROM crime_report_cleaned
WHERE "Neighbourhood Area" LIKE '%LEILA-MCPHILLIPS TRI%'
    AND "Neighbourhoods" LIKE '%LEILA-MCPHILLIPS TRI%';

UPDATE property_staging
SET "Neighbourhood Area" = "Neighbourhoods"
FROM crime_report_cleaned
WHERE "Neighbourhood Area" LIKE '%NORTH ST%'
    AND "Neighbourhoods" LIKE '%NORTH ST%';

UPDATE property_staging
SET "Neighbourhood Area" = "Neighbourhoods"
FROM crime_report_cleaned
WHERE "Neighbourhood Area" LIKE '%SOUTH POINTE%'
    AND "Neighbourhoods" LIKE '%SOUTH POINTE%';

UPDATE property_staging
SET "Neighbourhood Area" = "Neighbourhoods"
FROM crime_report_cleaned
WHERE "Neighbourhood Area" LIKE 'ST. JOHNS'
    AND "Neighbourhoods" LIKE 'ST. JOHN__';

UPDATE property_staging
SET "Neighbourhood Area" = "Neighbourhoods"
FROM crime_report_cleaned
WHERE "Neighbourhood Area" LIKE '%ST. JOHNS PARK%'
    AND "Neighbourhoods" LIKE '%ST. JOHN___%';

UPDATE property_staging
SET "Neighbourhood Area" = "Neighbourhoods"
FROM crime_report_cleaned
WHERE "Neighbourhood Area" LIKE '%ST. VITAL PERIMETER S%'
    AND "Neighbourhoods" LIKE '%ST. VITAL PERIMETER S%';

UPDATE property_staging
SET "Neighbourhood Area" = "Neighbourhoods"
FROM crime_report_cleaned
WHERE "Neighbourhood Area" LIKE '%WAVERLEY WEST-B%'
    AND "Neighbourhoods" LIKE '%WAVERLEY WEST%';

-- Let's give our neighbourhoods some numbers now, as assigned in the data_cleaning_crime_report.sql file
/*
UPDATE property_staging
SET "Neighbourhood Number" = crime_report_cleaned."Neighbourhood Number"
FROM crime_report_cleaned
WHERE "Neighbourhood Area" = "Neighbourhoods";
*/
-- Due to how slow the above query is to execute, and the fact that I did it for fun as bonus work, I'm commenting it out.  Uncomment to see it in action (takes ~1 minute)

-- Data looks good, we can move on.  Moving data from staging to cleaned
DROP TABLE IF EXISTS property_cleaned;

CREATE TABLE property_cleaned AS
    TABLE property_staging;