CREATE OR REPLACE FUNCTION fn_dataexchange_get_input_template
--======================================================
--Author: Nghi Ta
--Created Date: 2021-01-18
--Description: Get input tempate
--======================================================
(	 
  @TEMPLATE_NAME VARCHAR(200)
) 
RETURNS varchar(10000)

LANGUAGE SQL
BEGIN 
	DECLARE v_TEMPLATE_DETAIL varchar(10000); 
	 
	
	SET v_TEMPLATE_DETAIL = (select TEMPLATE_DETAIL from INPUT_FILE_TEMPLATE_TABLE WHERE lower(NAME) = lower(@TEMPLATE_NAME) limit 1);
	 
	RETURN v_TEMPLATE_DETAIL;
END