CREATE OR REPLACE PROCEDURE usp_Setting_Update_Setting
--================================================================================
--Author: Tri Do
--Created Date: 2021-01-15
--Description: Update Setting
--Output: 
--       +Ds1: 1 if success. Failed will raise exception
--=================================================================================
(
	@inputs VARCHAR(30000)
)
	DYNAMIC RESULT SETS 10
	LANGUAGE SQL
P1: BEGIN
	DECLARE input_xml XML;
	
	DECLARE v_MAINTENANCE_MODE INT;
	DECLARE v_MAINTENANCE_MESSAGE VARCHAR(10000);
	DECLARE v_MAINTENANCE_COLOR VARCHAR(10000);
	
	
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
			
	SET v_MAINTENANCE_MODE = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='MAINTENANCE_MODE' LIMIT 1 with UR);
	SET v_MAINTENANCE_MESSAGE = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='MAINTENANCE_MESSAGE' LIMIT 1 with UR);
	SET v_MAINTENANCE_COLOR = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='MAINTENANCE_COLOR' LIMIT 1 with UR);
 
	--BEGIN work:
 
BEGIN  
 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
	SET RETCODE = SQLCODE;
     
		UPDATE SETTING_TABLE
		SET INT_VALUE = v_MAINTENANCE_MODE
		WHERE UPPER(NAME) = 'MAINTENANCE_MODE';
		
		UPDATE SETTING_TABLE
		SET STRING_VALUE = v_MAINTENANCE_MESSAGE
		WHERE UPPER(NAME) = 'MAINTENANCE_MESSAGE';
		
		UPDATE SETTING_TABLE
		SET STRING_VALUE = v_MAINTENANCE_COLOR
		WHERE UPPER(NAME) = 'MAINTENANCE_COLOR';

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