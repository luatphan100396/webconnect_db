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

   BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for 
	
			  select USER_NAME,
			 g.GROUP_SHORT_NAME AS GROUP_ROLE,
			 f.FEATURE_NAME,
			 fc.COMPONENT_NAME
		 from 
		 (
		 select * 
		 from USER_ACCOUNT_TABLE
		  where lower(user_name) = lower(@USER_NAME)
		 )  
		 u
		 inner join USER_GROUP_TABLE ug
		 	on ug.USER_KEY = u.USER_KEY
		 inner join GROUP_TABLE g
		 	on g.GROUP_KEY = ug.GROUP_KEY 
		 inner join GROUP_FEATURE_COMPONENT_TABLE gfc
		    on gfc.GROUP_KEY = g.GROUP_KEY 
		 inner join FEATURE_COMPONENT_TABLE fc
		    on gfc.COMPONENT_KEY = fc.COMPONENT_KEY
		 inner join FEATURE_TABLE f
		    on f.FEATURE_KEY = fc.FEATURE_KEY
		
		union
		 
		 select USER_NAME,
			 g.ROLE_SHORT_NAME,
			 f.FEATURE_NAME,
			 fc.COMPONENT_NAME
		 from 
		 (
		 select * 
		 from USER_ACCOUNT_TABLE
		  where lower(user_name) = lower(@USER_NAME)
		 )  
		 u
		 inner join USER_ROLE_TABLE ug
		 	on ug.USER_KEY = u.USER_KEY
		 inner join ROLE_TABLE g
		 	on g.ROLE_KEY = ug.ROLE_KEY 
		 inner join ROLE_FEATURE_COMPONENT_TABLE gfc
		    on gfc.ROLE_KEY = g.ROLE_KEY 
		 inner join FEATURE_COMPONENT_TABLE fc
		    on gfc.COMPONENT_KEY = fc.COMPONENT_KEY
		 inner join FEATURE_TABLE f
		    on f.FEATURE_KEY = fc.FEATURE_KEY
		with ur;
		 
	  
	OPEN cursor1;
	
	END;
END