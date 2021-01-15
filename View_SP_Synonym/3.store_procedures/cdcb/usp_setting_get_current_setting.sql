CREATE OR REPLACE PROCEDURE usp_Setting_Get_Current_Setting
--================================================================================
--Author: Tri Do
--Created Date: 2021-01-14
--Description: Get Current Setting
--Output: 
--       +Ds1: table with current setting
--=================================================================================
(
	
)
	DYNAMIC RESULT SETS 1
BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for

	SELECT NAME
		   ,CASE
				WHEN NAME = 'Maintenance_Mode' THEN CAST(int_value AS varchar(1))
				ELSE String_value
			END AS VALUE
	FROM SETTING_TABLE
	WITH UR;
	OPEN cursor1;
END