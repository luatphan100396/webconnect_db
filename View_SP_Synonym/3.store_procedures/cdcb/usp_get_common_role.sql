CREATE OR REPLACE PROCEDURE usp_Get_Common_Role
--================================================================================
--Author: Linh Pham
--Created Date: 2020-01-06
--Description: Get List role  
--Output: 
--       +Ds1: table with options used for Management
--=================================================================================
(
	
)
	DYNAMIC RESULT SETS 1
BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for

	SELECT  
		ROLE_NAME,
		ROLE_SHORT_NAME 
	FROM  ROLE_TABLE
	ORDER BY ROLE_SHORT_NAME
	WITH UR;
	OPEN cursor1;
END