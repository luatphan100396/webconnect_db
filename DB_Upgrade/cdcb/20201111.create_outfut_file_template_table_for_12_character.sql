INSERT INTO OUTPUT_FILE_TEMPLATE_TABLE
(
	NAME,
	TYPE,
	TEMPLATE_DETAIL,
	PREFIX_OUTPUT_NAME,
	CREATE_DATE
)
VALUES
('ANIM_FORMATTED_12_CHARACTER',
'JSON',
'   {      
        "Input": "<INPUT>",
        "Key":"<ANIM_KEY>",
        "ID":"<ANIMAL_ID>",
        "Sex": "<SEX_CODE>",
        "Name": "<LONG_NAME>",
		"Source_Code": "<SRC>", 
		"PREFERRED_CODE": "<PREFERED_ID>",
		"Registry_Status": "<REG>",
		"Mod_Date": "<MODIFY_DATE>"
     }',
'Animal_formatted_12_character',
CURRENT DATE 
)
;