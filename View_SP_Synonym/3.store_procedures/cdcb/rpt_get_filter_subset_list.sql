CREATE OR REPLACE PROCEDURE rpt_Get_Filter_Subset_List
--================================================================================
--Author: Nghi Ta
--Created Date: 2020-05-13
--Description: Get subset list(defined by user) which use to filter evaluation data
--Output: 
--       +Ds1: table with options used for filter animals
--=================================================================================
(IN @SEX varchar(10))
  
  dynamic result sets 1
BEGIN

IF @SEX ='Male' then  
		-- Subset status list  
		BEGIN 
			DECLARE cursor4  CURSOR WITH RETURN for
		    
		    SELECT SUBSET_DESC,  SUBSET_CODE
		    FROM TABLE(fn_Get_List_Animal_Condition_Type())
		    WHERE lower(SUBSET_DESC) IN 
		        (lower('AI Status (A,F,G)'),
		        lower('Available (A,F,G + Animals with NAAB Code)'),
		        lower('Active AI Sire (A)'),
		        lower('Foreign (F)'),
		        lower('Genomically Tested (G)'),
		        lower('Natural Service Bulls (N)'),
		        lower('Collected (C)'),
		        lower('Progeny Test (P)'),
		        lower('Inactive (I)'),
		        lower('Unproven Bulls')
		        ); 
		 
			OPEN cursor4;
			  
		END;
	ELSE  
	
	-- Subset cow and heifer 
		BEGIN 
			DECLARE cursor41  CURSOR WITH RETURN for
		    
		     
		    SELECT SUBSET_DESC,  SUBSET_CODE
		    FROM TABLE(fn_Get_List_Animal_Condition_Type())
		    WHERE lower(SUBSET_DESC) IN 
		        (lower('Cows'),
		        lower('Heifers')
		        );  
			OPEN cursor41;
			  
		END;
	END IF;
	
	  
END


