 CREATE OR REPLACE PROCEDURE usp_Get_Common_Index_List
--================================================================================
--Author: Linh Pham
--Created Date: 2020-0-13
--Description: Get index list(defined by user)  
--Output: 
--       +Ds1: table with options used for filter animals
--=================================================================================
(
)
  
  dynamic result sets 1
BEGIN
    
	-- TRAIT list   
	BEGIN
		DECLARE cursor5  CURSOR WITH RETURN for
		
		select 
			TRAIT AS INDEX, 
			trim(TRAIT_FULL_NAME) as TRAIT_FULL_NAME,  
			UNIT, 
			DECIMAL_ADJUST_CODE
		from
		table( fn_Get_List_traits())
		where TYPE IN ('INDEX')
         order by OrderBy;
		OPEN cursor5;
		  
	END;
END
