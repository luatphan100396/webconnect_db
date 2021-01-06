 CREATE OR REPLACE PROCEDURE usp_Get_Common_Nominator
 --================================================================================
--Author: Linh Pham
--Created Date: 2020-01-06
--Description: Get List Nominator
--Output: 
--       +Ds1: table with options used for Management Account
--=================================================================================
 (
 )
	DYNAMIC RESULT SETS 1
BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for

	SELECT 
		SOURCE_SHORT_NAME AS NOMINATOR_SOURCE_SHORT_NAME
		,SOURCE_NAME AS NOMINATOR_SOURCE_NAME
		FROM DB2INST1.DATA_SOURCE_TABLE
		WHERE CLASS_CODE  = 'R'
		AND STATUS_CODE  = 'A' 
		ORDER BY SOURCE_NAME
		WITH UR;
		OPEN cursor1;
END 