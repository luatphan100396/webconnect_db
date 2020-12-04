CREATE OR REPLACE FUNCTION RightAlign
--======================================================
--Author: Nghi Ta
--Created Date: 2020-06-24
--Description: right alignment for text
--======================================================
(in stringValue  varchar(128), stringLength smallint)
RETURNS VARCHAR(128)
SPECIFIC RightAlign
DETERMINISTIC
NO EXTERNAL ACTION
CONTAINS SQL
BEGIN ATOMIC
  
  DECLARE res VARCHAR(128);
  set res = coalesce(nullif(trim(stringValue),''),'---');
  set res =  right(repeat(' ',stringLength)||res,stringLength) ;
  
  RETURN res;
  

END

