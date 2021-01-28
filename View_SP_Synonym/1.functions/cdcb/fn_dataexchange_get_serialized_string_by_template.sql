CREATE OR REPLACE FUNCTION fn_DataExchange_Get_Serialized_String_by_template
--======================================================
--Author: Nghi Ta
--Created Date: 2021-01-12
--Description: Get serialize string from json input template
--======================================================
(
    IN @LAST_ROW_ID varchar(5),
	@TEMPLATE_NAME VARCHAR(200) 
) 
RETURNS VARCHAR(10000)

LANGUAGE SQL
BEGIN 
	

    DECLARE v_TEMPLATE_DETAIL VARCHAR(10000); 

    SELECT TEMPLATE_DETAIL 
	        INTO v_TEMPLATE_DETAIL 
	FROM OUTPUT_FILE_TEMPLATE_TABLE WHERE NAME = @TEMPLATE_NAME LIMIT 1;
	  
	SET v_TEMPLATE_DETAIL= REPLACE(REPLACE(v_TEMPLATE_DETAIL,'<','''||trim(coalesce('),'>',',''''))||''');
	  
	RETURN v_TEMPLATE_DETAIL;
END