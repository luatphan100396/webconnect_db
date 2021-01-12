CREATE OR REPLACE PROCEDURE usp_Role_Add_Edit_Role 

--================================================================================
--Author: Tuyen Nguyen
--Created Date: 2021-01-05
--Description: Add New Role  
--Output: 
--       +Ds1: 1 if success. Failed will raise exception
--=================================================================================
(
  @INPUT VARCHAR(30000),
  @is_add_new char(1)
)
	DYNAMIC RESULT SETS 1 
	LANGUAGE SQL
P1: BEGIN
	-- Declare Variable
	DECLARE input_xml XML;
	
	DECLARE v_ROLE_SHORT_NAME VARCHAR(10);
	DECLARE v_ROLE_NAME VARCHAR(100); 
	DECLARE v_STATUS_CODE VARCHAR(1);
	DECLARE v_ROLE_KEY INTEGER;

	DECLARE v_FEATURE_KEY INTEGER;
--	DECLARE v_COMPONENT_NAME VARCHAR(200); 
	
	DECLARE SQLCODE INTEGER DEFAULT 0; 
    DECLARE RETCODE INTEGER DEFAULT 0;
	DECLARE ERR_MESSAGE VARCHAR(300);
	DECLARE V_CURRENT_TIME TIMESTAMP;
	
	-- Declare Temp table
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpGetInputs 
	(
		Field      VARCHAR(128),
		Value       VARCHAR(3000)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpFilterInputsMultiSelect 
	(
		Field      VARCHAR(128),
		Value       VARCHAR(128) 
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpFeatureInputsMultiSelect 
	(
		Field      VARCHAR(128),
		Value       VARCHAR(128) 
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpFeatures 
	(
		FEATURE_KEY      INTEGER 
	) WITH REPLACE ON COMMIT PRESERVE ROWS;

    DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpConponents 
	(
		COMPONENT_KEY      INTEGER 
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
	
	SET input_xml =  xmlparse(document @INPUT);
	
	--INSERT TEMP TABLE
	INSERT INTO SESSION.TmpGetInputs 
	(    
		Field,
		Value
	)
	 SELECT  
	 		nullif(trim(XML_BOOKS.field),''),
	 		nullif(trim(XML_BOOKS.value),'')	 
	FROM  
		XMLTABLE(
			'$doc/inputs/item' 
			PASSING input_xml AS "doc"
			COLUMNS 
			 
			Field      VARCHAR(128)  PATH 'field',
			Value       VARCHAR(3000)  PATH 'value' 
			) AS XML_BOOKS;
			
			
	INSERT INTO SESSION.TmpFilterInputsMultiSelect 
	(    
		Field,
		Value
	)
	 SELECT  
	 		nullif(trim(XML_BOOKS.field),''),
	 		nullif(trim(XML_BOOKS.value),'')	 
	FROM  
		XMLTABLE(
			'$doc/inputs/feature/multi_item/item/component/item' 
			PASSING input_xml AS "doc"
			COLUMNS 
			 
			Field      VARCHAR(128)  PATH 'field',
			Value       VARCHAR(3000)  PATH 'value' 
			) AS XML_BOOKS;
			
	INSERT INTO SESSION.TmpFeatureInputsMultiSelect 
	(    
		Field,
		Value
	)
	 SELECT  
	 		nullif(trim(XML_BOOKS.field),''),
	 		nullif(trim(XML_BOOKS.value),'')	 
	FROM  
		XMLTABLE(
			'$doc/inputs/feature/multi_item/item' 
			PASSING input_xml AS "doc"
			COLUMNS 
			 
			Field      VARCHAR(128)  PATH 'field',
			Value       VARCHAR(3000)  PATH 'value' 
			) AS XML_BOOKS;
			
	
	--Set variable
	SET v_ROLE_SHORT_NAME = (SELECT Value FROM SESSION.TmpGetInputs WHERE UPPER(Field) ='ROLE_NAME' LIMIT 1 with UR);
	SET v_ROLE_NAME = (SELECT VALUE FROM SESSION.TmpGetInputs WHERE UPPER(Field) ='DESCRIPTION' LIMIT 1 with UR);
	SET v_STATUS_CODE = (SELECT VALUE FROM SESSION.TmpGetInputs WHERE UPPER(Field) ='STATUS_CODE' LIMIT 1 with UR);
	 
	SET v_CURRENT_TIME = (SELECT CURRENT TIMESTAMP FROM SYSIBM.SYSDUMMY1);
	
	
   INSERT INTO SESSION.TmpConponents 
	(
		COMPONENT_KEY
	)
	SELECT VALUE
   FROM SESSION.TmpFilterInputsMultiSelect
   WHERE FIELD ='COMPONENT_KEY';
   
   
   INSERT INTO SESSION.TmpFeatures 
	(
		FEATURE_KEY
	)
	SELECT VALUE
   FROM SESSION.TmpFeatureInputsMultiSelect
   WHERE FIELD ='FEATURE_KEY';
   
	
	 
	    --INPUT VALIDATION
		IF  v_ROLE_SHORT_NAME IS NULL 
		   OR v_STATUS_CODE IS NULL 
		THEN
		 
	 	 SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'Input is not valid';
		
		END IF;
		
		IF @is_add_new = '1' THEN
		IF (select count(1) from ROLE_TABLE where ROLE_SHORT_NAME =v_ROLE_SHORT_NAME)>=1  
		THEN
		 
	 	 SET ERR_MESSAGE = 'Role "'|| v_ROLE_SHORT_NAME|| '" has already existed';
		SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = ERR_MESSAGE;
		
		END IF;
		END IF;

	SET v_ROLE_KEY = (SELECT ROLE_KEY
	                      FROM ROLE_TABLE
					      WHERE LOWER(ROLE_SHORT_NAME) = LOWER(v_ROLE_SHORT_NAME) ); 

	-- BEGIN TRANSACTION
	
	BEGIN
	
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
		SET retcode = SQLCODE;

        MERGE INTO ROLE_TABLE as A
			 using
			 ( 
				 SELECT coalesce(v_ROLE_KEY,-999999) as ROLE_KEY
				 FROM sysibm.sysdummy1  
			 )AS B
			 ON  A.ROLE_KEY = B.ROLE_KEY 
			 WHEN NOT MATCHED THEN
			INSERT 
			(  
			    ROLE_SHORT_NAME,
				ROLE_NAME,
				STATUS_CODE
			)
			VALUES
			(  
			    v_ROLE_SHORT_NAME,
				v_ROLE_NAME,
				v_STATUS_CODE  
			)
        WHEN MATCHED THEN UPDATE
        SET     
				ROLE_NAME=v_ROLE_NAME,
				STATUS_CODE=v_STATUS_CODE
		;
		--

				
		SET v_ROLE_KEY = (SELECT ROLE_KEY
	                      FROM ROLE_TABLE
					      WHERE ROLE_SHORT_NAME = v_ROLE_SHORT_NAME ); 
					      
					      
			 DELETE FROM ROLE_FEATURE_COMPONENT_TABLE u 
		     WHERE COMPONENT_KEY NOT IN (select t.COMPONENT_KEY  
								from SESSION.TmpConponents t
								inner join ROLE_FEATURE_COMPONENT_TABLE r
							        on t.COMPONENT_KEY = r.COMPONENT_KEY
		                     ) 
		        and u.ROLE_KEY = v_ROLE_KEY;
		        
		        
	         MERGE INTO  ROLE_FEATURE_COMPONENT_TABLE as A
			 using
			 ( 
		   			  SELECT t.COMPONENT_KEY
	                  FROM SESSION.TmpConponents t
			 )AS B
			 ON   A.COMPONENT_KEY = B.COMPONENT_KEY AND A.ROLE_KEY = v_ROLE_KEY
			 WHEN NOT MATCHED THEN
			 INSERT
			(  
				ROLE_KEY,
				COMPONENT_KEY,
				CREATED_TIME,
				MODIFIED_TIME 
			) 
			VALUES (
			    v_ROLE_KEY,
				B.COMPONENT_KEY, 
				v_CURRENT_TIME,
				v_CURRENT_TIME
			)
			WHEN MATCHED THEN UPDATE
			SET    
				MODIFIED_TIME = v_CURRENT_TIME  
		    ;
		 	    
 
 	END;
 	
 	
		IF RETCODE < 0 THEN
			ROLLBACK;
			
			SET ERR_MESSAGE = (SELECT SYSPROC.SQLERRM (CAST(RETCODE AS VARCHAR(20))) FROM SYSIBM.SYSDUMMY1);
			SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = ERR_MESSAGE;
		ELSE
			COMMIT;
			BEGIN
				DECLARE CURSOR1 CURSOR WITH RETURN FOR
				SELECT 1 AS RESULT
				FROM SYSIBM.SYSDUMMY1;
				
				OPEN CURSOR1;
			END;
		END IF;
END P1 