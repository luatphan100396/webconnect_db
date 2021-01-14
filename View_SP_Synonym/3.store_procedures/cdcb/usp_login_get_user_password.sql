CREATE OR REPLACE PROCEDURE usp_Login_Get_User_Password
--======================================================
--Author: Linh Pham
--Created Date: 2020-12-29
--Description: Get user password
--Output:
--        +Ds1: Table with password
--======================================================
(
	IN @USER_NAME VARCHAR(128)
)
	DYNAMIC RESULT SETS 1
BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for

	SELECT  a.USER_KEY,
	        a.USER_NAME, 
	        a.PASSWORD 
	FROM  USER_ACCOUNT_TABLE a
	WHERE lower(USER_NAME) = lower(@USER_NAME)
	WITH UR;

	OPEN cursor1;
END 