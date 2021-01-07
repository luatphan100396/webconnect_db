CREATE OR REPLACE PROCEDURE usp_login_get_user_affiliations
--======================================================
--Author: Nghi Ta
--Created Date: 2020-12-14
--Description: Get user affiliations
--Output:
--        +Ds1: Table affiliations
--======================================================
(
	IN @USER_NAME VARCHAR(128)
)
	DYNAMIC RESULT SETS 1
BEGIN 

   BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for 
	
	 select  d.SOURCE_SHORT_NAME as AFFILIATE_SHORT_NAME,
	         d.SOURCE_NAME as AFFILIATE_NAME
	 from 
	 (
	 select USER_NAME,
	        USER_KEY
	 from USER_ACCOUNT_TABLE
	  where lower(user_name) = lower(@USER_NAME)
	 )  
	 u
	 inner join USER_AFFILIATION_TABLE uaf
	 	on uaf.USER_KEY = u.USER_KEY
	 inner join DATA_SOURCE_TABLE d
	    on uaf.DATA_SOURCE_KEY = d.DATA_SOURCE_KEY
	 order by d.SOURCE_SHORT_NAME
	 with ur;
	     	  
	  
	OPEN cursor1;
	
	END;
END