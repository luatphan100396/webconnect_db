INSERT INTO OUTPUT_FILE_TEMPLATE_TABLE
(
	NAME,
	TYPE,
	TEMPLATE_DETAIL,
	PREFIX_OUTPUT_NAME,
	CREATE_DATE
)
VALUES
('ANIM_FORMATTED_ID_EVALUATION_12_CHARACTER',
'JSON',
'   {      
        "Input": "<INPUT>",
        "Key":"<ANIM_KEY>",
        "ID":"<ANIMAL_ID>",
        "Sex": "<SEX_CODE>",
		"Source_Code": "<SRC>", 
		"Pref": "<PREFERED_ID>",
		"Reg": "<REG>",
		"Mod_Date": "<MODIFY_DATE>",
		"Name": "<LONG_NAME>"
     }',
'Animal_formatted_id_evaluation_12_character',
CURRENT DATE 
)
;