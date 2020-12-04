CREATE OR REPLACE PROCEDURE usp_get_user_info 
--======================================================
--Author: Nghi Ta
--Created Date: 2020-04-06
--Description: Get user role information
--Output:
--        +Ds1: Table with user name, password, roles
--======================================================
(
	IN @USER_NAME VARCHAR(128)
)
	DYNAMIC RESULT SETS 1
BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for

	SELECT 
		a.USER_NAME
		,a.PASSWORD
		,SUBSTR(xmlserialize(xmlagg(xmltext ( ','||b.ROLE )) as VARCHAR(30000)), 2) AS ROLE
	FROM dbo.USERS a
	INNER JOIN dbo.USER_ROLES b on a.USER_NAME = b.USER_NAME
	WHERE a.USER_NAME = @USER_NAME
	GROUP BY a.USER_NAME, a.PASSWORD
	WITH UR;

	OPEN cursor1;
END



