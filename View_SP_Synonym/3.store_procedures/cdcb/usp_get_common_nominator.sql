 
CREATE OR REPLACE PROCEDURE usp_Get_Common_Nominator
 --================================================================================
--Author: Linh Pham
--Created Date: 2020-12-29
--Description: Get List SOURCE_NAME   
--Output: 
--       +Ds1: table with options used for search option
--=================================================================================
 (
 )
	DYNAMIC RESULT SETS 1
BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for

	SELECT 
		SOURCE_NAME 
		FROM DB2INST1.DATA_SOURCE_TABLE
		WHERE CLASS_CODE  = 'R'
		AND STATUS_CODE  = 'A' 
		ORDER BY SOURCE_NAME
		WITH UR;
		OPEN cursor1;
END 