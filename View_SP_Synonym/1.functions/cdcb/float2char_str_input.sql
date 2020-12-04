CREATE OR REPLACE FUNCTION FLOAT2CHAR_STR_INPUT
--======================================================
--Author: Nghi Ta
--Created Date: 2020-04-06
--Description: Parse float number to string
--======================================================
(strValue varchar(20),DECIMAL_MULTIPLY_CODE float, DECIMAL_ADJUST_CODE float)
RETURNS VARCHAR(30)
SPECIFIC FLOAT2CHAR_STR_INPUT
DETERMINISTIC
NO EXTERNAL ACTION
CONTAINS SQL
BEGIN ATOMIC
  DECLARE res VARCHAR(30);
  
  DECLARE regrex_number varchar(20) default ' 0123456789';
  DECLARE numValue float ;
  IF LENGTH(RTRIM(TRANSLATE(strValue, '*', regrex_number))) = 0 THEN
   
   set  numValue = cast(strValue as float)*DECIMAL_MULTIPLY_CODE;
   set res = FLOAT2CHAR(numValue,DECIMAL_ADJUST_CODE);
																															                   
  ELSE 
     SET res= strValue;
  
  END IF;
  RETURN res;
  

END
