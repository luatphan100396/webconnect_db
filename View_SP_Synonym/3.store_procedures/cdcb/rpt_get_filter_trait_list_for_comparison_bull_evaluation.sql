CREATE OR REPLACE PROCEDURE rpt_Get_Filter_Trait_List_For_Comparison_Bull_Evaluation
--====================================================================================
--Author: Nghi Ta
--Created Date: 2020-05-12
--Description: Get trait list which available for each sex
--Output: 
--       +Ds1: table with trait short name, trait full name, unit and decimal adjust code
--=======================================================================================
(
	IN @SEX VARCHAR(10)
)
  
  dynamic result sets 1
BEGIN
    
	-- TRAIT list   
	BEGIN
		DECLARE cursor5  CURSOR WITH RETURN for
		
		select 
			TRAIT, 
			TRAIT_FULL_NAME, 
		    TYPE, 
			UNIT, 
			DECIMAL_ADJUST_CODE
		from
		table(fn_Get_List_traits())
		where TYPE IN ('TRAIT','INDEX','YIELD_IDTRS')  
         and ( (@SEX ='Female' and  TRAIT <>'SCR') or @SEX ='Male'  ) 
         order by OrderBy;
		OPEN cursor5;
		  
	END;
END