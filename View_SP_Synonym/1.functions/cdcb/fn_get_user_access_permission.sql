CREATE OR REPLACE FUNCTION fn_get_user_access_permission
--======================================================
--Author: Nghi Ta
--Created Date: 2021-01-12
--Description: Get admin email list 
--======================================================
(	 
   IN @USER_KEY INT
) 
 RETURNS TABLE (
	GROUP_ROLE				varchar(100),
	FEATURE_NAME			varchar(200),
	COMPONENT_NAME			varchar(200) 
 )
LANGUAGE SQL

RETURN
	 SELECT
			 g.GROUP_SHORT_NAME AS GROUP_ROLE,
			 f.FEATURE_NAME,
			 fc.COMPONENT_NAME
		 from 
		 (
		 select * 
		 from USER_GROUP_TABLE
		  where USER_KEY = @USER_KEY
		 )  
		 ug 
		 inner join GROUP_TABLE g
		 	on g.GROUP_KEY = ug.GROUP_KEY 
		 inner join GROUP_FEATURE_COMPONENT_TABLE gfc
		    on gfc.GROUP_KEY = g.GROUP_KEY 
		 inner join FEATURE_COMPONENT_TABLE fc
		    on gfc.COMPONENT_KEY = fc.COMPONENT_KEY
		 inner join FEATURE_TABLE f
		    on f.FEATURE_KEY = fc.FEATURE_KEY
		
		union
		
		SELECT
			 g.ROLE_SHORT_NAME,
			 f.FEATURE_NAME,
			 fc.COMPONENT_NAME
		 from 
		 (
		 select * 
		 from USER_ROLE_TABLE
		  where  USER_KEY = @USER_KEY
		 )  
		 ug 
		 inner join ROLE_TABLE g
		 	on g.ROLE_KEY = ug.ROLE_KEY 
		 inner join ROLE_FEATURE_COMPONENT_TABLE gfc
		    on gfc.ROLE_KEY = g.ROLE_KEY 
		 inner join FEATURE_COMPONENT_TABLE fc
		    on gfc.COMPONENT_KEY = fc.COMPONENT_KEY
		 inner join FEATURE_TABLE f
		    on f.FEATURE_KEY = fc.FEATURE_KEY 
		with ur