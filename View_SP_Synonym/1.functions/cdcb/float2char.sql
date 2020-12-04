CREATE OR REPLACE FUNCTION FLOAT2CHAR
--======================================================
--Author: Nghi Ta
--Created Date: 2020-04-06
--Description: Parse float number to string
--======================================================
(numValue float, DECIMAL_ADJUST_CODE float)
RETURNS VARCHAR(30)
SPECIFIC FLOAT2CHAR
DETERMINISTIC
NO EXTERNAL ACTION
CONTAINS SQL
BEGIN ATOMIC
  DECLARE res VARCHAR(30);
   
  set res = trim(to_char(numValue, '999999999'||case when DECIMAL_ADJUST_CODE =0.01 then '.99'
													 when DECIMAL_ADJUST_CODE =0.1 then '.9'
													 else  ''  
												   end));
  set res = case when left(replace(res,'-',''),1) ='.' then  replace(res,'.','0.') else res end ;
   
  RETURN coalesce(res,'');
  

END

