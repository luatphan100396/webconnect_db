CREATE OR REPLACE FUNCTION STR2INT
--======================================================
--Author: CDCB team
--Created Date: 2020-04-06
--Description:
--======================================================
(vstr VARCHAR(4))
RETURNS INTEGER
SPECIFIC STR2INT
DETERMINISTIC
NO EXTERNAL ACTION
CONTAINS SQL
BEGIN ATOMIC
  DECLARE res INTEGER  DEFAULT 0;
  DECLARE pos INTEGER DEFAULT 1;
  DECLARE val1 INTEGER DEFAULT 0;
  DECLARE val2 INTEGER DEFAULT 0;
  DECLARE nibble CHAR(1);
  DECLARE HEXSTR VARCHAR(8) DEFAULT '';
  DECLARE REVSTR, RESTSTR VARCHAR(4000) DEFAULT '';
  DECLARE LEN INT;

  IF vstr IS NULL THEN
    RETURN NULL;
  END IF;

  SET (RESTSTR, LEN) = (vstr, LENGTH(vstr));
  WHILE LEN > 0 DO
    SET (REVSTR, RESTSTR, LEN)
       = (SUBSTR(RESTSTR, 1, 1) CONCAT REVSTR,
       SUBSTR(RESTSTR, 2, LEN - 1),
       LEN - 1);

  END WHILE;

  IF LENGTH(vstr) = 2 THEN
    SET val1 = 2048;
    SET val2 = -32768;
  ELSEIF LENGTH(vstr) = 4 THEN
    SET val1 = 134217728;
    SET val2 = -2147483648;
  ELSE
    SIGNAL SQLSTATE '78000' SET MESSAGE_TEXT = 'Not a 2 or 4 CHARACTER BIN-INT string';
  END IF;

  SET HEXSTR = HEX(REVSTR);

  WHILE pos <= LENGTH(HEXSTR) DO
    SET nibble = SUBSTR(HEXSTR, pos, 1);
    SET res = BITOR(CASE WHEN BITAND(res, val1) != 0
                         THEN BITOR(16 * BITANDNOT(res, val1),
                                    val2)
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

  IF res = val2 THEN
    RETURN NULL;
  ELSE
    RETURN res;
  END IF;

END


