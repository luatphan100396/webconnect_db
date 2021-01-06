CREATE OR REPLACE PROCEDURE usp_Get_Common_Role
--================================================================================
--Author: Linh Pham
--Created Date: 2020-01-06
--Description: Get List role  
--Output: 
<<<<<<< HEAD
<<<<<<< HEAD
--       +Ds1: table with options used for Management account
=======
--       +Ds1: table with options used for Management
>>>>>>> CDCB_S04_B02_DB
=======
--       +Ds1: table with options used for Management
>>>>>>> CDCB_S04_B02_DB_Linh
--=================================================================================
(
	
)
	DYNAMIC RESULT SETS 1
BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for

	SELECT  
<<<<<<< HEAD
<<<<<<< HEAD
		ROLE_SHORT_NAME 
		,ROLE_NAME
=======
		ROLE_NAME,
		ROLE_SHORT_NAME 
>>>>>>> CDCB_S04_B02_DB
=======
		ROLE_NAME,
		ROLE_SHORT_NAME 
>>>>>>> CDCB_S04_B02_DB_Linh
	FROM  ROLE_TABLE
	ORDER BY ROLE_SHORT_NAME
	WITH UR;
	OPEN cursor1;
END