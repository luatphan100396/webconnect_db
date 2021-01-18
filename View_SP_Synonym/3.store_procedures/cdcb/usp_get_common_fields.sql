CREATE OR REPLACE PROCEDURE usp_Get_Common_Fields
--====================================================================================
--Author: Nghi Ta
--Created Date: 2021-01-14
--Description: Get List all Fields
--Output: 
--       +Ds1: table with fields
--=======================================================================================
( 
)
	DYNAMIC RESULT SETS 1
P1: BEGIN
	-- Declare cursor
	DECLARE cursor1 CURSOR WITH RETURN for
	SELECT 
		 COMPONENT_KEY,
		 FIELD_KEY, 
		 FIELD_NAME
	FROM FIELD_TABLE  
	order by COMPONENT_KEY,FIELD_NAME
	WITH UR; 

	-- Cursor left open for client application
	OPEN cursor1;
END P1