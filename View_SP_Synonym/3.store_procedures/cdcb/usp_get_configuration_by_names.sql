CREATE OR REPLACE PROCEDURE usp_get_configuration_by_names
--========================================================
--Author: Nghi Ta
--Created Date: 2020-05-12
--Description: Get configuration data per name
--Output:
--        +Ds1: Table with configuration name, value
--========================================================
(
	IN @CONFIG_NAMES VARCHAR(10000)
)
	DYNAMIC RESULT SETS 1
	LANGUAGE SQL
BEGIN
	    
    -- DS0: constant
     	begin
		 	DECLARE cursor0 CURSOR WITH RETURN for
		 		
		 	SELECT NAME AS CONFIG_NAME, INT_VALUE AS VALUE
		 	FROM dbo.CONSTANTS c
		 	INNER JOIN 
		 	(
		 	SELECT  ITEM FROM table(fn_Split_String ('Type_PTA_chart_min,Type_PTA_chart_max',','))
		 	)i
		 	ON c.NAME = i.ITEM with UR;
		 	
		 	OPEN cursor0;
		 	 
	   end;
	   
     
	    
END


