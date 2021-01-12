CREATE OR REPLACE PROCEDURE usp_Get_Common_Status
--====================================================================================
--Author: Linh Pham
--Created Date: 2020-01-07
--Description: Get Status use for add group administration
--Output: 
--       +Ds1: table with STATUS_CODE
--=======================================================================================
()
	DYNAMIC RESULT SETS 1
P1: BEGIN
	-- Declare cursor
	DECLARE cursor1 CURSOR WITH RETURN for
		SELECT  CODE AS STATUS_CODE,
			    DESCRIPTION as STATUS
		FROM REFERENCE_TABLE
		WHERE TYPE ='STATUS_CODE'
		ORDER BY DESCRIPTION
	with ur;

	-- Cursor left open for client application
	OPEN cursor1;
END P1