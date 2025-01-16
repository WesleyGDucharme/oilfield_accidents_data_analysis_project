--setting the datestyle to fit the format of the dates in the file to be read.
SET datestyle = 'ISO, MDY';

-- Transaction for building the tables for the database normalized to 3nf.
-- Fields that are Nullable are this way because there is alot of blank cells in the data being imported.
-- Null cell of course represent unknown details of the accident reports.
BEGIN TRANSACTION;

CREATE TABLE operators (
	operator_id SERIAL PRIMARY KEY NOT NULL,
	operator_name TEXT NOT NULL
);

CREATE TABLE liquids (
	liquid_id SERIAL PRIMARY KEY NOT NULL,
	liquid_type TEXT NOT NULL
);

CREATE TABLE causes (
	cause_id SERIAL PRIMARY KEY,
	primary_cause TEXT NOT NULL,
	secondary_cause TEXT NOT NULL
);


CREATE TABLE accident_report (
	report_number INT PRIMARY KEY NOT NULL,
	supplemental_number INT NOT NULL,
	accident_year INT NOT NULL,
	accident_date TIMESTAMP NOT NULL,
	pipeline_facility_name TEXT,
	pipeline_location TEXT NOT NULL,
	pipeline_type TEXT,
	accident_city TEXT,
	accident_county TEXT,
	accident_state TEXT,
	accident_latitude NUMERIC(15, 8) NOT NULL,
	accident_longitude NUMERIC(15, 8) NOT NULL,
	cause_id INT NOT NULL,
	FOREIGN KEY (cause_id) REFERENCES causes (cause_id),
	unintentional_barrels_released NUMERIC(15, 8) NOT NULL,
	intentional_barrels_released NUMERIC(15, 8),
	liquid_barrels_recovered NUMERIC(15, 8),
	net_barrels_lost NUMERIC(15, 8) NOT NULL,
	liquid_ignition TEXT NOT NULL,
	liquid_explosion TEXT NOT NULL,
	pipeline_shutdown TEXT,
	property_damage_costs INT,
	lost_commodity_cost INT,
	public_private_damage_costs INT,
	emergency_response_costs INT,
	environmental_remedation_costs INT, 
	other_costs INT,
	total_costs INT 
);

CREATE TABLE operators_onsite (
	operator_id INT NOT NULL,
	FOREIGN KEY (operator_id) REFERENCES operators (operator_id),
	report_number INT NOT NULL,
	FOREIGN KEY (report_number) REFERENCES accident_report (report_number),
	PRIMARY KEY (operator_id, report_number)
);

CREATE TABLE liquids_present (
	liquid_id INT NOT NULL,
	FOREIGN KEY (liquid_id) REFERENCES liquids (liquid_id),
	report_number INT NOT NULL,
	FOREIGN KEY (report_number) REFERENCES accident_report (report_number),
	PRIMARY KEY (liquid_id, report_number)
	
);

COMMIT;


-- Transaction for importing the data from the csv file into the database
BEGIN TRANSACTION;

-- Temporary table for importing the data
CREATE TEMPORARY TABLE temp_data_table_import (
	report_number INT,
	supplemental_number INT,
	accident_year INT,
	accident_date TIMESTAMP,
	operator_name TEXT,
	pipeline_facility_name TEXT,
	pipeline_location TEXT,
	pipeline_type TEXT,
	liquid_type TEXT,
	accident_city TEXT,
	accident_county TEXT,
	accident_state TEXT,
	accident_latitude NUMERIC(15, 8),
	accident_longitude NUMERIC(15, 8),
	primary_cause TEXT,
	secondary_cause TEXT,
	unintentional_barrels_released NUMERIC(15, 8),
	intentional_barrels_released NUMERIC(15, 8),
	liquid_barrels_recovered NUMERIC(15, 8),
	net_barrels_lost NUMERIC(15, 8),
	liquid_ignition TEXT,
	liquid_explosion TEXT,
	pipeline_shutdown TEXT,
	property_damage_costs INT,
	lost_commodity_cost INT,
	public_private_damage_costs INT,
	emergency_response_costs INT,
	environmental_remedation_costs INT, 
	other_costs INT,
	total_costs INT 
) ON COMMIT DROP;

-- Importing data from CSV to the temp table
COPY temp_data_table_import
FROM 'C:\Users\Public\oilfield_accident_project_data\oilfield_accidents_dataset.csv'
WITH (FORMAT CSV, HEADER TRUE, NULL '');-- Treating blank cells as NULL

INSERT INTO operators (
	operator_name
)
SELECT DISTINCT unnest(string_to_array(operator_name, ',')) AS operator_name -- For extracting mutiple values that may be in one cell
FROM temp_data_table_import
WHERE operator_name IS NOT NULL;


INSERT INTO liquids (
	liquid_type 
)
SELECT DISTINCT unnest(string_to_array(liquid_type, ',')) AS liquid_type -- For extracting mutiple values that may be in one cell
FROM temp_data_table_import
WHERE liquid_type IS NOT NULL;

INSERT INTO causes (
	primary_cause,
	secondary_cause
)
SELECT DISTINCT
	primary_cause,
	secondary_cause 
FROM temp_data_table_import;

INSERT INTO accident_report (
	report_number,
	supplemental_number,
	accident_year,
	accident_date,
	pipeline_facility_name,
	pipeline_location,
	pipeline_type,
	accident_city,
	accident_county,
	accident_state,
	accident_latitude,
	accident_longitude,
	cause_id,
	unintentional_barrels_released,
	intentional_barrels_released,
	liquid_barrels_recovered,
	net_barrels_lost,
	liquid_ignition,
	liquid_explosion,
	pipeline_shutdown,
	property_damage_costs,
	lost_commodity_cost,
	public_private_damage_costs,
	emergency_response_costs,
	environmental_remedation_costs, 
	other_costs,
	total_costs 
)
SELECT DISTINCT
	report_number,
	supplemental_number,
	accident_year,
	accident_date,
	pipeline_facility_name,
	pipeline_location,
	pipeline_type,
	accident_city,
	accident_county,
	accident_state,
	accident_latitude,
	accident_longitude,
	c.cause_id,
	unintentional_barrels_released,
	intentional_barrels_released,
	liquid_barrels_recovered,
	net_barrels_lost,
	liquid_ignition,
	liquid_explosion,
	pipeline_shutdown,
	property_damage_costs,
	lost_commodity_cost,
	public_private_damage_costs,
	emergency_response_costs,
	environmental_remedation_costs, 
	other_costs,
	total_costs
FROM temp_data_table_import AS t
JOIN causes AS c
ON t.primary_cause = c.primary_cause 
AND t.secondary_cause = c.secondary_cause;
	
INSERT INTO operators_onsite (
	operator_id, 
	report_number
)
SELECT DISTINCT 
	o.operator_id, 
	t.report_number
FROM temp_data_table_import AS t
JOIN operators  AS o
  ON o.operator_name = ANY (string_to_array(t.operator_name, ',')) -- Match o.operator_name with any value in the comma-separated list from t.operator_name. Allowing the correct paring of operator_ids and report_number.
WHERE t.operator_name IS NOT NULL;

INSERT INTO liquids_present (
	liquid_id, 
	report_number
)
SELECT DISTINCT 
	l.liquid_id, 
	t.report_number
FROM temp_data_table_import AS t
JOIN liquids AS l
  ON l.liquid_type = ANY (string_to_array(t.liquid_type, ',')) -- Match l.liquid_type with any value in the comma-separated list from t.liquid_type. Allowing the correct paring of liquid_ids and report_numbers.
WHERE t.liquid_type IS NOT NULL;

COMMIT;
