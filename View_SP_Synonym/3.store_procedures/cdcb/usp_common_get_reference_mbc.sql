CREATE OR REPLACE PROCEDURE usp_Common_Get_Reference_MBC
--====================================================================================
--Author: Trong Le
--Created Date: 2020-09-23
--Description: Get the list of Multi birth code
--Output: 
--       +Ds1: Return the list of multiple birth code
--=======================================================================================
(
)
	DYNAMIC RESULT SETS 1
BEGIN
	-- MBC list
	BEGIN
		DECLARE cursor1 CURSOR WITH RETURN for
		
		SELECT
			CODE,
			DESCRIPTION
		FROM REFERENCE_TABLE
		WHERE TYPE = 'MBC'
		WITH UR;
		
		OPEN cursor1;
	END;
END