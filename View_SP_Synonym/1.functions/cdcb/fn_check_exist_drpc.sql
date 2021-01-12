CREATE OR REPLACE FUNCTION fn_Check_Exist_DRPC
--======================================================
--Author: Nghi Ta
--Created Date: 2020-12-19
--Description: Check whether the input DRPC has been existed
--======================================================
(
	@DRPC_SHORT_NAME VARCHAR(20),
	@DATA_SOURCE_KEY INT 
) 
RETURNS INTEGER

LANGUAGE SQL
BEGIN 
	DECLARE IS_EXISTED SMALLINT DEFAULT 0; 
	
	SET IS_EXISTED = (SELECT case when COUNT(1)>=1 then 1 else 0 end
					  from DATA_SOURCE_TABLE uac 
				      where lower(uac.SOURCE_SHORT_NAME) = lower(@DRPC_SHORT_NAME)
				             and CLASS_CODE = 'D'
				             and DATA_SOURCE_KEY <> @DATA_SOURCE_KEY
					  );
 
	RETURN IS_EXISTED;
END