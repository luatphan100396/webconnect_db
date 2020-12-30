CREATE OR REPLACE PROCEDURE usp_Login_Reset_Password
--======================================================
--Author: Linh Pham
--Created Date: 2020-12-28
--Description: Get imformation of Reset password 
--Output:
--        +Ds1: 1 if success. Failed will raise exception
--======================================================
(
	@Inputs VARCHAR(1000)
)
	DYNAMIC RESULT SETS 1
	LANGUAGE SQL
P1: BEGIN
        --DECLARE VARIABLES
        DECLARE input_xml XML;
        DECLARE v_USER_NAME CHAR(128);
        DECLARE v_PASSWORD CHAR(128);
        
        --DECLARE TEMP TABLE
        DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpGetInputs 
        (
                Field      VARCHAR(128),
                Value       VARCHAR(1000)
        ) WITH REPLACE ON COMMIT PRESERVE ROWS;
        
        --SET VARIABLES
        SET input_xml =  xmlparse(document @Inputs);
        
        --INSERT TEMPTABLE FROM XMLTABLE
        INSERT INTO SESSION.TmpGetInputs 
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
                        Value       VARCHAR(1000)  PATH 'Value' 
                        ) AS XML_BOOKS;
        
        --SET VARIABLES
        SET v_USER_NAME = (SELECT VALUE FROM SESSION.TmpGetInputs WHERE UPPER(Field) ='USER_NAME' LIMIT 1 with UR);
        SET v_PASSWORD = (SELECT VALUE FROM SESSION.TmpGetInputs WHERE UPPER(Field) ='PASSWORD' LIMIT 1 with UR);
        
        --UPDATE PASSWORD
        UPDATE USER_ACCOUNT_TABLE 
        SET PASSWORD = v_PASSWORD 
        WHERE USER_NAME = v_USER_NAME;
        
        COMMIT;
	 	
BEGIN
        -- Declare cursor
        DECLARE cursor1 CURSOR WITH RETURN for

        SELECT 
        1 AS RESULT  
        FROM sysibm.sysdummy1;
-- Cursor left open for client application
	OPEN cursor1;
	END;
END P1 