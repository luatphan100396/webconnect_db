CREATE OR REPLACE PROCEDURE usp_get_user_role 
--======================================================
--Author: Nghi Ta
--Created Date: 2020-04-06
--Description: Get user role information
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
	
	   select  
	           f.page as parent_feature,
	           f.feature_name, 
			   p.permission_name,
			   g.group_name 
	   from
	  (
	   select user_id 
	   from users 
	   where lower(user_name) = lower(@USER_NAME)
	  )u
	  inner join user_groups ug
	  	on u.user_id = ug.user_id
	  inner join group_roles gr
	  	on ug.group_id = gr.group_id
	  inner join role_feature_permissions rfp
	    on rfp.role_id = gr.role_id
	  inner join features f 
	     on f.feature_id = rfp.feature_id
	  inner join permissions p 
	     on p.permission_id = rfp.permission_id
     
	  inner join groups g
	    on g.GROUP_ID = ug.GROUP_ID
	  with ur;

	OPEN cursor1;
	
	END;
END