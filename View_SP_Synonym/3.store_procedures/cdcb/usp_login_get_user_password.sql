CREATE OR REPLACE PROCEDURE usp_Login_Get_User_Password
--======================================================
--Author: Linh Pham
--Created Date: 2020-12-29
--Description: Get user password
--Output:
--        +Ds1: Table with password
--======================================================
(
	IN @USER_NAME VARCHAR(128),
	IN @EMAIL_ADDRESS VARCHAR(200)
)
	DYNAMIC RESULT SETS 2
BEGIN
    
    DECLARE v_USER_KEY int;

    SET @USER_NAME = nullif(trim(@USER_NAME),'');
    SET @EMAIL_ADDRESS = nullif(trim(@EMAIL_ADDRESS),'');
    
    
    
	IF  @USER_NAME IS NULL
	   AND @EMAIL_ADDRESS IS NULL
		THEN
		 
	 	 SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'Input is not valid';
		
	END IF;
	
	
	IF @USER_NAME IS NOT NULL THEN
	
		SELECT USER_KEY 
		INTO v_USER_KEY
		from USER_ACCOUNT_TABLE 
		WHERE lower(USER_NAME) = lower(@USER_NAME) 
		limit 1;
	 
	 END IF;
	 
	 
	 IF @EMAIL_ADDRESS IS NOT NULL THEN
	
		select USER_KEY 
		INTO v_USER_KEY
		from USER_INFO_TABLE 
		WHERE lower(EMAIL_ADDR) = lower(@EMAIL_ADDRESS) 
		limit 1;
	 
	 END IF;
	 
	 
	BEGIN
		DECLARE cursor1 CURSOR WITH RETURN for
	
		SELECT  a.USER_KEY,
		        a.USER_NAME, 
		        a.PASSWORD 
		FROM  USER_ACCOUNT_TABLE a
		WHERE a.USER_KEY = v_USER_KEY
		WITH UR;
	
		OPEN cursor1;
	END;
END 