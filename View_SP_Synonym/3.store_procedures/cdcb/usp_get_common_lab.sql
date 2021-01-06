 CREATE OR REPLACE PROCEDURE usp_Get_Common_Lab
 --================================================================================
--Author: Linh Pham
<<<<<<< HEAD
--Created Date: 2020-1-6
=======
--Created Date: 2020-01-06
>>>>>>> CDCB_S04_B02_DB_Linh
--Description: Get List Lab   
--Output: 
--       +Ds1: table with options used for Management Account
--=================================================================================
 (
 )
	DYNAMIC RESULT SETS 1
BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for

	SELECT 
<<<<<<< HEAD
		SOURCE_SHORT_NAME AS LAB_SOURCE_SHORT_NAME
		,SOURCE_NAME AS LAB_SOURCE_NAME
		FROM DB2INST1.DATA_SOURCE_TABLE
		WHERE CLASS_CODE  = 'L'
		AND STATUS_CODE  = 'A' 
=======
		SOURCE_NAME,
		SOURCE_SHORT_NAME 
		FROM DB2INST1.DATA_SOURCE_TABLE
		WHERE CLASS_CODE  = 'L'
		AND STATUS_CODE  = 'N' 
>>>>>>> CDCB_S04_B02_DB_Linh
		ORDER BY SOURCE_NAME
		WITH UR;
		OPEN cursor1;
END 