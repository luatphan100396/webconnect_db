CREATE OR REPLACE FUNCTION fn_Check_Exist_EmailAddress
--======================================================
--Author: Nghi Ta
--Created Date: 2020-12-19
--Description: Check whether the input Email Address has been existed
--======================================================
(
	@EMAIL_ADDRESS VARCHAR(200)
) 
RETURNS INTEGER

LANGUAGE SQL
BEGIN 
	DECLARE IS_EXISTED SMALLINT DEFAULT 0;
	
	SET IS_EXISTED = (SELECT case when COUNT(1)>=1 then 1 else 0 end
					  from USER_INFO_TABLE   
				      where  lower(EMAIL_ADDR) = lower(@EMAIL_ADDRESS)  
					  );
 
	RETURN IS_EXISTED;
END