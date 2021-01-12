CREATE OR REPLACE PROCEDURE usp_Get_Common_Component_Features
--====================================================================================
--Author: Linh Pham
--Created Date: 2020-01-07
--Description: Get Component Features use for add group administration
--Output: 
--       +Ds1: table with Component feature
--=======================================================================================
(
	IN @FEATURE_KEY INT
)
	DYNAMIC RESULT SETS 1
P1: BEGIN
	-- Declare cursor
	DECLARE cursor1 CURSOR WITH RETURN for
	SELECT
		f.FEATURE_KEY, 
		fc.COMPONENT_KEY, 
		fc.COMPONENT_NAME
	FROM FEATURE_COMPONENT_TABLE fc
	INNER JOIN FEATURE_TABLE f
			on fc.FEATURE_KEY = f.FEATURE_KEY
			where f.FEATURE_KEY = @FEATURE_KEY
			order by f.FEATURE_NAME, fc.COMPONENT_NAME
		WITH UR; 

	-- Cursor left open for client application
	OPEN cursor1;
END P1