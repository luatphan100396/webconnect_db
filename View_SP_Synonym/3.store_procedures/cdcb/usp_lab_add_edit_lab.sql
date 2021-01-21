CREATE OR REPLACE PROCEDURE usp_Lab_Add_Edit_Lab
--======================================================
--Author: Tri Do
--Created Date: 2021-01-07
--Description: Add Edit lab
--Output:
--        +Ds1: 1 if success. Failed will raise exception
--======================================================
(
	@inputs VARCHAR(30000)
	,@is_add_new char(1)
)
	DYNAMIC RESULT SETS 10
	LANGUAGE SQL
P1: BEGIN
	DECLARE input_xml XML;
	
	DECLARE v_NEW_DATA_SOURCE_KEY INT;
	DECLARE v_DATA_SOURCE_KEY INT;
	DECLARE v_SOURCE_SHORT_NAME VARCHAR(12);
	DECLARE v_SOURCE_NAME VARCHAR(40);
	DECLARE v_STATUS_CODE VARCHAR(1);
	
	
	DECLARE v_CURRENT_TIME TIMESTAMP; 
	DECLARE SQLCODE INTEGER DEFAULT 0; 
    DECLARE RETCODE INTEGER DEFAULT 0;
    DECLARE ERR_MESSAGE VARCHAR(300);
  
     
     
     
  --  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  --  SET retcode = SQLCODE; 
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpGetinputs 
	(
		Field      VARCHAR(128),
		Value       VARCHAR(3000)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
    --- RETRIEVE INPUT
	SET input_xml =  xmlparse(document @inputs);
 
    INSERT INTO SESSION.TmpGetinputs 
		(    
			Field,
			Value
		)
		 SELECT  
				 nullif(trim(XML_BOOKS.Field),''),
				 nullif(trim(XML_BOOKS.Value),'')	 
		FROM  
			XMLTABLE(
				'$doc/inputs/item' 
				PASSING input_xml AS "doc"
				COLUMNS 
				 
				Field      VARCHAR(128)  PATH 'field',
				Value       VARCHAR(1000)  PATH 'value'
				) AS XML_BOOKS;
			
	SET v_NEW_DATA_SOURCE_KEY = (SELECT MAX(DATA_SOURCE_KEY) + 1 FROM DATA_SOURCE_TABLE with UR);
	SET v_DATA_SOURCE_KEY = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='DATA_SOURCE_KEY' LIMIT 1 with UR);
	SET v_SOURCE_SHORT_NAME = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='SOURCE_SHORT_NAME' LIMIT 1 with UR);
	SET v_SOURCE_NAME = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='SOURCE_NAME' LIMIT 1 with UR);
	SET v_STATUS_CODE = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='STATUS_CODE' LIMIT 1 with UR);
	
	SET v_CURRENT_TIME = (SELECT current timestamp  from sysibm.sysdummy1);
	
	-- INPUT VALIDATION
	IF  v_SOURCE_SHORT_NAME IS NULL
		OR v_SOURCE_NAME IS NULL
		OR v_STATUS_CODE IS NULL
		OR v_DATA_SOURCE_KEY IS NULL OR (@is_add_new='0' AND v_DATA_SOURCE_KEY = 0)
		
	THEN
		SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'Input is not valid';
	END IF;
	
	IF (SELECT fn_Check_Exist_Lab(v_SOURCE_SHORT_NAME,v_DATA_SOURCE_KEY) FROM SYSIBM.SYSDUMMY1) = 1
	THEN
		SET ERR_MESSAGE = 'Lab "'|| v_SOURCE_SHORT_NAME|| '" has already existed';
		SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = ERR_MESSAGE;
	END IF;
	
 
	 --BEGIN work:
 
 BEGIN  
 
     DECLARE EXIT HANDLER FOR SQLEXCEPTION
     SET RETCODE = SQLCODE;
     
		  MERGE INTO DATA_SOURCE_TABLE as dest
			using
			( 
				SELECT coalesce(v_DATA_SOURCE_KEY,v_NEW_DATA_SOURCE_KEY) as DATA_SOURCE_KEY
				FROM sysibm.sysdummy1
			)AS src
			ON  dest.DATA_SOURCE_KEY = src.DATA_SOURCE_KEY
			WHEN NOT MATCHED THEN
			INSERT
			(
				DATA_SOURCE_KEY
				,CLASS_CODE
				,HEALTH_SOURCE_CODE
				,SOURCE_SHORT_NAME
				,SOURCE_NAME
				,STATUS_CODE
				,WITHIN_CLASS_KEY
				,CDDR_IND
				,CONTACT_NAME
				,EMAIL_ADDR
				,PATH_ADDR
				,MODIFY_TIMESTAMP
				,COMMENT
			) 
			VALUES (
				v_NEW_DATA_SOURCE_KEY
				,'L'
				,''
				,v_SOURCE_SHORT_NAME
				,v_SOURCE_NAME
				,v_STATUS_CODE
				,0
				,''
				,''
				,''
				,''
				,v_CURRENT_TIME
				,''
			)
			WHEN MATCHED THEN UPDATE
			SET SOURCE_SHORT_NAME = 	v_SOURCE_SHORT_NAME,
				SOURCE_NAME = 			v_SOURCE_NAME,
				STATUS_CODE = 			v_STATUS_CODE,
				MODIFY_TIMESTAMP = 		v_CURRENT_TIME
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
						SELECT  1 AS RESULT
						FROM SYSIBM.SYSDUMMY1;
					 
						OPEN CURSOR1;
					END;
					
			 END IF;
END P1