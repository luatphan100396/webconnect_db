CREATE OR REPLACE PROCEDURE rpt_Get_Filter_Subset_List_for_Comparison_Gen_Trad_Evaluation
--================================================================================
--Author: Nghi Ta
--Created Date: 2020-05-13
--Description: Get subset list(defined by user) used for comparision bull evaluation report
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
		    
		    SELECT case when SUBSET_DESC ='Active AI Bulls' then 'Active Bulls' else SUBSET_DESC end as SUBSET_DESC,  
			       SUBSET_CODE
		    FROM TABLE(fn_Get_List_Animal_Condition_Type())
		    WHERE lower(SUBSET_DESC) IN 
		        (lower('Active AI Bulls'),
		        lower('Proven Bulls'),
		        lower('Young Available Bulls'),
		        lower('Young Bulls')
		        )
		         and SUBSET_CODE<>'A'
		        ;  
		  
			OPEN cursor4;
			  
		END;
	ELSE  
	
	-- Subset cow and heifer 
		BEGIN 
			DECLARE cursor4  CURSOR WITH RETURN for
		   
		    SELECT SUBSET_DESC,  SUBSET_CODE
		    FROM TABLE(fn_Get_List_Animal_Condition_Type())
		    WHERE lower(SUBSET_DESC) IN 
		        (lower('Cows'),
		        lower('Heifers') 
		        );  
		     
			OPEN cursor4;
			  
		END;
	END IF;
	
END


