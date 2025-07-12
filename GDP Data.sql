-- Automating Excel to SQL

-- Step 1: Create the table

IF OBJECT_ID('gdp_data_raw') IS NOT NULL DROP TABLE gdp_data_raw

CREATE TABLE gdp_data_raw (
    DEMO_IND NVARCHAR(200),
    Indicator NVARCHAR(200),
    [LOCATION] NVARCHAR(200),
    Country NVARCHAR(200),
    [TIME] NVARCHAR(200),
    [Value] FLOAT,
    [Flag Codes] NVARCHAR(200),
    Flags NVARCHAR(200)
)

-- Step 2: Import the data

BULK INSERT gdp_data_raw FROM 'C:\Users\chava\Downloads\gdp_data_raw.csv' WITH (FORMAT='CSV');
Select * FROM gdp_data_raw

-- Step 3: Create the view (to use only the data we need)
CREATE VIEW GDP_INPUT AS
SELECT a.*,b.GDP_PER_CAPITA FROM (SELECT Country,[Time] AS Year_No, [Value] AS GDP_Value FROM gdp_data_raw WHERE Indicator='GDP (current US$)') a
LEFT JOIN (SELECT Country,[Time] AS Year_No,[Value] AS GDP_Per_Capita FROM gdp_data_raw WHERE Indicator='GDP per capita (current US$)')b ON a.Country=b.Country AND a.Year_No=b.Year_No
-- DROP VIEW GDP_INPUT
Select * FROM GDP_INPUT

-- Step 4: Create a store procedure (to schedule our code to run per day/week/month/year)
Create PROCEDURE GDP_INPUT_Monthly AS 
IF OBJECT_ID('gdp_data_raw') IS NOT NULL DROP TABLE gdp_data_raw
CREATE TABLE gdp_data_raw (
    DEMO_IND NVARCHAR(200),
    Indicator NVARCHAR(200),
    [LOCATION] NVARCHAR(200),
    Country NVARCHAR(200),
    [TIME] NVARCHAR(200),
    [Value] FLOAT,
    [Flag Codes] NVARCHAR(200),
    Flags NVARCHAR(200)
)
-- Import the data
BULK INSERT gdp_data_raw FROM 'C:\Users\chava\Downloads\gdp_data_raw.csv' WITH (FORMAT='CSV');

EXEC GDP_INPUT_Monthly
