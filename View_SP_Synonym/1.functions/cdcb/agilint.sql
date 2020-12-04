CREATE OR REPLACE FUNCTION AGILINT
--======================================================
--Author: CDCB team
--Created Date: 2020-04-06
--Description:
--======================================================
(str VARCHAR(8))
RETURNS INTEGER
SPECIFIC AGILINT
DETERMINISTIC NO EXTERNAL ACTION CONTAINS SQL
BEGIN ATOMIC
  DECLARE res INTEGER  DEFAULT 0;
  SET res = HEX2INT(HEX(REVERSE(str)));
  RETURN res;
END


