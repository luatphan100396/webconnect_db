CREATE OR REPLACE FUNCTION HEX2INT
--======================================================
--Author: CDCB team
--Created Date: 2020-04-06
--Description:
--======================================================
(str VARCHAR(8))
RETURNS INTEGER
SPECIFIC HEX2INT
DETERMINISTIC
NO EXTERNAL ACTION
CONTAINS SQL
BEGIN ATOMIC
  DECLARE res INTEGER  DEFAULT 0;
  DECLARE pos INTEGER DEFAULT 1;
  DECLARE nibble CHAR(1);
  WHILE pos <= LENGTH(str) DO
    SET nibble = SUBSTR(str, pos, 1);
    SET res = BITOR(CASE WHEN BITAND(res, 134217728) != 0
                         THEN BITOR(16 * BITANDNOT(res, 134217728),
                                    -2147483648)
                         ELSE 16 * res END,
                    CASE nibble
                         WHEN '0' THEN 0
                         WHEN '1' THEN 1
                         WHEN '2' THEN 2
                         WHEN '3' THEN 3
                         WHEN '4' THEN 4
                         WHEN '5' THEN 5
                         WHEN '6' THEN 6
                         WHEN '7' THEN 7
                         WHEN '8' THEN 8
                         WHEN '9' THEN 9
                         WHEN 'A' THEN 10
                         WHEN 'a' THEN 10
                         WHEN 'B' THEN 11
                         WHEN 'b' THEN 11
                         WHEN 'C' THEN 12
                         WHEN 'c' THEN 12
                         WHEN 'D' THEN 13
                         WHEN 'd' THEN 13
                         WHEN 'E' THEN 14
                         WHEN 'e' THEN 14
                         WHEN 'F' THEN 15
                         WHEN 'f' THEN 15
                         ELSE RAISE_ERROR('78000', 'Not a hex string') 
                         END),
        pos = pos + 1;
  END WHILE;
  RETURN res;
END


