CREATE OR REPLACE PROCEDURE usp_Update_Animal_Info_By_Submit_fmt1
--======================================================================================
--Author: Trong Le
--Created Date: 2020-09-23
--Description: This SP exports a file that contains a string of values from the input.
--Output: 
--       +Ds1: A flag is returned to let web knows the status of process:
--				v_IS_EDITABLE = 0 - This animal is unprocessed yet.
--				v_IS_EDITABLE = 1 - This animal is processed already.
--======================================================================================
(
	IN @input_char VARCHAR(10000)
)
 
 DYNAMIC RESULT SETS  10
BEGIN
    
	/*======================================
	--		Declaration variables
	======================================*/
	DECLARE input_xml				XML;
	DECLARE fmt1_value				CHAR(140); 
	
	-- Mandatory fileds
	DECLARE v_ANIM_KEY				INT;
	DECLARE v_PREFERRED_ID			CHAR(17);
	DECLARE v_SPECIES_CODE			CHAR(1);
	DECLARE v_ANIMAL_ID				CHAR(17);
	DECLARE	v_SEX_CODE				CHAR(1);
	
	-- Editable from API
	DECLARE v_LONG_NAME				CHAR(30);
	DECLARE v_NEW_SEX_CODE			CHAR(1);
	DECLARE v_NEW_PREFERRED_ID		CHAR(17);
	DECLARE v_BIRTH_DATE			CHAR(8);
	DECLARE v_REGIS_STATUS_CODE		CHAR(2);
	DECLARE v_SIRE_ID				CHAR(17);
	DECLARE v_DAM_ID				CHAR(17);
	DECLARE v_MULTI_BIRTH_CODE		CHAR(1);
	
	-- Constant variables
	DECLARE v_RECORD_TYPE			CHAR(1);
	DECLARE v_DEFAULT_RECORD_TYPE	CHAR(1);
	DECLARE v_RECORD_VERSION		CHAR(1);
	DECLARE v_ZEROES				CHAR(6);
	DECLARE v_GROUP_NAME			CHAR(8);
	DECLARE v_PARENTAGE_ONLY_IND	CHAR(1);
	DECLARE v_CDCB_FEE_PAID_CODE	CHAR(1);
	DECLARE v_HERD_REASON_CODE		CHAR(1);
	
	-- Others
	DECLARE v_PROCESSING_DATE		CHAR(8);
	DECLARE v_PED_VERIFICATION		CHAR(1);
	DECLARE v_ALIAS_ID				CHAR(17);
	DECLARE v_DEFAULT_ALIAS_ID		CHAR(17);
	DECLARE v_SOURCE_CODE			CHAR(1);
	DECLARE DEFAULT_DATE 			DATE;
	DECLARE v_COUNT					SMALLINT;
	DECLARE v_NUM_ROW				SMALLINT;
	DECLARE v_IS_EDITABLE 			INT;
	DECLARE Multi_File_Name			VARCHAR(3000);		-- How much of size is enough to contain
	DECLARE Single_File_Name		VARCHAR(2000);
	
	-- Variables that get from existing data in database
	DECLARE v_DB_LONG_NAME			CHAR(30);
	DECLARE v_DB_BIRTH_DATE			CHAR(8);
	DECLARE v_DB_REGIS_STATUS_CODE	CHAR(2);
	DECLARE v_DB_SIRE_ID			CHAR(17);
	DECLARE v_DB_DAM_ID				CHAR(17);
	DECLARE v_DB_MULTI_BIRTH_CODE	CHAR(1);
	DECLARE v_DB_SOURCE_CODE		CHAR(1);
	DECLARE v_DB_PED_VERIFICATION	CHAR(1);
	
	-- Variable that get from mutiple items - cross reference
	DECLARE v_CROSS_REF_ID					SMALLINT;
	DECLARE v_CROSS_REF_ANIMAIL_ID			CHAR(17);
	DECLARE v_CROSS_REF_LONG_NAME			CHAR(30);
	DECLARE v_CROSS_REF_SEX_CODE			CHAR(1);
	DECLARE v_CROSS_REF_MOD_DATE			CHAR(8);
	DECLARE v_CROSS_REF_REGIS_STATUS_CODE	CHAR(2);
	DECLARE v_CROSS_REF_ACTION				CHAR(7);
	
	-- Variable that get from existing data in database for cross reference
	DECLARE v_CROSS_REF_DB_LONG_NAME			CHAR(30);
	DECLARE v_CROSS_REF_DB_REGIS_STATUS_CODE	CHAR(2);
	

    /*======================================
    --		Create temp tables
    ======================================*/
    DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpFilterInputs 
	(
		Field	VARCHAR(50),
		Value	VARCHAR(50)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpFilterInputsMultiSelect 
	(
		Field	VARCHAR(128),
		Value	VARCHAR(128),
		Order	SMALLINT  GENERATED BY DEFAULT AS IDENTITY  (START WITH 1 INCREMENT BY 1)  
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpCrossReferences
	(
		ID					SMALLINT GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1),
		ANIMAL_ID			CHAR(17),
		ANIM_NAME			CHAR(30),
		SEX_CODE			CHAR(1),
		MOD_DATE			CHAR(10),
		REGIS_STATUS_CODE	CHAR(2),
		ACTION				CHAR(7)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpListFileName
	(
		ID			SMALLINT GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1),
		FILE_NAME	VARCHAR(200)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	

	SET input_xml =  xmlparse(document @input_char);
	
	/*======================================
	--		Get data into temp tables
	======================================*/
	INSERT INTO SESSION.TmpFilterInputs 
	(    
		Field,
		Value
	)
	 SELECT  
		 XML_BOOKS.Field,
		 XML_BOOKS.Value		 
		FROM  
		XMLTABLE(
		'$doc/inputs/item' 
		PASSING input_xml AS "doc"
		COLUMNS 
		 
		Field	VARCHAR(128)	PATH 'Field',
		Value	VARCHAR(3000)	PATH 'Value' 
		) AS XML_BOOKS;
	
	INSERT INTO SESSION.TmpFilterInputsMultiSelect 
	(    
		Field,
		Value 
	)
	SELECT  
		XML_BOOKS.Field,
		XML_BOOKS.Value		 
	FROM  
		XMLTABLE
		(
			'$doc/inputs/cross_references/cross_reference/item'
		PASSING input_xml AS "doc"
		COLUMNS
			Field	VARCHAR(128)	PATH 'Field',
			Value	VARCHAR(3000)	PATH 'Value' 
		) AS XML_BOOKS
	;
	
	INSERT INTO SESSION.TmpCrossReferences
	(
		ANIMAL_ID,
		ANIM_NAME,
		SEX_CODE,
		MOD_DATE,
		REGIS_STATUS_CODE,
		ACTION
	) 
	WITH CTE AS
	(
		SELECT	Field,
				Value,
				ROW_NUMBER()OVER(PARTITION BY FIELD ORDER BY ORDER) AS GROUP 
		FROM SESSION.TmpFilterInputsMultiSelect 
	),
	Cte_Animal_Id AS
	(
	 	SELECT value AS ANIMAL_ID, GROUP 
	 	FROM CTE
	  	WHERE field ='ANIMAL_ID'
	),
	Cte_Anim_Name AS
	(
	 	SELECT value AS ANIM_NAME, GROUP
	  	FROM CTE
	  	WHERE field ='ANIM_NAME'
	),
	Cte_Sex_Code AS
	(
	 	SELECT value AS SEX_CODE, GROUP
	  	FROM CTE
	  	WHERE field ='SEX_CODE'
	)
	,
	Cte_Mode_Date AS
	(
	 	SELECT value AS MOD_DATE, GROUP
	  	FROM CTE
	  	WHERE field ='MOD_DATE'
	),
	Cte_Regis_Status_Code AS
	(
	 	SELECT value AS REGIS_STATUS_CODE, GROUP
	  	FROM CTE
	  	WHERE field ='REGIS_STATUS_CODE'
	),
	Cte_Action AS
	(
	 	SELECT value AS ACTION, GROUP
	  	FROM CTE
	  	WHERE field ='ACTION'
	)
	SELECT	id.ANIMAL_ID, 
			name.ANIM_NAME, 
			sex.SEX_CODE,
			moddate.MOD_DATE,
			regis.REGIS_STATUS_CODE,
			act.ACTION
	FROM Cte_Animal_Id id
	INNER JOIN Cte_Anim_Name name
		ON id.group = name.group
	INNER JOIN Cte_Sex_Code sex
		ON id.group = sex.group
	INNER JOIN Cte_Mode_Date moddate
		ON id.group = moddate.group
	INNER JOIN Cte_Regis_Status_Code regis
		ON id.group = regis.group
	INNER JOIN Cte_Action act
		ON id.group = act.group
	;
		 
  
  /*======================================
	-- 		Get data from the input
	======================================*/
	-- Mandatory fileds
	SET v_ANIM_KEY = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE Field = 'ANIM_KEY' LIMIT 1);
	SET v_PREFERRED_ID = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE Field = 'PREFERRED_ID' LIMIT 1);
	SET v_SPECIES_CODE = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE Field = 'SPECIES_CODE' LIMIT 1);
	SET v_ANIMAL_ID = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE Field = 'ANIMAL_ID' LIMIT 1);
	SET v_SEX_CODE = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE Field = 'SEX_CODE' LIMIT 1);
	
	-- Editable from API
	SET v_LONG_NAME = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE Field = 'ANIM_NAME' LIMIT 1);
	SET v_NEW_SEX_CODE = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE Field = 'NEW_SEX_CODE' LIMIT 1);
	SET v_NEW_PREFERRED_ID = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE Field = 'NEW_PREFERRED_ID' LIMIT 1);
	SET v_BIRTH_DATE = (SELECT replace(VALUE, '-', '') FROM SESSION.TmpFilterInputs WHERE Field = 'BIRTH_DATE' LIMIT 1);
	SET v_REGIS_STATUS_CODE = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE Field = 'REGIS_STATUS_CODE' LIMIT 1);
	SET v_SIRE_ID = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE Field = 'SIRE_ID' LIMIT 1);
	SET v_DAM_ID = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE Field = 'DAM_ID' LIMIT 1);
	SET v_MULTI_BIRTH_CODE = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE Field = 'MULTI_BIRTH_CODE' LIMIT 1);
	
	-- Constant variables
	SET v_DEFAULT_RECORD_TYPE = 'P';
	SET v_RECORD_VERSION = '1';
	SET v_ZEROES = '000000';
	SET v_GROUP_NAME = '';
	SET v_PARENTAGE_ONLY_IND = '';
	SET v_CDCB_FEE_PAID_CODE	 = '';
	SET v_HERD_REASON_CODE = '';
	
	-- Others
	SET v_PROCESSING_DATE = VARCHAR_FORMAT( CURRENT DATE, 'YYYYMMDD');
	SET v_PED_VERIFICATION = (	SELECT	ascii(ANIM_INFO_MASK)
   								FROM	PEDIGREE_TABLE
   								WHERE	ANIM_KEY = v_ANIM_KEY
   								AND		SPECIES_CODE = v_SPECIES_CODE LIMIT 1);
		-- v_DEFAULT_ALIAS_ID: Identify whether the current animal is preferred or cross reference
			-- Preferred animal
	IF(v_PREFERRED_ID = v_ANIMAL_ID) THEN
		SET v_DEFAULT_ALIAS_ID = '';
		-- Cross-reference
	ELSEIF(v_PREFERRED_ID <> v_ANIMAL_ID) THEN		
		SET v_DEFAULT_ALIAS_ID = v_ANIMAL_ID;
	END IF;
	
	SET v_SOURCE_CODE = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE Field = 'SOURCE_CODE' LIMIT 1);
	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);


    /*===============================================
	--	Get existing data with the mandatory fields
	================================================*/
   SELECT	SIRE_ID,
   			DAM_ID,
   			BIRTH_DATE,
			SOURCE_CODE,
			PED_VERIFICATION,
			MULTI_BIRTH_CODE,
			REGIS_STATUS_CODE,
			LONG_NAME
   INTO		v_DB_SIRE_ID,
   			v_DB_DAM_ID,
   			v_DB_BIRTH_DATE,
   			v_DB_SOURCE_CODE,
   			v_DB_PED_VERIFICATION,
   			v_DB_MULTI_BIRTH_CODE,
   			v_DB_REGIS_STATUS_CODE,
   			v_DB_LONG_NAME
   FROM TABLE (fn_Get_Animal_Info_By_ID(v_ANIMAL_ID, v_ANIM_KEY, v_SPECIES_CODE, v_SEX_CODE)) LIMIT 1;
   
    /*===================================================================
	--	Call SP to cancat the elements of the string in format1 file
		and export that file
	====================================================================*/
	--	For animal name:
	--		* The new name is the correct name from the WEB
	--		* The record type code is 'P'
	--		* The pedigree verification code will be set to '2' in the case of removing animal name
   IF v_LONG_NAME IS NOT NULL THEN
		SET v_RECORD_TYPE = 'P';
		SET v_PED_VERIFICATION =	CASE WHEN v_LONG_NAME = '' THEN '2'
									ELSE v_DB_PED_VERIFICATION
									END;
		
		CALL usp_Submit_Format1_File
		(
			v_SPECIES_CODE,
			v_SEX_CODE,
			v_PREFERRED_ID,
    				
			v_DB_SIRE_ID,
			v_DB_DAM_ID,
			v_DEFAULT_ALIAS_ID,  
			v_DB_BIRTH_DATE,
			v_DB_SOURCE_CODE,
   			v_PROCESSING_DATE,
   			v_RECORD_TYPE,
  			v_PED_VERIFICATION,
   			v_RECORD_VERSION,
   			v_DB_MULTI_BIRTH_CODE,
   			v_DB_REGIS_STATUS_CODE,		
   			v_ZEROES,
   			v_LONG_NAME,
   			
   			v_GROUP_NAME,
   			v_PARENTAGE_ONLY_IND,
   			v_CDCB_FEE_PAID_CODE,
   			v_HERD_REASON_CODE,
   			Single_File_Name
		);
		
		INSERT INTO SESSION.TmpListFileName
		(FILE_NAME)
		SELECT Single_File_Name
		FROM SYSIBM.SYSDUMMY1 WITH UR;
		
   END IF;
   
   
   -- For Gender:
   --	* The new sex is the correct sex from the WEB
   --	* The record type is 'R'
   --	* The cross reference ID is the same as animal ID
   IF v_NEW_SEX_CODE IS NOT NULL THEN
   		SET v_RECORD_TYPE = 'R';
   		SET v_ALIAS_ID = v_PREFERRED_ID;
   		
   		CALL usp_Submit_Format1_File
   		(
   			v_SPECIES_CODE,
			v_NEW_SEX_CODE,
			v_PREFERRED_ID,
			
			v_DB_SIRE_ID,
			v_DB_DAM_ID,
			v_ALIAS_ID,  
			v_DB_BIRTH_DATE,
			v_DB_SOURCE_CODE,
   			v_PROCESSING_DATE,
   			v_RECORD_TYPE,
   			v_DB_PED_VERIFICATION,
   			v_RECORD_VERSION,
   			v_DB_MULTI_BIRTH_CODE,
   			v_DB_REGIS_STATUS_CODE,
   			v_ZEROES,
   			v_DB_LONG_NAME,
   			
   			v_GROUP_NAME,
   			v_PARENTAGE_ONLY_IND,
   			v_CDCB_FEE_PAID_CODE,
   			v_HERD_REASON_CODE,
   			Single_File_Name
   		);
   		
   		INSERT INTO SESSION.TmpListFileName
		(FILE_NAME)
		SELECT Single_File_Name
		FROM SYSIBM.SYSDUMMY1 WITH UR;
   		
   END IF;
   
   
   -- For birth date:
   --	* The new birth date is the correct birth date from the WEB
   --	* The pedigree verification code is '2'
   IF v_BIRTH_DATE IS NOT NULL THEN
   		SET v_PED_VERIFICATION = '2';
   		
   		CALL usp_Submit_Format1_File
   		(
   			v_SPECIES_CODE,
			v_SEX_CODE,
			v_PREFERRED_ID,
			
			v_DB_SIRE_ID,
			v_DB_DAM_ID,
			v_DEFAULT_ALIAS_ID,  
			v_BIRTH_DATE,
    		v_DB_SOURCE_CODE,
   			v_PROCESSING_DATE,
   			v_DEFAULT_RECORD_TYPE,
   			v_PED_VERIFICATION,
   			v_RECORD_VERSION,
   			v_DB_MULTI_BIRTH_CODE,
   			v_DB_REGIS_STATUS_CODE,
   			v_ZEROES,
   			v_DB_LONG_NAME,
   			
   			v_GROUP_NAME,
   			v_PARENTAGE_ONLY_IND,
   			v_CDCB_FEE_PAID_CODE,
   			v_HERD_REASON_CODE,
   			Single_File_Name
   		);
   		
   		INSERT INTO SESSION.TmpListFileName
		(FILE_NAME)
		SELECT Single_File_Name
		FROM SYSIBM.SYSDUMMY1 WITH UR;

   END IF;
   
   
   -- For Registry status code
   IF v_REGIS_STATUS_CODE IS NOT NULL THEN
   		CALL usp_Submit_Format1_File
   		(
   			v_SPECIES_CODE,
			v_SEX_CODE,
			v_PREFERRED_ID,
			
			v_DB_SIRE_ID,
			v_DB_DAM_ID,
			v_DEFAULT_ALIAS_ID,  
			v_DB_BIRTH_DATE,
			v_DB_SOURCE_CODE,
   			v_PROCESSING_DATE,
   			v_DEFAULT_RECORD_TYPE,
   			v_DB_PED_VERIFICATION,
   			v_RECORD_VERSION,
   			v_DB_MULTI_BIRTH_CODE,
   			v_REGIS_STATUS_CODE,
   			v_ZEROES,
   			v_DB_LONG_NAME,
   			
   			v_GROUP_NAME,
   			v_PARENTAGE_ONLY_IND,
   			v_CDCB_FEE_PAID_CODE,
   			v_HERD_REASON_CODE,
   			Single_File_Name
   		);
   		
		INSERT INTO SESSION.TmpListFileName
		(FILE_NAME)
		SELECT Single_File_Name
		FROM SYSIBM.SYSDUMMY1 WITH UR;
   		
   END IF;
   
   
   -- For Sire:
   --	* The new sire ID is the correct sire ID from the WEB
   --	* The pedigree verification code is '2'
   IF v_SIRE_ID IS NOT NULL THEN
   		SET v_PED_VERIFICATION = '2';
   
   		CALL usp_Submit_Format1_File
   		(
   			v_SPECIES_CODE,
			v_SEX_CODE,
			v_PREFERRED_ID,
			
			v_SIRE_ID,
			v_DB_DAM_ID,
			v_DEFAULT_ALIAS_ID, 
			v_DB_BIRTH_DATE,
			v_DB_SOURCE_CODE,
   			v_PROCESSING_DATE,
   			v_DEFAULT_RECORD_TYPE,
   			v_PED_VERIFICATION,
   			v_RECORD_VERSION,
   			v_DB_MULTI_BIRTH_CODE,
   			v_DB_REGIS_STATUS_CODE,
   			v_ZEROES,
   			v_DB_LONG_NAME,
			v_GROUP_NAME,
   			v_PARENTAGE_ONLY_IND,
   			v_CDCB_FEE_PAID_CODE,
			v_HERD_REASON_CODE,
			Single_File_Name
   		);
   		
   		INSERT INTO SESSION.TmpListFileName
		(FILE_NAME)
		SELECT Single_File_Name
		FROM SYSIBM.SYSDUMMY1 WITH UR;
		   
   END IF;
   
   
   -- For Dam:
   --	* The new dam ID is the correct dam ID from the WEB
   --	* The pedigree verification code is '2'
   IF v_DAM_ID IS NOT NULL THEN
   		SET v_PED_VERIFICATION = '2';
   		
   		CALL usp_Submit_Format1_File
   		(
   			v_SPECIES_CODE,
		    v_SEX_CODE,
		    v_PREFERRED_ID,
		    				
		    v_DB_SIRE_ID,
		    v_DAM_ID,
		    v_DEFAULT_ALIAS_ID,
		    v_DB_BIRTH_DATE,
		    v_DB_SOURCE_CODE,
		   	v_PROCESSING_DATE,
		   	v_DEFAULT_RECORD_TYPE,
		   	v_PED_VERIFICATION,
		   	v_RECORD_VERSION,
		   	v_DB_MULTI_BIRTH_CODE,
		   	v_DB_REGIS_STATUS_CODE,
		   	v_ZEROES,
		   	v_DB_LONG_NAME,
		   	v_GROUP_NAME,
   			v_PARENTAGE_ONLY_IND,
   			v_CDCB_FEE_PAID_CODE,
			v_HERD_REASON_CODE,
			Single_File_Name
   		);
   		
   		INSERT INTO SESSION.TmpListFileName
		(FILE_NAME)
		SELECT Single_File_Name
		FROM SYSIBM.SYSDUMMY1 WITH UR;
   		
   END IF;
   
      
   -- For multi birth code:
   --	* The MBC is the correct MBC from the WEB
   IF v_MULTI_BIRTH_CODE IS NOT NULL THEN
   		CALL usp_Submit_Format1_File
   		(
   			v_SPECIES_CODE,
			v_SEX_CODE,
			v_PREFERRED_ID,
			
			v_DB_SIRE_ID,
			v_DB_DAM_ID,
			v_DEFAULT_ALIAS_ID,  
			v_DB_BIRTH_DATE,
			v_DB_SOURCE_CODE,
   			v_PROCESSING_DATE,
   			v_DEFAULT_RECORD_TYPE,
   			v_DB_PED_VERIFICATION,
   			v_RECORD_VERSION,
   			v_MULTI_BIRTH_CODE,
   			v_DB_REGIS_STATUS_CODE,
   			v_ZEROES,
   			v_DB_LONG_NAME,
   			
   			v_GROUP_NAME,
   			v_PARENTAGE_ONLY_IND,
   			v_CDCB_FEE_PAID_CODE,
			v_HERD_REASON_CODE,
			Single_File_Name
   		);
   		
   		INSERT INTO SESSION.TmpListFileName
		(FILE_NAME)
		SELECT Single_File_Name
		FROM SYSIBM.SYSDUMMY1 WITH UR;
		   
   END IF;
   
   
   -- For preferred ID:
   --	Step 1. Remove previously preferred ID
   --	Step 2. Re-add previously preferred ID, but not as the preferred ID
   --	Step 3. Re-add bull name and/or registry status to non-preferred ID
   IF v_NEW_PREFERRED_ID IS NOT NULL THEN
   		-- It's a cow
   		IF v_SEX_CODE = 'F' THEN
   			-- This does not exist in database
   			IF NOT EXISTS (SELECT 1 FROM ID_XREF_TABLE WHERE INT_ID = v_NEW_PREFERRED_ID AND SPECIES_CODE = v_SPECIES_CODE LIMIT 1) THEN
   				-- Based on the rule Change the preferred ID
   				SET v_ALIAS_ID = v_PREFERRED_ID;
   				
   				CALL usp_Submit_Format1_File
   				(
   					v_SPECIES_CODE,
   					v_SEX_CODE,
   					-- Based on the rule Change the preferred ID
   					v_NEW_PREFERRED_ID,
   					
   					v_DB_SIRE_ID,
					v_DB_DAM_ID,
					v_ALIAS_ID,
					v_DB_BIRTH_DATE,
					v_DB_SOURCE_CODE,
					v_PROCESSING_DATE,
					v_DEFAULT_RECORD_TYPE,
					v_DB_PED_VERIFICATION,
					v_RECORD_VERSION,
					v_DB_MULTI_BIRTH_CODE,
					v_DB_REGIS_STATUS_CODE,
					v_ZEROES,
					v_DB_LONG_NAME,
					
					v_GROUP_NAME,
					v_PARENTAGE_ONLY_IND,
					v_CDCB_FEE_PAID_CODE,
					v_HERD_REASON_CODE,
					Single_File_Name
   				);
   				
   				INSERT INTO SESSION.TmpListFileName
				(FILE_NAME)
				SELECT Single_File_Name
				FROM SYSIBM.SYSDUMMY1 WITH UR;
   				
   			-- It exists in database
   			ELSE
   				-- Based on the rule Change the preferred ID
   				SET v_ALIAS_ID = v_ANIMAL_ID;
   				
   				CALL usp_Submit_Format1_File
   				(
   					v_SPECIES_CODE,
   					v_SEX_CODE,
   					v_NEW_PREFERRED_ID,
   					
   					v_DB_SIRE_ID,
					v_DB_DAM_ID,
					v_ALIAS_ID,
					v_DB_BIRTH_DATE,
					v_DB_SOURCE_CODE,
					v_PROCESSING_DATE,
					v_DEFAULT_RECORD_TYPE,
					v_DB_PED_VERIFICATION,
					v_RECORD_VERSION,
					v_DB_MULTI_BIRTH_CODE,
					v_DB_REGIS_STATUS_CODE,
					v_ZEROES,
					v_DB_LONG_NAME,
					
					v_GROUP_NAME,
					v_PARENTAGE_ONLY_IND,
					v_CDCB_FEE_PAID_CODE,
					v_HERD_REASON_CODE,
					Single_File_Name
   				);
   				
   				INSERT INTO SESSION.TmpListFileName
				(FILE_NAME)
				SELECT Single_File_Name
				FROM SYSIBM.SYSDUMMY1 WITH UR;
				
   			END IF;
   		-- It's a bull
   		ELSEIF v_SEX_CODE = 'M' THEN
			--	1. Remove previously preferred ID:
			SET v_ALIAS_ID = v_PREFERRED_ID;
   			SET v_RECORD_TYPE = 'Y';
   				
   			CALL usp_Submit_Format1_File
   			(
				v_SPECIES_CODE,
   				v_SEX_CODE,
   				-- Based on the rule Change the preferred ID
   				v_NEW_PREFERRED_ID,
   					
   				v_DB_SIRE_ID,
				v_DB_DAM_ID,
				v_ALIAS_ID,
				v_DB_BIRTH_DATE,
				v_DB_SOURCE_CODE,
				v_PROCESSING_DATE,
				v_RECORD_TYPE,
				v_DB_PED_VERIFICATION,
				v_RECORD_VERSION,
				v_DB_MULTI_BIRTH_CODE,
				v_DB_REGIS_STATUS_CODE,
				v_ZEROES,
				v_DB_LONG_NAME,
					
				v_GROUP_NAME,
				v_PARENTAGE_ONLY_IND,
				v_CDCB_FEE_PAID_CODE,
				v_HERD_REASON_CODE,
				Single_File_Name
			);
			
			INSERT INTO SESSION.TmpListFileName
			(FILE_NAME)
			SELECT Single_File_Name
			FROM SYSIBM.SYSDUMMY1 WITH UR;
			
			
			--	2. Re-add previously preferred ID, but not as the preferred ID
			SET v_RECORD_TYPE = 'P';
			
			CALL usp_Submit_Format1_File
			(
				v_SPECIES_CODE,
   				v_SEX_CODE,
   				v_NEW_PREFERRED_ID,				-- Based on the rule Change the preferred ID
   					
   				v_DB_SIRE_ID,
				v_DB_DAM_ID,
				v_DEFAULT_ALIAS_ID,
				v_DB_BIRTH_DATE,
				v_DB_SOURCE_CODE,
				v_PROCESSING_DATE,
				v_RECORD_TYPE,
				v_DB_PED_VERIFICATION,
				v_RECORD_VERSION,
				v_DB_MULTI_BIRTH_CODE,
				v_DB_REGIS_STATUS_CODE,
				v_ZEROES,
				v_DB_LONG_NAME,
					
				v_GROUP_NAME,
				v_PARENTAGE_ONLY_IND,
				v_CDCB_FEE_PAID_CODE,
				v_HERD_REASON_CODE,
				Single_File_Name
			);
			
			INSERT INTO SESSION.TmpListFileName
			(FILE_NAME)
			SELECT Single_File_Name
			FROM SYSIBM.SYSDUMMY1 WITH UR;
			
			
