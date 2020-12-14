CREATE OR REPLACE PROCEDURE usp_Get_Common_Eval_Date_List
--====================================================================================================
--Author: Linh Pham
--Created Date: 2020-12-14
--Description: Get latest Eval Rundate which available for bull and cow
--Output: 
--       +Ds1: Breed table with breed code and breed name for following breeds: AY,WW,JE,HO,MS,GU,BS
--===================================================================================================
(
)
  
  dynamic result sets 1
BEGIN
     -- Eval Date list   
	BEGIN
		DECLARE cursor3  CURSOR WITH RETURN for
	    SELECT DISTINCT 
			    RUN_PDATE, 
			    UL_ALPHADT,
			    case when bFert.EVAL_PDATE is not null then 1 
			         else 0
			    end  IS_AVAILABLE_SCR
	    FROM 
	    (
	         select RUN_PDATE, UL_ALPHADT
	         from ENV_VAR_TABLE
	         with UR
	         
	    ) run
	    LEFT JOIN (
	             SELECT DISTINCT EVAL_PDATE 
	             FROM BULL_FERT_TABLE
	             ) bFert
	    ON run.RUN_PDATE = bFert.EVAL_PDATE
	    ORDER BY RUN_PDATE DESC with UR;
	    
		OPEN cursor3;
		  
	END;
	  
END


