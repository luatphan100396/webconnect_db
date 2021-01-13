CREATE OR REPLACE FUNCTION fn_Get_Total_New_Account_Request
--======================================================
--Author: Nghi Ta
--Created Date: 2020-12-19
--Description: Get new account request
--======================================================
(
	 
) 
RETURNS INTEGER

LANGUAGE SQL
BEGIN 
	DECLARE TOTAL_NEW_REQUEST INT DEFAULT 0;
	
	SET TOTAL_NEW_REQUEST = (SELECT COUNT(1)
								FROM ACCOUNT_REQUEST_TABLE 
								WHERE upper(STATUS) = 'NEW' 
								 );
	 
	
	RETURN TOTAL_NEW_REQUEST;
END