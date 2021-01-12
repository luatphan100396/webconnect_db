CREATE OR REPLACE PROCEDURE usp_Account_Get_Account_Detail
--======================================================
--Author: Nghi Ta
--Created Date: 2021-01-12
--Description: Get Account detail
--Output:
--        +Ds1: account detail
--======================================================
(
	@USER_NAME VARCHAR(128)
)
	DYNAMIC RESULT SETS 10
P1: BEGIN
	
	DECLARE v_USER_KEY int;
	DECLARE err_message varchar(300);
	
	 -- INPUT VALIDATION
	IF  @USER_NAME IS NULL 
	THEN 
 	    SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'Input is not valid'; 
	END IF;
	
	SET v_USER_KEY = (select USER_KEY from USER_ACCOUNT_TABLE WHERE lower(USER_NAME) = lower(@USER_NAME) limit 1);
   
    IF  v_USER_KEY IS NULL 
	THEN 
	   set err_message = 'The account "'||@USER_NAME||'" does not exist';
 	   SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = err_message; 
	END IF;
	
	
	 
	BEGIN
	-- Declare cursor
	DECLARE cursor2 CURSOR WITH RETURN for
			
	     SELECT  u.USER_KEY,
				 u.FIRST_NAME,
				 u.LAST_NAME,
				 u.EMAIL_ADDR,
				 u.ORGANIZATION,
				 u.STATUS_CODE,
				 u.TITLE,
				 u.PHONE,
				 u.EMAIL_USE_IND,
				 a.USER_NAME,  
				 a.PASSWORD
	     FROM USER_INFO_TABLE u
	     INNER JOIN USER_ACCOUNT_TABLE a
	        ON u.USER_KEY = a.USER_KEY
	     WHERE a.USER_KEY = v_USER_KEY
	     LIMIT 1;
	
		     
	OPEN cursor2;
	END;
END P1