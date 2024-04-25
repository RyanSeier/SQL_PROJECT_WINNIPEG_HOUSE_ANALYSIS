-- Create parcel assessment table with primary key "Roll Number"
DROP TABLE IF EXISTS public.property_raw;
CREATE TABLE public.property_raw
(
    "Roll Number" BIGINT PRIMARY KEY,
    "Street Number" INT,
    "Unit Number" TEXT,
    "Street Suffix" TEXT,
    "Street Direction" VARCHAR (255),
    "Street Name" TEXT,
    "Street Type" TEXT,
    "Full Address" TEXT,
    "Neighbourhood Area" TEXT,
    "Market Region" TEXT,
    "Total Living Area" INT,
    "Building Type" TEXT,
    "Basement" TEXT,
    "Basement Finish" TEXT,
    "Year Built" INT,
    "Rooms" INT,
    "Air Conditioning" TEXT,
    "Fire Place" TEXT,
    "Attached Garage" TEXT,
    "Detached Garage" TEXT,
    "Pool" TEXT,
    "Number Floors (Condo)" INT,
    "Property Use Code" TEXT,
    "Assessed Land Area" FLOAT,
    "Water Frontage Measurement" FLOAT,
    "Sewer Frontage Measurement" FLOAT,
    "Property Influences" TEXT,
    "Zoning" TEXT,
    "Total Assessed Value" FLOAT,
    "Total Proposed Assessment Value" FLOAT,
    "Assessment Date" TEXT,
    "Detail URL" TEXT,
    "Current Assessment Year" INT,
    "Property Class 1" TEXT,
    "Status 1" TEXT,
    "Assessed Value 1" FLOAT,
    "Property Class 2" TEXT,
    "Status 2" TEXT,
    "Assessed Value 2" FLOAT,
    "Property Class 3" TEXT,
    "Status 3" TEXT,
    "Assessed Value 3" FLOAT,
    "Property Class 4" TEXT,
    "Status 4" TEXT,
    "Assessed Value 4" FLOAT,
    "Property Class 5" TEXT,
    "Status 5" TEXT,
    "Assessed Value 5" FLOAT,
    "Proposed Assessment Year" INT,
    "Proposed Assessment Date" TEXT,
    "Proposed Property Class 1" TEXT,
    "Proposed Status 1" TEXT,
    "Proposed Assessment Value 1" FLOAT,
    "Proposed Property Class 2" TEXT,
    "Proposed Status 2" TEXT,
    "Proposed Assessment Value 2" FLOAT,
    "Proposed Property Class 3" TEXT,
    "Proposed Status 3" TEXT,
    "Proposed Assessment Value 3" FLOAT,
    "Proposed Property Class 4" TEXT,
    "Proposed Status 4" TEXT,
    "Proposed Assessment Value 4" FLOAT,
    "Proposed Property Class 5" TEXT,
    "Proposed Status 5" TEXT,
    "Proposed Assessment Value 5" FLOAT,
    "Multiple Residences" TEXT,
    "Geometry" TEXT,
    "Dwelling Units" INT
);

/* Create housing_permits table with no primary key yet
Why? Because none of the columns contain unique row values that can act as a primary key; but we also cannot make a composite key yet 
(check table_cleaning for details) */
DROP TABLE IF EXISTS public.housing_permit_raw;
CREATE TABLE public.housing_permit_raw
(
    "Year" INT,
    "Inspection Type" TEXT,
    "Ward" TEXT,
    "Permit Count" INT,
    "Inspection Count" INT,
    "Defect Count" INT,
    "Location" TEXT
--  PRIMARY KEY ("Year", "Ward")    If we could make a composite key immediately, this is how we'd do it for this table
);

/* Create neighbourhood_crime table with no primary key (yet)
Why? Because none of the columns contain unique row values that can act as a primary key; but we also cannot make a composite key yet
(check table_cleaning for details) */
DROP TABLE IF EXISTS public.crime_report_raw;
CREATE TABLE public.crime_report_raw
(
    "Offence Category" TEXT,
    "Offence" TEXT,
    "Count" INT,
    "Crime Category" TEXT,
    "Community" TEXT,
    "Neighbourhoods" TEXT,
    "Report Date" TEXT
);

-- Set ownership of the tables to the postgres user
ALTER TABLE public.property_raw OWNER to postgres;
ALTER TABLE public.housing_permit_raw OWNER to postgres;
ALTER TABLE public.crime_report_raw OWNER to postgres;

-- Create indexes on foreign key columns for better performance
DROP INDEX IF EXISTS roll_number_idx;
CREATE INDEX roll_number_idx ON public.property_raw ("Roll Number");