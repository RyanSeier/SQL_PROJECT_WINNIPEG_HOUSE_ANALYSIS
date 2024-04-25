/*
Dataset Purpose:
Investigate crime rates for each neighbourhood to better determine which areas of the city I am and am not willing to move to.

SQL Script Purpose:
Staging and cleaning crime_report_raw dataset for analysis.

Special Notes:
In this dataset we're going to create a "Neighbourhood Number" column and fill it in with the neighbourhood numbers obtained from the neighbourhood.csv.
This isn't technically necessary, but property data has market region numbers and I thought it would be fitting for neighbourhood to have the same since I found them anyway.
Also it gives me a chance to show off some extra work!
*/

-- Look over dataset
SELECT *
FROM crime_report_raw
ORDER BY "Neighbourhoods" DESC
LIMIT 100;

/*
Notable dataset Issues:
- No primary key distinguishing individual crime report records
- No PK/FK set up to relate this table with property data
- Dataset is composed of individual crime reports, and does not group them by neighbourhood
- Report date is in Text format
- Same neighbourhoods have different upper and lower case characters
*/

-- Create staging table to preserve original table
DROP TABLE IF EXISTS crime_report_staging;

CREATE TABLE crime_report_staging AS
    TABLE crime_report_raw;

-- Add a primary key called report_id to track each individual crime record (we're assuming each record is a unique report since we cannot tell otherwise right now)
ALTER TABLE crime_report_staging
ADD COLUMN report_id SERIAL PRIMARY KEY;

-- Check for NULL values (none present)
SELECT *
FROM crime_report_staging
WHERE (crime_report_staging IS NULL);

-- Trim leading and trailing spaces
UPDATE crime_report_staging
SET
    "Offence Category" = TRIM("Offence Category"),
    "Offence" = TRIM("Offence"),
    "Crime Category" = TRIM("Crime Category"),
    "Community" = TRIM("Community"),
    "Neighbourhoods" = TRIM("Neighbourhoods"),
    "Report Date" = TRIM("Report Date")
    ;

-- Convert "Report Date" to a DATE format
ALTER TABLE crime_report_staging
ALTER COLUMN "Report Date" SET DATA TYPE DATE
    USING TO_DATE("Report Date", 'MM/DD/YYYY');

-- Standardize capitalization to be upper case for all values
UPDATE crime_report_staging
SET
    "Offence Category" = UPPER("Offence Category"),
    "Offence" = UPPER("Offence"),
    "Crime Category" = UPPER("Crime Category"),
    "Community" = UPPER("Community"),
    "Neighbourhoods" = UPPER("Neighbourhoods")
    ;

-- Add a new column assigning neighbourhood numbers to each neighbourhood
-- (This is extra work, as mentioned in notes at top of page)
ALTER TABLE crime_report_staging
ADD COLUMN "Neighbourhood Number" INT;

-- Create temp table to store our neighbourhood.csv numbers for transfer to crime_report_staging."Neighbourhood Number"
DROP TABLE IF EXISTS temp_neighbourhood;

CREATE TEMP TABLE temp_neighbourhood
(
    "the_geom" TEXT,
    "Name" TEXT,
    "ID" INT
);

COPY temp_neighbourhood
FROM 'C:\Users\Ryan Sigurdson\Desktop\Data Analyst Lessons & Projects\SQL Lessons - Luke\VS Code Dev\SQL_PROJECT_WINNIPEG_HOUSE_ANALYSIS\house_project_dataset\neighbourhood.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Standardize neighbourhood names by uppercasing all of them (same as we did for crime_reports_staging)
UPDATE temp_neighbourhood
SET
    "Name" = UPPER("Name");

-- Check to make sure temp table has all 236 Winnipeg neighbourhoods and their IDs (# of neighbourhoods obtained from City of Winnipeg website)
-- (at least one neighbourhood is missing)
SELECT "Name", "ID"
FROM temp_neighbourhood
ORDER BY "Name";

-- Check which neighbourhoods are missing from temp table, and whether or not we have crime reports for that neighbourhood
-- (Temp table is missing Heritage Park and Sturgeon Creek neighbourhoods, and has "West Perimeter South", which is just outside Winnipeg)
SELECT DISTINCT
    stg."Neighbourhoods",
    tmp."Name"
FROM temp_neighbourhood tmp
FULL OUTER JOIN crime_report_staging stg
    ON tmp."Name" = stg."Neighbourhoods";
-- WHERE "Neighbourhoods" IS NULL           (These 2 lines are optional, used for a more specific check on missing neighbourhoods)
--     OR "Name" IS NULL

-- Insert the 234 neighbourhood IDs we have from the temp table to the staging table
UPDATE crime_report_staging
SET "Neighbourhood Number" = "ID"
FROM temp_neighbourhood
WHERE crime_report_staging."Neighbourhoods" = temp_neighbourhood."Name";

-- Manually insert two placeholder IDs for Heritage Park and Sturgeon Creek since I cannot find their actual IDs on the City of Winnipeg website currently
UPDATE crime_report_staging
SET "Neighbourhood Number" = 99999
WHERE "Neighbourhoods" = 'HERITAGE PARK';

UPDATE crime_report_staging
SET "Neighbourhood Number" = 99998
WHERE "Neighbourhoods" = 'STURGEON CREEK';

-- Initial table cleaning done, store as table crime_report_cleaned
DROP TABLE IF EXISTS crime_report_cleaned;

CREATE TABLE crime_report_cleaned AS
    TABLE crime_report_staging;