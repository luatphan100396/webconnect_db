CREATE OR REPLACE PROCEDURE usp_Group_Add_Edit_Group
--======================================================
--Author: Linh Pham
--Created Date: 2021-01-12
--Description: Add Edit Group
--Output:
--        +Ds1: 1 if success. Failed will raise exception
--======================================================
(
  @INPUT VARCHAR(30000),
  @is_add_new char(1)
)
	DYNAMIC RESULT SETS 10
	LANGUAGE SQL
P1: BEGIN
	-- Declare Variable
	DECLARE input_xml XML;
	
	DECLARE v_GROUP_SHORT_NAME VARCHAR(50);
	DECLARE v_GROUP_NAME VARCHAR(200); 
	DECLARE v_STATUS_CODE VARCHAR(1);
	DECLARE v_GROUP_KEY INTEGER;

	DECLARE v_FEATURE_KEY INTEGER;
	
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

    DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpConponents 
	(
		COMPONENT_KEY      INTEGER 
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpRestrictedField
	(
		FIELD_KEY      INTEGER 
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
			'$doc/inputs/multi_item/item' 
			PASSING input_xml AS "doc"
			COLUMNS 
			 
			Field      VARCHAR(128)  PATH 'field',
			Value       VARCHAR(3000)  PATH 'value' 
			) AS XML_BOOKS;
	--Set variable
	SET v_GROUP_SHORT_NAME = (SELECT Value FROM SESSION.TmpGetInputs WHERE UPPER(Field) ='GROUP_NAME' LIMIT 1 with UR);
	SET v_GROUP_NAME = (SELECT VALUE FROM SESSION.TmpGetInputs WHERE UPPER(Field) ='DESCRIPTION' LIMIT 1 with UR);
	SET v_STATUS_CODE = (SELECT VALUE FROM SESSION.TmpGetInputs WHERE UPPER(Field) ='STATUS_CODE' LIMIT 1 with UR);
	SET v_GROUP_KEY = (SELECT VALUE FROM SESSION.TmpGetInputs WHERE UPPER(Field) ='GROUP_KEY' LIMIT 1 with UR);
	
	SET v_CURRENT_TIME = (SELECT CURRENT TIMESTAMP FROM SYSIBM.SYSDUMMY1);
	
	
   INSERT INTO SESSION.TmpConponents 
	(
		COMPONENT_KEY
	)
	SELECT VALUE
   FROM SESSION.TmpFilterInputsMultiSelect
   WHERE FIELD ='COMPONENT_KEY';
   
   INSERT INTO SESSION.TmpRestrictedField
	(
		FIELD_KEY
	)
	SELECT VALUE
   FROM SESSION.TmpFilterInputsMultiSelect
   WHERE FIELD ='RESTRICTED_FIELD_KEY';
   

	    --INPUT VALIDATION
		IF  v_GROUP_SHORT_NAME IS NULL 
		   OR v_STATUS_CODE IS NULL
		   OR v_GROUP_KEY IS NULL 
		   OR (@is_add_new='0' AND v_GROUP_KEY = 0) 
		THEN
		 
	 	 SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'Input is not valid';
		
		END IF;
		
		
        IF (SELECT fn_Check_Exist_group(v_GROUP_SHORT_NAME,v_GROUP_KEY) FROM SYSIBM.SYSDUMMY1) = 1 
		THEN 
	 	   SET ERR_MESSAGE = 'Group "'|| v_GROUP_SHORT_NAME|| '" has already existed';
		   SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = ERR_MESSAGE;
		
		END IF;
		

	-- BEGIN TRANSACTION
	
	BEGIN
	
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		SET retcode = SQLCODE;

        MERGE INTO GROUP_TABLE as A
			 using
			 ( 
				 SELECT  v_GROUP_KEY as GROUP_KEY
				 FROM sysibm.sysdummy1  
			 )AS B
			 ON  A.GROUP_KEY = B.GROUP_KEY 
			 WHEN NOT MATCHED THEN
			INSERT 
			(  
			    GROUP_SHORT_NAME,
				GROUP_NAME,
				STATUS_CODE
			)
			VALUES
			(  
			    v_GROUP_SHORT_NAME,
				v_GROUP_NAME,
				v_STATUS_CODE  
			)
			
        WHEN MATCHED THEN UPDATE
        SET     GROUP_SHORT_NAME=v_GROUP_SHORT_NAME,
				GROUP_NAME=v_GROUP_NAME,
				STATUS_CODE=v_STATUS_CODE
		;

		--	GROUP_FEATURE_COMPONENT_TABLE
		     SET v_GROUP_KEY = (SELECT GROUP_KEY
	                          FROM GROUP_TABLE
					WHERE GROUP_SHORT_NAME = v_GROUP_SHORT_NAME ); 
					      
					      
			 DELETE FROM GROUP_FEATURE_COMPONENT_TABLE u 
		     WHERE COMPONENT_KEY NOT IN (select 
		     								t.COMPONENT_KEY  
											from SESSION.TmpConponents t
		                     			) 
	                AND u.GROUP_KEY = v_GROUP_KEY;
		        
		        
	         MERGE INTO  GROUP_FEATURE_COMPONENT_TABLE as A
			 using
			 ( 
		   			  SELECT t.COMPONENT_KEY
	                  FROM SESSION.TmpConponents t
			 )AS B
			 ON   A.COMPONENT_KEY = B.COMPONENT_KEY AND A.GROUP_KEY = v_GROUP_KEY
			 WHEN NOT MATCHED THEN
			 INSERT
			(  
				GROUP_KEY,
				COMPONENT_KEY,
				CREATED_TIME,
				MODIFIED_TIME 
			) 
			VALUES (
			        v_GROUP_KEY,
				B.COMPONENT_KEY, 
				v_CURRENT_TIME,
				v_CURRENT_TIME
			)
			WHEN MATCHED THEN UPDATE
			SET    
				MODIFIED_TIME = v_CURRENT_TIME  
		    ;
		    
		    
		    -- Add Restricted field
		    
		    IF(select count(1) from SESSION.TmpRestrictedField)>0 THEN
		    
		    
			    DELETE FROM GROUP_RESTRICTED_FIELD_TABLE u 
			     WHERE FIELD_KEY NOT IN (select 
			     								t.FIELD_KEY  
												from SESSION.TmpRestrictedField t
			                     			) 
		                AND u.GROUP_KEY = v_GROUP_KEY;
			        
			        
		         MERGE INTO  GROUP_RESTRICTED_FIELD_TABLE as A
				 using
				 ( 
			   			  SELECT t.FIELD_KEY
		                  FROM SESSION.TmpRestrictedField t
				 )AS B
				 ON   A.FIELD_KEY = B.FIELD_KEY AND A.GROUP_KEY = v_GROUP_KEY
				 WHEN NOT MATCHED THEN
				 INSERT
				(  
					GROUP_KEY,
					FIELD_KEY,
					CREATED_TIME,
					MODIFIED_TIME 
				) 
				VALUES (
				        v_GROUP_KEY,
					B.FIELD_KEY, 
					v_CURRENT_TIME,
					v_CURRENT_TIME
				)
				WHEN MATCHED THEN UPDATE
				SET    
					MODIFIED_TIME = v_CURRENT_TIME  
			    ;
		    
		    
		    END IF;
		    
		 	    
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