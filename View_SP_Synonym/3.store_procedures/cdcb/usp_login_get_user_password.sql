CREATE OR REPLACE PROCEDURE usp_Login_Get_User_Password
--======================================================
--Author: Linh Pham
--Created Date: 2020-12-29
--Description: Get user password
--Output:
--        +Ds1: Table with password
--======================================================
(
	IN @USER_NAME_OR_EMAIL_ADDRESS VARCHAR(200) 
)
	DYNAMIC RESULT SETS 2
BEGIN
    
    DECLARE v_USER_KEY int;
 
	-- Check user name
	
	SELECT USER_KEY 
		INTO v_USER_KEY
	from USER_ACCOUNT_TABLE 
	WHERE lower(USER_NAME) = lower(@USER_NAME_OR_EMAIL_ADDRESS) 
		limit 1;
		
	-- Check email
	
	IF v_USER_KEY IS NULL THEN
		
		 SELECT USER_KEY 
			INTO v_USER_KEY
		from USER_INFO_TABLE 
		WHERE lower(EMAIL_ADDR) = lower(@USER_NAME_OR_EMAIL_ADDRESS) 
			limit 1; 
    END IF; 
	 
    -- 
	
	BEGIN
		DECLARE cursor1 CURSOR WITH RETURN for
	
		SELECT  a.USER_KEY,
		        a.USER_NAME, 
		        a.PASSWORD 
		FROM  USER_ACCOUNT_TABLE a
		INNER JOIN USER_INFO_TABLE u
		    ON u.USER_KEY = a.USER_KEY
		    and a.USER_KEY = v_USER_KEY
		    and UPPER(u.STATUS_CODE)='A' 
		WITH UR;
	
		OPEN cursor1;
	END; 
END 