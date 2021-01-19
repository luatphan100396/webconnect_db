CREATE OR REPLACE FUNCTION fn_get_maintenance_color
--======================================================
--Author: Tri Do
--Created Date: 2021-01-14
--Description: Get maintenance color
--======================================================
(	 
) 
RETURNS VARCHAR(10000)

LANGUAGE SQL
BEGIN 
	DECLARE MAINTENANCE_COLOR VARCHAR(10000) ;
	
	SET MAINTENANCE_COLOR = (SELECT STRING_VALUE
							FROM SETTING_TABLE
							WHERE UPPER(NAME) = 'MAINTENANCE_COLOR'
					  );
 
	RETURN MAINTENANCE_COLOR;
END