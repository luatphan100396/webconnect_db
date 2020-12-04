CREATE OR REPLACE FUNCTION float2char_thsnd_format
--======================================================
--Author: CDCB team
--Created Date: 2020-04-06
--Description:
--======================================================
(numValue float, DECIMAL_ADJUST_CODE float)
RETURNS VARCHAR(30)
SPECIFIC float2char_thsnd_format
DETERMINISTIC
NO EXTERNAL ACTION
CONTAINS SQL
BEGIN ATOMIC
  DECLARE res VARCHAR(30);
  set res = trim(to_char(numValue, '999,999,999'||case when DECIMAL_ADJUST_CODE =0.01 then '.99'
													 when DECIMAL_ADJUST_CODE =0.1 then '.9'
													 else  ''  
												   end));
  set res = case when left(replace(res,'-',''),1) ='.' then  replace(res,'.','0.') else res end ;
  
  
  
  RETURN coalesce(res,'');
  

END

