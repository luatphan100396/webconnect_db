
INSERT INTO OUTPUT_FILE_TEMPLATE_TABLE
(
	NAME,
	TYPE,
	TEMPLATE_DETAIL,
	PREFIX_OUTPUT_NAME,
	CREATE_DATE
)
VALUES
('ANIM_PARENTAGE_VERIF_RECORD',
'JSON',
'   {      
        "ANIMAL_ID": "<ANIMAL_ID>",
		"ANIMAL_SOURCE_CODE": "<ANIMAL_SOURCE_CODE>",
		"SAMPLE_ID": "<SAMPLE_ID>",
		"REQUESTER_ID": "<REQUESTER_ID>",
		"CHIP_TYPE": "<CHIP_TYPE>",
		"SIRE_ID": "<SIRE_ID>",
		"SIRE_SOURCE_CODE": "<SIRE_SOURCE_CODE>",
		"SIRE_STATUS_CODE": "<SIRE_STATUS_CODE>",
		"SUGGESTED_SIRE": "<SUGGESTED_SIRE>",
		"DAM_ID": "<DAM_ID>",
		"DAM_SOURCE_CODE": "<DAM_SOURCE_CODE>",
		"DAM_STATUS_CODE": "<DAM_STATUS_CODE>",
		"SUGGESTED_DAM": "<SUGGESTED_DAM>",
		"MGS_ID": "<MGS_ID>",
		"MGS_STATUS_CODE": "<MGS_STATUS_CODE>",
		"MGS_SUGG_1": "<MGS_SUGG_1>",
		"MGS_STAT_1: "<MGS_STAT_1>",
		"MGS_SUGG_2": "<MGS_SUGG_2>",
		"MGS_STAT_2": "<MGS_STAT_2>",
		"MGS_SUGG_3": "<MGS_SUGG_3>",
		"MGS_STAT_3": "<MGS_STAT_3>",
		"MGS_SUGG_4": "<MGS_SUGG_4>",
		"MGS_STAT_4": "<MGS_STAT_4>",
		"USABILITY_INDICATOR": "<USABILITY_INDICATOR>",
		"PARENTAGE_INDICATOR": "<PARENTAGE_INDICATOR>",
		"FEE_CODE": "<FEE_CODE>",
		"DATE": "<DATE>",
		"GETS_EVAL": "<GETS_EVAL>"
   }',
'Parentage_Ver_Records',
CURRENT DATE 
)
;

