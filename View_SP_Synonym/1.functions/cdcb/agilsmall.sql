CREATE OR REPLACE FUNCTION AGILSMALL
--======================================================
--Author: CDCB team
--Created Date: 2020-04-06
--Description:
--======================================================
(str VARCHAR(4))
RETURNS SMALLINT
SPECIFIC AGILSMALL
DETERMINISTIC NO EXTERNAL ACTION CONTAINS SQL
BEGIN ATOMIC
  DECLARE res SMALLINT  DEFAULT 0;
  SET res = HEX2SMALLINT(HEX(REVERSE(str)));
  RETURN res;
END


