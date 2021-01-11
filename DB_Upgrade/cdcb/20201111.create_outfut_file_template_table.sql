
CREATE TABLE OUTPUT_FILE_TEMPLATE_TABLE
( 
NAME varchar(200) not null,
TYPE varchar(50) not null,
TEMPLATE_DETAIL varchar(10000) not null,
PREFIX_OUTPUT_NAME varchar(200) not null,
CREATE_DATE DATE not null,
 constraint OUTPUT_FILE_TEMPLATE_TABLE_PK primary key (NAME,TYPE)
);

 
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