INSERT INTO OUTPUT_FILE_TEMPLATE_TABLE
(
	NAME,
	TYPE,
	TEMPLATE_DETAIL,
	PREFIX_OUTPUT_NAME,
	CREATE_DATE
)
values
('ANIM_PARENTAGE_VERIF_RECORD_CSV',
'CSV',
'<?xml version="1.0" encoding="utf-8"?>
<Template>
	<Item>
		<Field>ANIMAL_ID</Field>
		<Header>ANIMAL</Header>
	</Item>
	<Item>
		<Field>ANIMAL_SOURCE_CODE</Field>
		<Header>ANIMAL SOURCE CODE</Header>
	</Item> 
	<Item>
		<Field>SAMPLE_ID</Field>
		<Header>SAMPLE ID</Header>
	</Item> 
	<Item>
		<Field>REQUESTER_ID</Field>
		<Header>REQUESTER</Header>
	</Item> 
	<Item>
		<Field>CHIP_TYPE</Field>
		<Header>CHIP</Header>
	</Item> 
	<Item>
		<Field>SIRE_ID</Field>
		<Header>SIRE</Header>
	</Item> 
	<Item>
		<Field>SIRE_SOURCE_CODE</Field>
		<Header>SIRE SOURCE CODE</Header>
	</Item> 
	<Item>
		<Field>SIRE_STATUS_CODE</Field>
		<Header>SIRE STATUS CODE</Header>
	</Item> 
	<Item>
		<Field>SUGGESTED_SIRE</Field>
		<Header>SUGGESTED SIRE</Header>
	</Item> 
	<Item>
		<Field>DAM_ID</Field>
		<Header>DAM ID</Header>
	</Item> 
	<Item>
		<Field>DAM_SOURCE_CODE</Field>
		<Header>DAM SOURCE CODE</Header>
	</Item> 
	<Item>
		<Field>DAM_STATUS_CODE</Field>
		<Header>DAM STATUS CODE</Header>
	</Item> 
	<Item>
		<Field>SUGGESTED_DAM</Field>
		<Header>SUGGESTED DAM</Header>
	</Item> 
	<Item>
		<Field>MGS_ID</Field>
		<Header>MGS ID</Header>
	</Item> 
	<Item>
		<Field>MGS_STATUS_CODE</Field>
		<Header>MGS STATUS CODE</Header>
	</Item> 
	<Item>
		<Field>MGS_SUGG_1</Field>
		<Header>MGS SUGG 1</Header>
	</Item> 
	<Item>
		<Field>MGS_STAT_1</Field>
		<Header>MGS STAT 1</Header>
	</Item> 
	<Item>
		<Field>MGS_SUGG_2</Field>
		<Header>MGS SUGG 2</Header>
	</Item> 
	<Item>
		<Field>MGS_STAT_2</Field>
		<Header>MGS STAT 2</Header>
	</Item> 
	<Item>
		<Field>MGS_SUGG_3</Field>
		<Header>MGS SUGG 3</Header>
	</Item> 
	<Item>
		<Field>MGS_STAT_3</Field>
		<Header>MGS STAT 3</Header>
	</Item> 
	<Item>
		<Field>MGS_SUGG_4</Field>
		<Header>MGS STAT 4</Header>
	</Item> 
	<Item>
		<Field>USABILITY_INDICATOR</Field>
		<Header>USABILITY INDICATOR</Header>
	</Item> 
	<Item>
		<Field>PARENTAGE_INDICATOR</Field>
		<Header>PARENTAGE INDICATOR</Header>
	</Item> 
	<Item>
		<Field>FEE_CODE</Field>
		<Header>FEE CODE</Header>
	</Item> 
	<Item>
		<Field>DATE</Field>
		<Header>DATE</Header>
	</Item> 
	<Item>
		<Field>GETS_EVAL</Field>
		<Header>GETS EVAL</Header>
	</Item> 
	 
</Template>
' 
 ,
'Parentage_Ver_Records_CSV',
CURRENT DATE 
)
;

INSERT INTO OUTPUT_FILE_TEMPLATE_TABLE
(
	NAME,
	TYPE,
	TEMPLATE_DETAIL,
	PREFIX_OUTPUT_NAME,
	CREATE_DATE
)
VALUES
('ANIM_FORMATTED_PEDIGREE',
'JSON',
'   {      
        "Input": "<INPUT>",
        "Sex": "<SEX_CODE>",
		"Animal": "<PREFERED_ID>",
		"Sire": "<SIRE_ID>",
		"Dam": "<DAM_ID>",
		"Alias": "<ALIAS_ID>",
		"DOB": "<BIRTH_DATE>",
		"Source_Code": "<SRC>", 
		"Mod_Date": "<MODIFY_DATE>",
		"Multi_Birth_Code": "<MBC>",
		"Registry_Status": "<REG>",
		"Codes": "<CODES>",
		"RHA": "<RHA>",
		"Recessives": "<RECESSIVES>",
		"Long_Name": "<LONG_NAME>"  
     }',
'Animal_formatted_pedigree',
CURRENT DATE 
)
;
-- AUTHOR: NgdTuyen  25/01/2021

INSERT INTO OUTPUT_FILE_TEMPLATE_TABLE
(
	NAME,
	TYPE,
	TEMPLATE_DETAIL,
	PREFIX_OUTPUT_NAME,
	CREATE_DATE
)
VALUES
('ANIM_FORMATTED_NAAB_CODE',
'JSON',
'   {      
        "Input": "<INPUT_VALUE>",
        "Naab_Id":"<NAAB_ID>",
        "Anim_Key":"<ANIM_KEY>",
        "Int_Id": "<INT_ID>",
        "Sex_Code": "<SEX_CODE>",
        "Species_Code": "<SPECIES_CODE>"
     }',
