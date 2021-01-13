CREATE OR REPLACE FUNCTION fn_check_user_name_is_admin
--======================================================
--Author: Nghi Ta
--Created Date: 2021-01-12
--Description: Check whether login user is admim or not
--======================================================
(	 
  @USER_NAME VARCHAR(128)
) 
RETURNS INTEGER

LANGUAGE SQL
BEGIN 
	DECLARE IS_ADMIN SMALLINT DEFAULT 0; 
	DECLARE v_USER_KEY int;
	
	DECLARE err_message varchar(300);
	
	SET v_USER_KEY = (select USER_KEY from USER_ACCOUNT_TABLE WHERE lower(USER_NAME) = lower(@USER_NAME) limit 1);
	
	IF  v_USER_KEY IS NULL 
	THEN 
	   set err_message = 'The account "'||@USER_NAME||'" does not exist';
 	   SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = err_message; 
	END IF;
	
	
	SET IS_ADMIN = (SELECT case when COUNT(1)>=1 then 1 else 0 end
						from   user_group_table ug
						inner join group_table g
							on ug.group_key = g.group_key
							and upper(g.GROUP_SHORT_NAME) = 'ADMIN'
							and ug.USER_KEY = v_USER_KEY 
					  );
 
	RETURN IS_ADMIN;
END