CREATE OR REPLACE PROCEDURE rpt_Get_Filter_Subset_List_for_Comparison_Bull_Evaluation
--================================================================================
--Author: Nghi Ta
--Created Date: 2020-05-13
--Description: Get subset list(defined by user) used for comparision bull evaluation report
--Output: 
--       +Ds1: table with options used for filter animals
--=================================================================================
( )
  
  dynamic result sets 1
BEGIN
BEGIN 
			DECLARE cursor4  CURSOR WITH RETURN for
		     SELECT SUBSET_DESC,  SUBSET_CODE
		    FROM TABLE(fn_Get_List_Animal_Condition_Type())
		    WHERE lower(SUBSET_DESC) IN 
		        (lower('Active AI Bulls'),
		        lower('Genomic Young Bulls') 
		        )
		     	AND SUBSET_CODE <>'A_F'; 
		         
			OPEN cursor4;
			  
		END;
	  
END


