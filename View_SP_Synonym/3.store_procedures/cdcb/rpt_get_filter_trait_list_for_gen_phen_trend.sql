CREATE OR REPLACE PROCEDURE rpt_Get_Filter_Trait_List_For_Gen_Phen_trend
--====================================================================================
--Author: Nghi Ta
--Created Date: 2020-05-12
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
			TRAIT_FULL_NAME, 
		    TYPE, 
			UNIT, 
			DECIMAL_ADJUST_CODE
		from
		table(fn_Get_List_traits())
		where TYPE IN ('TRAIT','INDEX','CT_TRAIT')
		and TRAIT IN ('NM$', 'CM$', 'FM$', 'GM$', 'Mlk', 'Fat', 'Pro', 'PL', 'SCS', 'DPR', 'HCR', 'CCR', 'LIV', 'CE', 'SB')
        order by OrderBy;
		OPEN cursor5;
		  
	END;
END