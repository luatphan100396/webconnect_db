CREATE OR REPLACE PROCEDURE rpt_Get_Filter_Trait_Groups
--================================================================================
--Author: Nghi Ta
--Created Date: 2020-07-06
--Description: Get trait group list: Yield, SCS, L
--Output: 
--       +Ds1: table with country code and country name
--=================================================================================
( )
  
  dynamic result sets 1
BEGIN
BEGIN 
			DECLARE cursor4  CURSOR WITH RETURN for 
		     
		     SELECT  TRAIT_GROUP
			 FROM (
			    VALUES ('Yield'),
					    ('SCS'),
					    ('Longevity'),
					    ('Type'),
					    ('Calving Ease') 
					    
			    )t (TRAIT_GROUP);
		    
			OPEN cursor4;
			  
		END;
	  
END