--			--	3. Re-add bull name and/or registry status to non-preferred ID (will make this later when clear the requirement)
--			SET v_RECORD_TYPE = 'P';		-- Based on the rule Change the preferred ID
--			
--			CALL usp_Submit_Format1_File
--			(
--				
--			);
			
   		END IF;
   END IF;
   


	-- For add new/ update cross reference:
	--		Add new animal: submit one file for each animal 
	--		Update animal: one file for each change on per animal
	SET v_COUNT = 1;
	SET v_NUM_ROW = (SELECT COUNT(ID) FROM SESSION.TmpCrossReferences);

	WHILE v_COUNT <= v_NUM_ROW DO
		SELECT	ID,
				ANIMAL_ID,
				NVL(ANIM_NAME, '                 '),
				SEX_CODE,
				MOD_DATE,
				NVL(REGIS_STATUS_CODE, '  '),
				ACTION
		INTO	v_CROSS_REF_ID,
				v_CROSS_REF_ANIMAIL_ID,
				v_CROSS_REF_LONG_NAME,
				v_CROSS_REF_SEX_CODE,
				v_CROSS_REF_MOD_DATE,
				v_CROSS_REF_REGIS_STATUS_CODE,
				v_CROSS_REF_ACTION
		FROM SESSION.TmpCrossReferences
		WHERE ID = v_COUNT;
		
		-- Add new an animal
		IF v_CROSS_REF_ACTION = 'ADD_NEW' THEN
			CALL usp_Submit_Format1_File
			(
				v_SPECIES_CODE,
				v_CROSS_REF_SEX_CODE,
				v_PREFERRED_ID,
	    				
				v_DB_SIRE_ID,
				v_DB_DAM_ID,
				v_CROSS_REF_ANIMAIL_ID,  
				v_DB_BIRTH_DATE,
				v_DB_SOURCE_CODE,
	   			v_PROCESSING_DATE,
	   			v_DEFAULT_RECORD_TYPE,
	  			v_PED_VERIFICATION,
	   			v_RECORD_VERSION,
	   			v_DB_MULTI_BIRTH_CODE,
	   			-- From cross reference on the WEB
	   			v_CROSS_REF_REGIS_STATUS_CODE,		
	   			v_ZEROES,
	   			-- From cross reference on the WEB
	   			v_CROSS_REF_LONG_NAME,
	   			
	   			v_GROUP_NAME,
	   			v_PARENTAGE_ONLY_IND,
	   			v_CDCB_FEE_PAID_CODE,
	   			v_HERD_REASON_CODE,
	   			Single_File_Name
			);
			
			INSERT INTO SESSION.TmpListFileName
			(FILE_NAME)
			SELECT Single_File_Name
			FROM SYSIBM.SYSDUMMY1 WITH UR;
		END IF;
		
		-- Update on an animal
		IF v_CROSS_REF_ACTION = 'UPDATE' THEN
			SELECT LONG_NAME, REGIS_STATUS_CODE
			INTO v_CROSS_REF_DB_LONG_NAME, v_CROSS_REF_DB_REGIS_STATUS_CODE
			FROM TABLE (fn_Get_Animal_Info_By_ID(v_CROSS_REF_ANIMAIL_ID, v_ANIM_KEY, v_SPECIES_CODE, v_SEX_CODE)) limit 1;
			
			-- For name of cross reference:
			IF v_CROSS_REF_LONG_NAME <> v_CROSS_REF_DB_LONG_NAME THEN
				CALL usp_Submit_Format1_File
				(
					v_SPECIES_CODE,
					v_CROSS_REF_SEX_CODE,
					v_PREFERRED_ID,
		    				
					v_DB_SIRE_ID,
					v_DB_DAM_ID,
					v_CROSS_REF_ANIMAIL_ID,  
					v_DB_BIRTH_DATE,
					v_DB_SOURCE_CODE,
		   			v_PROCESSING_DATE,
		   			v_DEFAULT_RECORD_TYPE,
		  			v_PED_VERIFICATION,
		   			v_RECORD_VERSION,
		   			v_DB_MULTI_BIRTH_CODE,
		   			v_CROSS_REF_DB_REGIS_STATUS_CODE,	
		   			v_ZEROES,
		   			-- From cross reference on the WEB
		   			v_CROSS_REF_LONG_NAME,
		   			
		   			v_GROUP_NAME,
		   			v_PARENTAGE_ONLY_IND,
		   			v_CDCB_FEE_PAID_CODE,
		   			v_HERD_REASON_CODE,
		   			Single_File_Name
				);
				
				INSERT INTO SESSION.TmpListFileName
				(FILE_NAME)
				SELECT Single_File_Name
				FROM SYSIBM.SYSDUMMY1 WITH UR;
				
			END IF;
			
			-- For Reg status of cross reference
			IF v_CROSS_REF_REGIS_STATUS_CODE <> v_CROSS_REF_DB_REGIS_STATUS_CODE THEN
				CALL usp_Submit_Format1_File
				(
					v_SPECIES_CODE,
					v_CROSS_REF_SEX_CODE,
					v_PREFERRED_ID,
		    				
					v_DB_SIRE_ID,
					v_DB_DAM_ID,
					v_CROSS_REF_ANIMAIL_ID,  
					v_DB_BIRTH_DATE,
					v_DB_SOURCE_CODE,
		   			v_PROCESSING_DATE,
		   			v_DEFAULT_RECORD_TYPE,
		  			v_PED_VERIFICATION,
		   			v_RECORD_VERSION,
		   			v_DB_MULTI_BIRTH_CODE,
		   			-- From cross reference on the WEB
		   			v_CROSS_REF_REGIS_STATUS_CODE,		
		   			v_ZEROES,
		   			v_CROSS_REF_DB_LONG_NAME,
		   			
		   			v_GROUP_NAME,
		   			v_PARENTAGE_ONLY_IND,
		   			v_CDCB_FEE_PAID_CODE,
		   			v_HERD_REASON_CODE,
		   			Single_File_Name
				);
				
				INSERT INTO SESSION.TmpListFileName
				(FILE_NAME)
				SELECT Single_File_Name
				FROM SYSIBM.SYSDUMMY1 WITH UR;
				
			-- End If of checking for Reg status
			END IF;
		--	End If of updating cross reference
		END IF;
		
		SET v_COUNT = v_COUNT + 1;
	-- End While for Add new/Update cross reference
	END WHILE;

	
	-- Collect files after submitting 
	SET Multi_File_Name = (select substr(xmlserialize(xmlagg(xmltext ( '
	   <File_Name>
			<Item>
				<Field>FILE_NAME</Field>
				<Value>'||FILE_NAME||'</Value>
			</Item>
		</File_Name>')  ) as VARCHAR(30000)),1)  
									   									 
	   FROM SESSION.TmpListFileName);
	   
	SET  Multi_File_Name =  REPLACE(Multi_File_Name,'&gt;','>');
	SET  Multi_File_Name =  REPLACE(Multi_File_Name,'&lt;','<');
	SET  Multi_File_Name =  REPLACE(Multi_File_Name,'&#xD;','
	 ');

	
	-- Log the changes with the status 'UNPROCESSED'
	INSERT INTO CHANGE_TRACKING_ANIMAL
	(
		ANIMAL_ID,
		ANIM_KEY,
		SPECIES_CODE,
		SEX_CODE,
		PREFERRED_ID,
		DETAIL_XML,
		STATUS,
		CREATE_TIME
	)
	VALUES
	(
		v_ANIMAL_ID,
		v_ANIM_KEY,
		v_SPECIES_CODE,
		v_SEX_CODE,
		v_PREFERRED_ID,
		'<?xml version="1.0" encoding="utf-8"?>
		<Inputs>
			<File_Names>' ||
				Multi_File_Name ||
			'</File_Names>
		</Inputs>',
		'UNPROCESSED',
		CURRENT TIMESTAMP
	);
	COMMIT;

	
	-- Get the status of processing
	SET v_IS_EDITABLE = fn_Check_Status_Changing_Animal(v_ANIMAL_ID, v_ANIM_KEY, v_SPECIES_CODE, v_SEX_CODE);

	BEGIN
	 	DECLARE cursor1 CURSOR WITH RETURN for
	 	-- Return the status as result
	 	SELECT v_IS_EDITABLE AS v_IS_EDITABLE
	 	FROM sysibm.sysdummy1 with UR;
	 	 
	 	OPEN cursor1;
	END;
	
	 	  			 
END