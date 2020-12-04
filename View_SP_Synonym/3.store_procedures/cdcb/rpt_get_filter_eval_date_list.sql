CREATE OR REPLACE PROCEDURE rpt_Get_Filter_Eval_Date_List
--====================================================================================================
--Author: Nghi Ta
--Created Date: 2020-05-12
--Description: Get latest Eval Rundate which available for bull and cow
--Output: 
--       +Ds1: Breed table with breed code and breed name for following breeds: AY,WW,JE,HO,MS,GU,BS
--===================================================================================================
(
	IN @SEX VARCHAR(10)
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


