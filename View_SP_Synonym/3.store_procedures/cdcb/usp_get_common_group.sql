CREATE OR REPLACE PROCEDURE usp_Get_Common_Group
--================================================================================
--Author: Linh Pham
--Created Date: 2020-12-29
--Description: Get List GROUP_SHORT_NAME   
--Output: 
--       +Ds1: table with options used for search option
--=================================================================================
(
	
)
	DYNAMIC RESULT SETS 1
BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for

	SELECT  
		GROUP_SHORT_NAME 
	FROM  GROUP_TABLE
	WHERE GROUP_SHORT_NAME <> 'ADMIN'
	AND GROUP_SHORT_NAME <> 'PUBLIC'
	ORDER BY GROUP_SHORT_NAME
	WITH UR;
	OPEN cursor1;
END 