CREATE OR REPLACE PROCEDURE usp_DataExchange_Submit_Request
--======================================================
--Author: Nghi Ta
--Created Date: 2020-12-14
--Description: create data exchange request
--birth date, cross reference...
--Output: 
--        +Ds Animal information: INT ID, name, birth date, sex, MBC, REG, SRC...
--======================================================
(    
	IN @INPUT varchar(3000)
)
	DYNAMIC RESULT SETS 1
P1: BEGIN
 
    DECLARE v_USER_NAME VARCHAR(128);
    DECLARE v_IP_ADDRESS VARCHAR(30);
    DECLARE v_INPUT_PATH VARCHAR(3000);
    DECLARE v_USER_KEY INT;
    DECLARE v_REQUEST_NAME VARCHAR(300);
    DECLARE v_MAX_REQUEST_KEY INT;
     
    DECLARE v_REQUES_DETAIL VARCHAR(3000);
     
    DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpGetinputs 
	(
		Field      VARCHAR(128),
		Value       VARCHAR(3000)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
 	
 	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpFilterinputsMultiSelect 
	(
		Field      VARCHAR(128),
		Value       VARCHAR(128),
		Order  smallint  GENERATED BY DEFAULT AS IDENTITY  (START WITH 1 INCREMENT BY 1)  
	) WITH REPLACE ON COMMIT PRESERVE ROWS; 
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpQUERY
	(
		ROW_ID  smallint  GENERATED BY DEFAULT AS IDENTITY  (START WITH 1 INCREMENT BY 1),
		QUERY_NAME VARCHAR(300) 
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
			
	INSERT INTO SESSION.TmpFilterinputsMultiSelect 
		(    
			Field,
			Value
		)
	SELECT  
			 nullif(trim(XML_BOOKS.Field),'') as Field,
			 nullif(trim(XML_BOOKS.Value),'') as Value 
	FROM  
		XMLTABLE(
			'$doc/inputs/multi_item/item' 
			PASSING input_xml AS "doc"
			COLUMNS 
			 
			Field      VARCHAR(128)  PATH 'field',
			Value       VARCHAR(1000)  PATH 'value' 
			) AS XML_BOOKS;
			
	
	SET v_USER_NAME = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='USER_NAME' LIMIT 1 with UR); 
 	SET v_IP_ADDRESS = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='IP_ADDRESS' LIMIT 1 with UR); 
 	SET v_INPUT_PATH = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='INPUT_PATH' LIMIT 1 with UR); 
 	
	INSERT INTO SESSION.TmpQUERY
	(
	QUERY_NAME
	)
	SELECT Value
	FROM SESSION.TmpFilterinputsMultiSelect 
	WHERE Field ='QUERY'
	;
	
	
     
     -- INPUT VALIDATION
	IF   v_USER_NAME IS NULL
		OR v_INPUT_PATH IS NULL
		OR  (select count(1) from SESSION.TmpQUERY) =0 
	THEN
	 
 	 SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'Input is not valid';
	
	END IF;  
    
     
    SET v_USER_KEY= ( select USER_KEY
				  from USER_ACCOUNT_TABLE
				  where lower(user_name) = lower(@USER_NAME)
	            );
	             
    SET v_MAX_REQUEST_KEY =  (  select max(REQUEST_KEY) from DATA_EXCHANGE_REQUEST_TABLE) ;
    SET v_REQUEST_NAME = (  select varchar_format(current date,'yyyy_Month_dd') from sysibm.sysdummy1) || cast(v_MAX_REQUEST_KEY as varchar(10));
    
    SET v_REQUES_DETAIL =
    '<?xml version="1.0" encoding="utf-8"?>
<inputs>'
    ||
     (
    select  substr(xmlserialize(xmlagg(xmltext (  '
    <item>
                <field>QUERY</field>
                <value>'||QUERY||'</value>
    </item> 
    '
		 									                                         )  ) as VARCHAR(30000)),1)   
    from  SESSION.TmpQUERY)
 ||'</inputs>'
    ;
    
    
    
 INSERT INTO DATA_EXCHANGE_REQUEST_TABLE
 (
	 
	 USER_KEY,
	 REQUEST_NAME,
	 INPUT_PATH,
	 REQUEST_DETAIL,
	 STATUS,
	 IP_ADRESS,
	 CREATED_TIME 
 )
 VALUES (
 v_USER_KEY,
 v_REQUEST_NAME,
 v_INPUT_PATH,
 v_REQUES_DETAIL,
'New',
v_IP_ADDRESS,
current timestamp 
 );
 
    
    DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpInput 
	(
		INPUT      VARCHAR(128) 
	) WITH REPLACE ON COMMIT PRESERVE ROWS; 
 
 
   DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpInputAnimals 
	(
		ANIMAL_ID      VARCHAR(128),
		Order  smallint  GENERATED BY DEFAULT AS IDENTITY  (START WITH 1 INCREMENT BY 1)  
	) WITH REPLACE ON COMMIT PRESERVE ROWS; 
 
 
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "'||@file_path||'" OF DEL INSERT INTO TmpInput' );


begin
     declare c1 cursor with return for
       select * from SESSION.TmpInputAnimals ;
     
     open c1;
end;
 	  			
 	  			
  
END P1