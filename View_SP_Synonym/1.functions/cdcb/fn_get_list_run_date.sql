CREATE OR REPLACE FUNCTION fn_Get_List_Run_Date
--======================================================
--Author: Nghi Ta
--Created Date: 2020-06-15
--Description: Get list run date
--list of value
--======================================================
(
  
) 
RETURNS TABLE (RUN_PDATE smallint, RUN_NAME varchar(30))

LANGUAGE SQL

RETURN

  SELECT  EVAL_PDATE, 
         VARCHAR_FORMAT(cast('1960-01-01' as date)+EVAL_PDATE,'Month YYYY') AS RUN_NAME       
  FROM (
         VALUES (21884),
		        (21762),
		        (21640)
    )t (EVAL_PDATE) 


