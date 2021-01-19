CREATE OR REPLACE FUNCTION fn_Check_Exist_Role
--======================================================
--Author: Tuyen Nguyen
--Created Date: 2021-01-12
--Description: Check whether the input Role has been existed
--======================================================
(
	@ROLE_SHORT_NAME VARCHAR(50),
	@ROLE_KEY INT 
) 
RETURNS INTEGER

LANGUAGE SQL
BEGIN 
	DECLARE IS_EXISTED SMALLINT DEFAULT 0; 

	SET IS_EXISTED = (SELECT case when COUNT(1)>=1 then 1 else 0 end
					  from ROLE_TABLE uac 
				      where lower(uac.ROLE_SHORT_NAME) = lower(@ROLE_SHORT_NAME) 
				             and ROLE_KEY <> @ROLE_KEY
					  );

	RETURN IS_EXISTED;
END 