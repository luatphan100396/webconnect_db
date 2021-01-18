CREATE OR REPLACE PROCEDURE usp_Get_Common_Features
--====================================================================================
--Author: Linh Pham
--Created Date: 2020-01-07
--Description: Get Features use for add group administration
--Output: 
--       +Ds1: table with feature
--=======================================================================================
()
	DYNAMIC RESULT SETS 1
P1: BEGIN
	-- Declare cursor
	DECLARE cursor1 CURSOR WITH RETURN for
	SELECT 
		FEATURE_KEY,
		FEATURE_NAME
	FROM FEATURE_TABLE
	ORDER BY FEATURE_NAME
	with ur;

	-- Cursor left open for client application
	OPEN cursor1;
END P1