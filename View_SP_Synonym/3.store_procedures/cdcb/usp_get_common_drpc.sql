CREATE OR REPLACE PROCEDURE usp_Get_Common_DRPC
 --================================================================================
--Author: Linh Pham
--Created Date: 2020-01-06
--Description: Get List DRPC   
--Output: 
--       +Ds1: table with options used for Management Account
--=================================================================================
 (
 )
	DYNAMIC RESULT SETS 1
BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for

	SELECT 
			trim(SOURCE_SHORT_NAME) AS DRPC_SOURCE_SHORT_NAME
			,trim(SOURCE_NAME) AS DRPC_SOURCE_NAME
			,'' as READ_PERMISSION
			,'' as WRITE_PERMISSION
		FROM DB2INST1.DATA_SOURCE_TABLE
		WHERE SOURCE_SHORT_NAME in ('CA','WI','NC','UT') 
		ORDER BY SOURCE_NAME
		WITH UR;
		OPEN cursor1;
END 