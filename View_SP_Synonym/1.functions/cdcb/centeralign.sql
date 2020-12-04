CREATE OR REPLACE FUNCTION CenterAlign
--======================================================
--Author: Nghi Ta
--Created Date: 2020-06-24
--Description: Center alignment for text
--======================================================
(stringValue  varchar(128), stringLength smallint)
RETURNS VARCHAR(128)
SPECIFIC CenterAlign
DETERMINISTIC
NO EXTERNAL ACTION
CONTAINS SQL
BEGIN ATOMIC
  DECLARE res VARCHAR(128);
  DECLARE padding smallint;
  set res = coalesce(nullif(trim(stringValue),''),'---');
  set  padding = round((stringLength - length(res))/2.0,0);  
  set res =   right(repeat(' ',padding)||res||repeat(' ',padding),stringLength) ; 
  RETURN res;
  

END

