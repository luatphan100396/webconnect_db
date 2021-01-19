CREATE OR REPLACE FUNCTION fn_Check_Exist_Group
--======================================================
--Author: Linh Pham
--Created Date: 2021-01-13
--Description: Check whether the input Role has been existed
--======================================================
(
	@GROUP_SHORT_NAME VARCHAR(50),
	@GROUP_KEY INT 
) 
RETURNS INTEGER

LANGUAGE SQL
BEGIN 
	DECLARE IS_EXISTED SMALLINT DEFAULT 0; 

	SET IS_EXISTED = (SELECT case when COUNT(1)>=1 then 1 else 0 end
					  FROM GROUP_TABLE uac 
				      WHERE LOWER(uac.GROUP_SHORT_NAME) = LOWER(@GROUP_SHORT_NAME) 
				             and GROUP_KEY NOT IN @GROUP_KEY
					  );

	RETURN IS_EXISTED;
END