'Animal_formatted_naab_code',
CURRENT DATE 
)
;

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
		"Input": "<INPUT>",
		"Root_Animal_Id":"<ROOT_ANIMAL_ID>",
		"Animal_Id":"<ANIMAL_ID>",
		"Sire_Int_Id": "<SIRE_INT_ID>",
		"Dam_Int_Id": "<DAM_INT_ID>", 
		"Sex_Code": "<SEX_CODE>",
		"Generation": "<GENERATION>",
		"Birth_Date": "<BIRTH_DATE>",
		"Long_Name": "<LONG_NAME>",
		"Genotype": "<GENOTYPED>",
		"SRC": "<SRC>",
		"Is_Exist": "<IS_EXIST>"
     }',
'Animal_formatted_5first_generation',
CURRENT DATE 
)
;

--AUTHOR: Linh Pham 26/01/2021  GET HERD_COW_AND_CONTROL_NUMBER_BY_ID

INSERT INTO OUTPUT_FILE_TEMPLATE_TABLE 
(
	NAME,
	TYPE,
	TEMPLATE_DETAIL,
	PREFIX_OUTPUT_NAME,
	CREATE_DATE
)
VALUES
('HERD_COW_AND_CONTROL_NUMBER',
'JSON',
'   {     
		"ANIMAL_ID": "<INT_ID>", 
		"HERD_CODE": "<HERD_CODE>",
		"CTRL_NUM": "<CTRL_NUM>",
     }',
'Herd_cow_and_control_number',

CURRENT DATE 
)
;
 

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
--AUTHOR: Linh Pham 26/01/2021 GET ANIMAL BY HERD COW CONTROL NUMBER
 INSERT INTO OUTPUT_FILE_TEMPLATE_TABLE 
(
	NAME,
	TYPE,
	TEMPLATE_DETAIL,
	PREFIX_OUTPUT_NAME,
	CREATE_DATE
)
VALUES
('GET ANIMAL BY HERD COW CONTROL NUMBER',
'JSON',
'   {     
		"INPUT": "<INPUT_VALUE>",
		"HERD_CODE": "<HERD_CODE>",
		"CTRL_NUM": "<CTRL_NUM>",
		"ANIM_KEY":"<ANIM_KEY>",
		"ANIMAL_ID": "<INT_ID>"
     }',
'Get_animal_by_herd_cow_control_number',

CURRENT DATE 
);

--AUTHOR: TRI DO 26/01/2021 get animal clonal family by id
INSERT INTO OUTPUT_FILE_TEMPLATE_TABLE 
(
	NAME,
	TYPE,
	TEMPLATE_DETAIL,
	PREFIX_OUTPUT_NAME,
	CREATE_DATE
)
VALUES
('ANIM_CLONAL_FAMILY_RECORD',
'JSON',
'   {     
		"MEMBER": "<MEMBER>", 
		"SOURCE_CODE": "<SOURCE_CODE>",
		"MOD_DATE": "<MOD_DATE>",
     }',
'anim_clonal_family_record',

CURRENT DATE 
)
;

--AUTHOR:Tuyen 27/01/2021 Get Animal Type Composite Information For AY,BS,GU,MS
INSERT INTO OUTPUT_FILE_TEMPLATE_TABLE
(
	NAME,
	TYPE,
	TEMPLATE_DETAIL,
	PREFIX_OUTPUT_NAME,
	CREATE_DATE
)
VALUES
('ANIM_FORMATTED_TYPE_COMPOSITE_INFORMATION_FOR_AY_BS_GU_MS',
'JSON',
'   {      
		"Input": "<INPUT>",
		"Animal_Id":"<ANIMAL_ID>",
		"Br":"<BREED_CODE>",
		"Anim_key":"<ANIM_KEY>",
		"Sex": "<SEX_CODE>",
		"Sire_Pta": "<SIRE_PTA>",
		"Sire_Rel": "<SIRE_REL>",
		"Udder_Pta": "<UDDER_PTA>",
		"Udder_Rel": "<UDDER_REL>",
		"Feet_Pta": "<FEET_PTA>",
		"Feet_Rel": "<FEET_REL>",
		"Source": "<SOURCE>"
     }',
'Animal_formatted_Type_Composite_Information_For_Ay_Bs_Gu_Ms',
CURRENT DATE 
)
;
