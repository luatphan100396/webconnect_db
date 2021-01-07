CREATE OR REPLACE PROCEDURE usp_Role_Get_List_Role
--================================================================================
--Author: Tuyen Nguyen
--Created Date: 2020-01-05
--Description: Get List Role  
--Output: 
--       +Ds1: table with list Role
--=================================================================================
 ()
	DYNAMIC RESULT SETS 1
P1: BEGIN
	-- Declare cursor
	DECLARE cursor1 CURSOR WITH RETURN for

	SELECT
			ROLE_SHORT_NAME,
			ROLE_NAME
	FROM ROLE_TABLE
	ORDER BY ROLE_NAME
	WITH UR;

	-- Cursor left open for client application
	OPEN cursor1;
END P1 