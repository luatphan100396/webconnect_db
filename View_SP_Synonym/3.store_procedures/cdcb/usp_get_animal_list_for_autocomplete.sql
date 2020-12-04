CREATE OR REPLACE PROCEDURE usp_get_animal_list_for_autocomplete
--==========================================================================
--Author: Nghi Ta
--Created Date: 2020-05-12
--Description: Get list animal id which match with search
--parttern
--Output:
--        +Ds1: Table with top 10 animal ids which matched search parttern 
--==========================================================================
(
	IN @search_pattern VARCHAR(128),
	IN @page_number int,
	IN @row_per_page int, 
	IN @session_id varchar(500)
)
	DYNAMIC RESULT SETS 1
	LANGUAGE SQL
BEGIN
  
     DECLARE APPLICATION_HANDLE_LIST_NEED_KILL VARCHAR(200);
     DECLARE APPLICATION_HANDLE_CURRENT INT;
     DECLARE SQLCD varchar(10000);
       
        
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalResultAutocomplete 
	(
		INT_ID CHAR(17)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
	IF coalesce(@session_id,'')<>''
    THEN
		 SET APPLICATION_HANDLE_CURRENT = 
		(  select MAX(APPLICATION_HANDLE)
			from sysibmadm.mon_current_sql
			where stmt_text like '%'||@session_id||'%' 
			and ACTIVITY_TYPE IN ('WRITE_DML', 'CALL')
		 );
	       
	       
		SET APPLICATION_HANDLE_LIST_NEED_KILL = coalesce(
		(  select SUBSTR(xmlserialize(xmlagg(xmltext ( ','||APPLICATION_HANDLE )) as VARCHAR(30000)), 2) AS APPLICATION_HANDLE
			from sysibmadm.mon_current_sql
			where stmt_text like '%'||@session_id||'%' 
			and ACTIVITY_TYPE IN ('WRITE_DML', 'CALL')
			AND APPLICATION_HANDLE <> APPLICATION_HANDLE_CURRENT
			--AND ELAPSED_TIME_SEC >3*60
		 ),'');
	 
	
		IF APPLICATION_HANDLE_LIST_NEED_KILL<>''
		THEN  		 
		  CALL SYSPROC.ADMIN_CMD( 'FORCE APPLICATION('||APPLICATION_HANDLE_LIST_NEED_KILL||')');
		 END  IF;
     
   END IF;
  
   set @search_pattern = UPPER(@search_pattern);
   set SQLCD =  ' 
   insert into SESSION.TmpAnimalResultAutocomplete (INT_ID)
		 	SELECT INT_ID 
		 	FROM ID_XREF_TABLE
		 	WHERE INT_ID LIKE ''%'||@search_pattern||'%''
		 	AND length(trim(INT_ID))=17
		 	limit 10 with UR
		 		--'||@session_id||' mark session id here for kill previous request
		    
  		 ';

	BEGIN
		DECLARE cursor1  CURSOR WITH RETURN for
	    SELECT INT_ID AS ANIMAL_ID 
	    FROM SESSION.TmpAnimalResultAutocomplete with UR;
		OPEN cursor1;
  
	END;
  		 EXECUTE IMMEDIATE SQLCD;
END


