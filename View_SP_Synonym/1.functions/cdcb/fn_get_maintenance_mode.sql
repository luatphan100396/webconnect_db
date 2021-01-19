CREATE OR REPLACE FUNCTION fn_get_maintenance_mode
--======================================================
--Author: Tri Do
--Created Date: 2021-01-14
--Description: Get maintenance mode
--======================================================
(	 
) 
RETURNS VARCHAR(1)

LANGUAGE SQL
BEGIN 
	DECLARE MAINTENANCE_MODE VARCHAR(1) ;
	
	SET MAINTENANCE_MODE = (SELECT INT_VALUE
							FROM SETTING_TABLE
							WHERE UPPER(NAME) = 'MAINTENANCE_MODE'
					  );
 
	RETURN MAINTENANCE_MODE;
END