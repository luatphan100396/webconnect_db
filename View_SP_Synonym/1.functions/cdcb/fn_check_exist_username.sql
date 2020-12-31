CREATE OR REPLACE FUNCTION fn_Check_Exist_UserName
--======================================================
--Author: Nghi Ta
--Created Date: 2020-12-19
--Description: Check whether the input user name has been existed
--======================================================
(
	@USER_NAME VARCHAR(128) 
) 
RETURNS INTEGER

LANGUAGE SQL
BEGIN 
	DECLARE IS_EXISTED SMALLINT DEFAULT 0;
	
	SET IS_EXISTED = (SELECT case when COUNT(1)=1 then 1 else 0 end
					  from USER_ACCOUNT_TABLE uac 
				      where uac.USER_NAME = @USER_NAME 
					  );
 
	RETURN IS_EXISTED;
END