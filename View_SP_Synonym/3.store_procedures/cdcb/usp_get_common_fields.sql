CREATE OR REPLACE PROCEDURE usp_Get_Common_Fields_By_Component_Key
--====================================================================================
--Author: Nghi Ta
--Created Date: 2021-01-14
--Description: Get List Fields by Component Key 
--Output: 
--       +Ds1: table with fields
--=======================================================================================
(
    
	IN @COMPONENT_KEY INT
)
	DYNAMIC RESULT SETS 1
P1: BEGIN
	-- Declare cursor
	DECLARE cursor1 CURSOR WITH RETURN for
	SELECT 
		 FIELD_KEY, 
		 FIELD_NAME
	FROM FIELD_TABLE 
	WHERE  COMPONENT_KEY = @COMPONENT_KEY 	
	order by FIELD_NAME
		WITH UR; 

	-- Cursor left open for client application
	OPEN cursor1;
END P1