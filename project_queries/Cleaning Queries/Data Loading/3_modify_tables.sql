-- Copy csv data into appropriate table
COPY property_raw
FROM 'C:\Users\Ryan Sigurdson\Desktop\Data Analyst Lessons & Projects\SQL Lessons - Luke\VS Code Dev\SQL_PROJECT_WINNIPEG_HOUSE_ANALYSIS\house_project_dataset\property_data.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY housing_permit_raw
FROM 'C:\Users\Ryan Sigurdson\Desktop\Data Analyst Lessons & Projects\SQL Lessons - Luke\VS Code Dev\SQL_PROJECT_WINNIPEG_HOUSE_ANALYSIS\house_project_dataset\housing_permit_data.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY crime_report_raw
FROM 'C:\Users\Ryan Sigurdson\Desktop\Data Analyst Lessons & Projects\SQL Lessons - Luke\VS Code Dev\SQL_PROJECT_WINNIPEG_HOUSE_ANALYSIS\house_project_dataset\crime_report_data.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');