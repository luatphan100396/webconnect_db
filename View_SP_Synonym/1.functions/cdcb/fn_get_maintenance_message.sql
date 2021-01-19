CREATE OR REPLACE FUNCTION fn_get_maintenance_message
--======================================================
--Author: Tri Do
--Created Date: 2021-01-14
--Description: Get maintenance message
--======================================================
(	 
) 
RETURNS VARCHAR(10000)

LANGUAGE SQL
BEGIN 
	DECLARE MAINTENANCE_MESSAGE VARCHAR(10000) ;
	
	SET MAINTENANCE_MESSAGE = (SELECT STRING_VALUE
							FROM SETTING_TABLE
							WHERE UPPER(NAME) = 'MAINTENANCE_MESSAGE'
					  );
 
	RETURN MAINTENANCE_MESSAGE;
END