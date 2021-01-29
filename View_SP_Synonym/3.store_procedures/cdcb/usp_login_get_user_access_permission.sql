CREATE OR REPLACE PROCEDURE usp_login_get_user_access_permission
--======================================================
--Author: Nghi Ta
--Created Date: 2020-12-14
--Description: Get user access permission
--Output:
--        +Ds1: Table with features and permissions
--======================================================
(
	IN @USER_NAME VARCHAR(128)
)
	DYNAMIC RESULT SETS 1
BEGIN 

	DECLARE v_USER_KEY int;
	SET v_USER_KEY = (select USER_KEY from USER_ACCOUNT_TABLE WHERE lower(USER_NAME) = lower(@USER_NAME) limit 1);
	   
	    

   BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for 
	     
      select GROUP_ROLE,
			 FEATURE_NAME,
			 COMPONENT_NAME
      from table(fn_get_user_access_permission(v_USER_KEY))
	  order by GROUP_ROLE,
			      FEATURE_NAME,
			      COMPONENT_NAME
		with ur;
		 
	  
	OPEN cursor1;
	
	END;
END