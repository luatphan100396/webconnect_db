CREATE OR REPLACE FUNCTION fn_Check_Exist_Nominator
--======================================================
--Author: Tri Do
--Created Date: 2021-01-13
--Description: Check whether the input Nominator has been existed
--======================================================
(
	@NOMINATOR_SHORT_NAME VARCHAR(20),
	@DATA_SOURCE_KEY INT 
) 
RETURNS INTEGER

LANGUAGE SQL
BEGIN 
	DECLARE IS_EXISTED SMALLINT DEFAULT 0; 
	
	SET IS_EXISTED = (SELECT case when COUNT(1)>=1 then 1 else 0 end
					  from DATA_SOURCE_TABLE uac 
				      where lower(uac.SOURCE_SHORT_NAME) = lower(@NOMINATOR_SHORT_NAME)
				             and CLASS_CODE = 'R'
				             and DATA_SOURCE_KEY <> @DATA_SOURCE_KEY
					  );
 
	RETURN IS_EXISTED;
END