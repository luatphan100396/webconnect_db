CREATE OR REPLACE PROCEDURE usp_account_get_account_permission
--======================================================
--Author: Nghi Ta
--Created Date: 2021-01-6
--Description: Get account permission
--Output:
--        +Ds1: Table with features and permissions
--======================================================
(
	IN @USER_NAME VARCHAR(128)
)
	DYNAMIC RESULT SETS 10
BEGIN 


DECLARE v_USER_KEY INT;
SET v_USER_KEY= ( select USER_KEY
				  from USER_ACCOUNT_TABLE
				  where lower(user_name) = lower(@USER_NAME)
	            );
   
 DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_AFFILIATIONS
(
    DATA_SOURCE_KEY INT, 
	READ_PERMISSION CHAR(1), 
	WRITE_PERMISSION char(1) 

) WITH REPLACE ON COMMIT PRESERVE ROWS;

INSERT INTO SESSION.TMP_AFFILIATIONS
(
	DATA_SOURCE_KEY,
	READ_PERMISSION,
	WRITE_PERMISSION
)
select DATA_SOURCE_KEY,
		 READ_PERMISSION,
		 WRITE_PERMISSION
from USER_AFFILIATION_TABLE
where USER_KEY = v_USER_KEY
;
 
  BEGIN
		DECLARE cursor10 CURSOR WITH RETURN for 
		
		 select  r.ROLE_SHORT_NAME,
		         r.ROLE_NAME 
		 from   USER_ROLE_TABLE ur
		 	inner join ROLE_TABLE r
		      on ur.ROLE_KEY = r.ROLE_KEY
		 where ur.USER_KEY = v_USER_KEY
		   
		 with ur;
		     	  
		  
		OPEN cursor10;
	
	END;
	
	
   BEGIN
		DECLARE cursor1 CURSOR WITH RETURN for 
		
		 select  trim(d.SOURCE_SHORT_NAME) as DRPC_SHORT_NAME,
		         trim(d.SOURCE_NAME) as DRPC_NAME,
		         READ_PERMISSION,
		         WRITE_PERMISSION
		 from SESSION.TMP_AFFILIATIONS uaf
		 inner join DATA_SOURCE_TABLE d
		    on uaf.DATA_SOURCE_KEY = d.DATA_SOURCE_KEY
		    and  d.CLASS_CODE ='D'
		   -- and d.SOURCE_SHORT_NAME in ('CA','WI','NC','UT')
		 with ur;
		     	  
		  
		OPEN cursor1;
	
	END;
	
	
	BEGIN
	DECLARE cursor2 CURSOR WITH RETURN for 
	
	 select  trim(d.SOURCE_SHORT_NAME) as LAB_SHORT_NAME,
	         trim(d.SOURCE_NAME) as LAB_NAME,
	         READ_PERMISSION,
	         WRITE_PERMISSION
	 from SESSION.TMP_AFFILIATIONS  uaf
	 inner join DATA_SOURCE_TABLE d
	    on uaf.DATA_SOURCE_KEY = d.DATA_SOURCE_KEY
	    and d.CLASS_CODE ='L' --and d.STATUS_CODE ='A'
	 with ur;
	     	  
	  
	OPEN cursor2;
	
	END;
	
	BEGIN
	DECLARE cursor3 CURSOR WITH RETURN for 
	
	 select  trim(d.SOURCE_SHORT_NAME) as NOMINATOR_SHORT_NAME,
	         trim(d.SOURCE_NAME) as NOMINATOR_NAME,
	         READ_PERMISSION,
	         WRITE_PERMISSION
	 from SESSION.TMP_AFFILIATIONS uaf
	 inner join DATA_SOURCE_TABLE d
	    on uaf.DATA_SOURCE_KEY = d.DATA_SOURCE_KEY
	    and d.CLASS_CODE ='R' --and d.STATUS_CODE ='A'
	 with ur;
	     	  
	  
	OPEN cursor3;
	
	END;
END