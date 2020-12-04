CREATE OR REPLACE PROCEDURE usp_get_user_password
--======================================================
--Author: Nghi Ta
--Created Date: 2020-04-06
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

	SELECT  a.PASSWORD 
	FROM  USERS a
	WHERE lower(USER_NAME) = lower(@USER_NAME)
	WITH UR;

	OPEN cursor1;
END



