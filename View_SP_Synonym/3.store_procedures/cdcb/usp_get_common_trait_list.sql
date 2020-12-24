CREATE OR REPLACE PROCEDURE usp_Get_Common_Trait_List
--====================================================================================
--Author: Linh Pham
--Created Date: 2020-12-14
--Description: Get trait list which available for each sex
--Output: 
--       +Ds1: table with trait short name, trait full name, unit and decimal adjust code
--=======================================================================================
(
)
  
  dynamic result sets 1
BEGIN
    
	-- TRAIT list   
	BEGIN
		DECLARE cursor5  CURSOR WITH RETURN for
		
		select 
			TRAIT, 
			trim(TRAIT_FULL_NAME) as TRAIT_FULL_NAME,  
			UNIT, 
			DECIMAL_ADJUST_CODE
		from
		table( fn_Get_List_traits())
		where TYPE IN ('TRAIT')
         order by OrderBy;
		OPEN cursor5;
		  
	END;
END