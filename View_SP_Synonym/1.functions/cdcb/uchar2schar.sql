CREATE OR REPLACE FUNCTION uchar2schar
--======================================================
--Author: Nghi Ta
--Created Date: 2020-06-26
--Description: Cast unsigned char to signed char
--======================================================
(str char(1) for bit data)
RETURNS INTEGER
SPECIFIC uchar2schar
DETERMINISTIC NO EXTERNAL ACTION CONTAINS SQL
BEGIN ATOMIC
  DECLARE res INTEGER  DEFAULT 0;
  SET res = case when ascii(str) >127 then ascii(str)-256 else ascii(str) end;
  RETURN res;
END


