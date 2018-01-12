CREATE TABLE spreadsheet ( 
TABLE_NAME VARCHAR2 (30) NOT NULL,
	 TABLE_SHORT_NAME VARCHAR2 (8) NOT NULL,
	 COLUMN_POSITION NUMBER (4) NOT NULL,
	 COLUMN_NAME VARCHAR2 (30),
	 NULLABLE CHAR (1),
	 DATA_TYPE VARCHAR2 (20),
	 FIELD_LEN_STR VARCHAR2 (10),
	 COMMENTS VARCHAR2 (4000) 
); 

COMMENT ON TABLE spreadsheet IS 
'Import table for the data model';