CREATE OR REPLACE PROCEDURE usp_Get_Common_Nominator
 --================================================================================
--Author: Linh Pham
--Created Date: 2020-01-06
--Description: Get List Nominator
--Output: 
--       +Ds1: table with options used for Management Account
--=================================================================================
 (
	 @STATUS_CODE VARCHAR(1)
 )
	DYNAMIC RESULT SETS 1
BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for

	SELECT 
			TRIM(SOURCE_SHORT_NAME) AS NOMINATOR_SHORT_NAME
			,TRIM(SOURCE_NAME) AS NOMINATOR_NAME
			,'' as READ_PERMISSION
			,'' as WRITE_PERMISSION
			,ref.DESCRIPTION as STATUS
		FROM DATA_SOURCE_TABLE
		INNER JOIN REFERENCE_TABLE ref
			ON STATUS_CODE = ref.CODE
			AND ref.TYPE ='STATUS_CODE'
			AND (nullif(trim(@STATUS_CODE),'') IS NULL OR LOWER(@STATUS_CODE) = LOWER(STATUS_CODE))
		WHERE CLASS_CODE  = 'R'
		ORDER BY SOURCE_NAME
		WITH UR;
		OPEN cursor1;
END