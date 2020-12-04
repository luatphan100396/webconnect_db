CREATE OR REPLACE PROCEDURE rpt_Get_Filter_4_Latest_Eval_Date_List
--====================================================================================================
--Author: Nghi Ta
--Created Date: 2020-05-12
--Description: Get latest Eval Rundate which available for bull and cow
--Output: 
--       +Ds1: Breed table with breed code and breed name for following breeds: AY,WW,JE,HO,MS,GU,BS
--===================================================================================================
(  )
  
  dynamic result sets 1
BEGIN
     -- Eval Date list   
	BEGIN
		DECLARE cursor3  CURSOR WITH RETURN for
	        SELECT RUN_PDATE, RUN_NAME
	        FROM TABLE (fn_Get_List_Run_Date())
	        ORDER BY RUN_PDATE DESC;
		OPEN cursor3;
		  
	END;
	  
END


