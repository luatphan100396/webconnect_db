CREATE OR REPLACE PROCEDURE usp_Update_Animals_Info
--======================================================
--Author: Nghi Ta
--Created Date: 2020-05-12
--Description: Update animal birth date, long name
--Output:
--        +Ds1: 1 if success. Failed will raise exception
--======================================================
(@Inputs VARCHAR(30000))
 DYNAMIC RESULT SETS 1
	LANGUAGE SQL
BEGIN
 
DECLARE input_xml XML;
DECLARE sql varchar(30000);
DECLARE sql_update_column varchar(10000);
DECLARE sql_where varchar(10000);
DECLARE v_ANIM_KEY INT;
DECLARE v_SPECIES_CODE CHAR(1);
DECLARE v_SEX_CODE CHAR(1);
DECLARE v_INT_ID CHAR(17);
DECLARE v_LONG_NAME CHAR(30);
DECLARE v_BIRTH_DATE DATE;
DECLARE v_BIRTH_PDATE smallint;
DECLARE DEFAULT_DATE DATE;
  
DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpUpdateInputs 
	(
		Field      VARCHAR(128),
		Value       VARCHAR(3000)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
 

set input_xml =  xmlparse(document @Inputs);

INSERT INTO SESSION.TmpUpdateInputs 
(    
	Field,
	Value
)
 SELECT  
		 XML_BOOKS.Field,
		 XML_BOOKS.Value		 
		FROM  
		XMLTABLE(
		'$doc/Inputs/Item' 
		PASSING input_xml AS "doc"
		COLUMNS 
		 
		Field      VARCHAR(128)  PATH 'Field',
		Value       VARCHAR(3000)  PATH 'Value' 
		) AS XML_BOOKS;       
    
   SET v_INT_ID = (SELECT VALUE FROM SESSION.TmpUpdateInputs WHERE UPPER(Field) ='ANIMAL_ID' LIMIT 1 with UR); 
   SET v_ANIM_KEY = (SELECT VALUE FROM SESSION.TmpUpdateInputs WHERE UPPER(Field) ='ANIM_KEY' LIMIT 1 with UR); 
   SET v_SPECIES_CODE = (SELECT VALUE FROM SESSION.TmpUpdateInputs WHERE UPPER(Field) ='SPECIES_CODE' LIMIT 1 with UR); 
   SET v_SEX_CODE = (SELECT VALUE FROM SESSION.TmpUpdateInputs WHERE UPPER(Field) ='SEX_CODE' LIMIT 1 with UR); 
   SET v_LONG_NAME = (SELECT VALUE FROM SESSION.TmpUpdateInputs WHERE  UPPER(Field) ='LONG_NAME' LIMIT 1 with UR); 
   SET v_BIRTH_DATE = (SELECT VALUE FROM SESSION.TmpUpdateInputs WHERE  UPPER(Field) ='BIRTH_DATE' LIMIT 1 with UR); 
   
    
    SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
    SET v_BIRTH_PDATE =  days(v_BIRTH_DATE)- days(DEFAULT_DATE) ;

--Update animals

--Set name
UPDATE ANIM_NAME_TABLE 
SET ANIM_NAME = v_LONG_NAME 
WHERE INT_ID = v_INT_ID
 AND SPECIES_CODE = v_SPECIES_CODE  
 AND SEX_CODE = v_SEX_CODE;
 
-- Set Birth Date
UPDATE PEDIGREE_TABLE 
SET BIRTH_PDATE = v_BIRTH_PDATE 
WHERE ANIM_KEY = v_ANIM_KEY 
AND SPECIES_CODE = v_SPECIES_CODE
;
 
 
 COMMIT;
  
 	 begin
		 	DECLARE cursor1 CURSOR WITH RETURN for
		 		
		 	--SELECT 1 as Result
		 	SELECT 1 
		 	FROM sysibm.sysdummy1 with UR;
		 	 
		 	
		 	OPEN cursor1;
		 	 
	   end;
	     
  
END


