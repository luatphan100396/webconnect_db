CREATE OR REPLACE FUNCTION LeftAlignWithChar
--======================================================
--Author: Nghi Ta
--Created Date: 2020-06-24
--Description: right alignment for text
--======================================================
(in stringValue  varchar(128), stringLength smallint, charRepeat char(1))
RETURNS VARCHAR(128)
SPECIFIC LeftAlignWithChar
DETERMINISTIC
NO EXTERNAL ACTION
CONTAINS SQL
BEGIN ATOMIC
  
  DECLARE res VARCHAR(128);
  set res = trim(coalesce(stringValue,'---'));
  set res =  left(res||repeat(charRepeat,stringLength),stringLength) ;
  
  RETURN res;
  

END