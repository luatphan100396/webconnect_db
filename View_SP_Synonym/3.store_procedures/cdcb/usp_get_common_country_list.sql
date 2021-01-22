 CREATE OR REPLACE PROCEDURE usp_Get_Common_Country_List 
--================================================================================
--Author: Tuyen Nguyen
--Created Date: 2020-01-04
--Description: Get List Country  
--Output: 
--       +Ds1: table with list country
--=================================================================================
()
	DYNAMIC RESULT SETS 1
P1: BEGIN
	-- Declare cursor
	DECLARE cursor1 CURSOR WITH RETURN for
	SELECT
			COUNTRY_CODE,
			COUNTRY_NAME
	FROM COUNTRY_TABLE
	ORDER BY COUNTRY_CODE
	WITH UR;

	-- Cursor left open for client application
	OPEN cursor1;
END P1
