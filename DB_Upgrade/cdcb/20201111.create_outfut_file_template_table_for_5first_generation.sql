INSERT INTO OUTPUT_FILE_TEMPLATE_TABLE
(
	NAME,
	TYPE,
	TEMPLATE_DETAIL,
	PREFIX_OUTPUT_NAME,
	CREATE_DATE
)
VALUES
('ANIM_FORMATTED_5FIRST_GENERATION',
'JSON',
'   {      
        "INPUT": "<INPUT>",
        "ROOT_ANIMAL_ID":"<ROOT_ANIMAL_ID>",
        "ANIMAL_ID":"<ANIMAL_ID>",
        "SIRE_INT_ID": "<SIRE_INT_ID>",
		"DAM_INT_ID": "<DAM_INT_ID>", 
		"SEX_CODE": "<SEX_CODE>",
		"GENERATION": "<GENERATION>",
		"BIRTH_DATE": "<BIRTH_DATE>",
		"LONG_NAME": "<LONG_NAME>",
		"GENOTYPED": "<GENOTYPED>",
		"SRC": "<SRC>",
		"IS_EXIST": "<IS_EXIST>"
     }',
'Animal_formatted_5first_generation',
CURRENT DATE 
)
;