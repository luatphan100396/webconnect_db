 
CREATE OR REPLACE PROCEDURE usp_Account_Delete_Account
--======================================================
--Author: Nghi Ta
--Created Date: 2020-12-30
--Description: Delete
--Output:
--        +Ds1: 1 if success. Failed will raise exception
--======================================================
(
	@USER_NAME VARCHAR(128)
)
	DYNAMIC RESULT SETS 10
	LANGUAGE SQL
P1: BEGIN
	    DECLARE v_USER_KEY int;
	    
	    DECLARE SQLCODE INTEGER DEFAULT 0; 
	    DECLARE retcode INTEGER DEFAULT 0;
	    DECLARE err_message varchar(300);
	    
	   -- INPUT VALIDATION
		IF  @USER_NAME IS NULL 
		THEN
		 
	 	 SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'Input is not valid';
		
		END IF;
		
		SET v_USER_KEY = (select USER_KEY from USER_ACCOUNT_TABLE WHERE lower(USER_NAME) = lower(@USER_NAME) limit 1);
	   
 
 BEGIN  
 
 
	     DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
	     SET retcode = SQLCODE;
	     
	     -- Archive data
	     INSERT INTO ARCHIVE_USER_INFO_TABLE
	     ( 
			 USER_KEY,
			 FIRST_NAME,
			 LAST_NAME,
			 EMAIL_ADDR,
			 ORGANIZATION,
			 STATUS_CODE,
			 TITLE,
			 PHONE,
			 EMAIL_USE_IND,
			 CREATED_TIME,
			 MODIFIED_TIME,
			 MODIFIED_BY,
			 ARCHIVED_TIME 
	     )
	     SELECT  USER_KEY,
				 FIRST_NAME,
				 LAST_NAME,
				 EMAIL_ADDR,
				 ORGANIZATION,
				 STATUS_CODE,
				 TITLE,
				 PHONE,
				 EMAIL_USE_IND,
				 CREATED_TIME,
				 MODIFIED_TIME,
				 MODIFIED_BY,
				 current timestamp as ARCHIVED_TIME
		  FROM  USER_INFO_TABLE
		  WHERE USER_KEY = v_USER_KEY;
	     
	     
	      INSERT INTO ARCHIVE_USER_ACCOUNT_TABLE
	     (  
			 USER_KEY,
			 USER_NAME,
			 PASSWORD,
			 CREATED_TIME,
			 MODIFIED_TIME,
			 MODIFIED_BY,
			 ARCHIVED_TIME
	     )
	     SELECT  USER_KEY,
				 USER_NAME,
				 PASSWORD,
				 CREATED_TIME,
				 MODIFIED_TIME,
				 MODIFIED_BY, 
				 current timestamp as ARCHIVED_TIME
		  FROM  USER_ACCOUNT_TABLE
		  WHERE USER_KEY = v_USER_KEY;
		  
		  
		  INSERT INTO ARCHIVE_USER_GROUP_TABLE
	     (   
			 USER_KEY,
			 GROUP_KEY,
			 CREATED_TIME,
			 MODIFIED_TIME,
			 MODIFIED_BY,
			 ARCHIVED_TIME
	
	     )
	     SELECT  USER_KEY,
				 GROUP_KEY,
				 CREATED_TIME,
				 MODIFIED_TIME,
				 MODIFIED_BY, 
				 current timestamp as ARCHIVED_TIME
		  FROM  USER_GROUP_TABLE
		  WHERE USER_KEY = v_USER_KEY;
		  
		  INSERT INTO ARCHIVE_USER_ROLE_TABLE
	     (    
			 USER_KEY,
			 ROLE_KEY,
			 CREATED_TIME,
			 MODIFIED_TIME,
			 MODIFIED_BY,
			 ARCHIVED_TIME 
	     )
	     SELECT  USER_KEY,
				 ROLE_KEY,
				 CREATED_TIME,
				 MODIFIED_TIME,
				 MODIFIED_BY,
				 current timestamp as ARCHIVED_TIME
		  FROM  USER_ROLE_TABLE
		  WHERE USER_KEY = v_USER_KEY;
		  
		  INSERT INTO ARCHIVE_USER_AFFILIATION_TABLE
	     (     
			 USER_KEY,
			 DATA_SOURCE_KEY,
			 READ_PERMISSION,
			 WRITE_PERMISSION,
			 CREATED_TIME,
			 MODIFIED_TIME,
			 MODIFIED_BY,
			 ARCHIVED_TIME 
	     )
	     SELECT  USER_KEY,
				 DATA_SOURCE_KEY,
				 READ_PERMISSION,
				 WRITE_PERMISSION,
				 CREATED_TIME,
				 MODIFIED_TIME,
				 MODIFIED_BY,
				 current timestamp as ARCHIVED_TIME
		  FROM  USER_AFFILIATION_TABLE
		  WHERE  USER_KEY = v_USER_KEY;
	     
			
		 -- Delete user info
		 
		 DELETE FROM USER_INFO_TABLE WHERE USER_KEY = v_USER_KEY; 
			   
 END;
			 
	  	     IF retcode < 0 THEN 
				ROLLBACK  ;  
				
				 SET err_message = (SELECT SYSPROC.SQLERRM (cast(retcode as varchar(20))) FROM SYSIBM.SYSDUMMY1); 
				 SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = err_message;
				 
			 ELSE 
				COMMIT ;  
					
					BEGIN
						DECLARE cursor1 CURSOR WITH RETURN for
						SELECT  1 AS RESULT 
						FROM sysibm.sysdummy1;
					 
						OPEN cursor1;
					END;
					
					
			 END IF ;  
END P1 
