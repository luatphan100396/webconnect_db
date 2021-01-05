CREATE OR REPLACE PROCEDURE usp_Account_Get_Request_List 
--======================================================
--Author: Tri Do
--Created Date: 2021-01-04
--Description: Get Request list
--Output:
--        +Ds1: list from search option
--======================================================
(
	@Inputs VARCHAR(30000),
	IN @page_number INT,
	IN @row_per_page INT
)
	DYNAMIC RESULT SETS 10
P1: BEGIN
	DECLARE input_xml XML;
	DECLARE v_SEARCH_BY VARCHAR(128);
	
	--DECLARE TEMPLATE
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpGetInputs 
	(
		Field      VARCHAR(128),
		Value       VARCHAR(3000)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	--INSERT TEMP TABLE
	SET input_xml =  xmlparse(document @Inputs);

	----- insert
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
			
	--SET VARIABLES
     
	SET v_SEARCH_BY= (SELECT LOWER(VALUE) FROM SESSION.TmpGetInputs WHERE UPPER(Field) ='SEARCH_BY' LIMIT 1 with UR);
	
	BEGIN
	-- Declare cursor
	DECLARE cursor1 CURSOR WITH RETURN for
		
		SELECT
			aReqTable.REQUEST_KEY,
			aReqTable.USER_NAME,
			aReqTable.FIRST_NAME,
			aReqTable.LAST_NAME,
			aReqTable.EMAIL_ADDR,
			aReqTable.PHONE,
			aReqTable.ORGANIZATION,
			aReqTable.TITLE,
			aReqTable.STATUS
		FROM ACCOUNT_REQUEST_TABLE aReqTable
		WHERE 	
			(v_SEARCH_BY IS NULL 
				OR ( LOWER(aReqTable.USER_NAME) LIKE '%'||v_SEARCH_BY||'%'
						OR LOWER(aReqTable.EMAIL_ADDR) LIKE '%'||v_SEARCH_BY||'%'
						OR LOWER(aReqTable.FIRST_NAME) LIKE '%'||v_SEARCH_BY||'%'
						OR LOWER(aReqTable.ORGANIZATION) LIKE '%'||v_SEARCH_BY||'%'
					)
			)
		ORDER BY aReqTable.USER_NAME DESC
		LIMIT @row_per_page
		OFFSET (@page_number-1)*@row_per_page
		WITH UR;
		    
	-- Cursor left open for client application
	OPEN cursor1;
	END;

	BEGIN
		DECLARE cursor2 CURSOR WITH RETURN FOR 	
		SELECT count(1) as Num_Recs
		FROM ACCOUNT_REQUEST_TABLE aReqTable
		WHERE 	
			(v_SEARCH_BY IS NULL 
				OR ( LOWER(aReqTable.USER_NAME) LIKE '%'||v_SEARCH_BY||'%'
						OR LOWER(aReqTable.EMAIL_ADDR) LIKE '%'||v_SEARCH_BY||'%'
						OR LOWER(aReqTable.FIRST_NAME) LIKE '%'||v_SEARCH_BY||'%'
						OR LOWER(aReqTable.ORGANIZATION) LIKE '%'||v_SEARCH_BY||'%'
					)
			)
		WITH UR; 
	
	OPEN cursor2;
   	END;
END P1