CREATE OR REPLACE FUNCTION fn_Verified_UserName_EmailAddress
--======================================================
--Author: Nghi Ta
--Created Date: 2020-12-19
--Description: Check whether the input animal has cross referencfe
--======================================================
(
	@USER_NAME VARCHAR(128),
	@EMAIL_ADDRESS VARCHAR(200)
) 
RETURNS INTEGER

LANGUAGE SQL
BEGIN 
	DECLARE IS_MATCHED SMALLINT DEFAULT 0;
	
	SET IS_MATCHED = (SELECT case when COUNT(1)=1 then 1 else 0 end
					  from USER_ACCOUNT_TABLE uac
				      inner join USER_INFO_TABLE u
				           on u.USER_KEY = uac.USER_KEY
				       where uac.USER_NAME = @USER_NAME
				            and u.EMAIL_ADDR = @EMAIL_ADDRESS
								 );
 
	RETURN IS_MATCHED;
END