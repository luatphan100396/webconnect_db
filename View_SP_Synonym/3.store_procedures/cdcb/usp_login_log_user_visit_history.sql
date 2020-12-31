CREATE OR REPLACE PROCEDURE usp_Login_Log_User_Visit_History
--======================================================
--Author: Linh Pham
--Created Date: 2020-12-29
--Description: Create a log for user visit history
--Output:
--        +Ds1: 1 if success
--======================================================
(
	@inputs VARCHAR(30000)
)
	DYNAMIC RESULT SETS 1
BEGIN
	
	DECLARE input_xml XML;
	
	DECLARE v_USER_NAME VARCHAR(30);
	DECLARE v_IP_ADDRESS VARCHAR(20);
	DECLARE v_WEB_BROWSER VARCHAR(50);
	DECLARE v_DEVICE VARCHAR(50); 
	
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
				
				
	SET v_USER_NAME = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='USER_NAME' LIMIT 1 with UR);
	SET v_IP_ADDRESS = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='IP_ADDRESS' LIMIT 1 with UR);
	SET v_WEB_BROWSER = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='WEB_BROWSER' LIMIT 1 with UR);
	SET v_DEVICE = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='DEVICE' LIMIT 1 with UR);  
	
	-- INPUT VALIDATION
	IF  v_USER_NAME IS NULL 
		THEN
		 
	 	 SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'Input is not valid';
		
	 END IF;
	
	INSERT INTO USER_VISIT_HISTORY_TABLE
	( 
		USER_KEY,
		ACCESS_TIME,
		IP_ADDRESS,
		WEB_BROWSER,
		DEVICE 
	)
	SELECT u.USER_KEY,
	       current timestamp as ACCESS_TIME,
	       v_IP_ADDRESS AS IP_ADDRESS,
	       v_WEB_BROWSER AS WEB_BROWSER,
	       v_DEVICE AS DEVICE
	
	FROM USER_ACCOUNT_TABLE u
	WHERE USER_NAME = v_USER_NAME;
	
	 
	begin
		DECLARE cursor1 CURSOR WITH RETURN for
	
			select  1 as RESULT 
			from sysibm.sysdummy1;
	
		OPEN cursor1;
	end;
END 