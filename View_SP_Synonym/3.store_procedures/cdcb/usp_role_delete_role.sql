CREATE OR REPLACE PROCEDURE usp_Role_Delete_Role 
--================================================================================
--Author: Tuyen Nguyen
--Created Date: 2020-01-08
--Description: Delete Role  
--Output: 
--       +Ds1: 1 if success. Failed will raise exception
--=================================================================================
(
  @v_ROLE_KEY INT
)


	DYNAMIC RESULT SETS 1
P1: BEGIN 

	    DECLARE SQLCODE INTEGER DEFAULT 0; 
	    DECLARE retcode INTEGER DEFAULT 0;
	    DECLARE err_message varchar(300);
	    DECLARE V_CURRENT_TIME TIMESTAMP;
	
	 -- INPUT VALIDATION
		IF  @v_ROLE_KEY IS NULL 
		THEN
		 
	 	 SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'Input is not valid';
		
		END IF;
		 
		
		IF (select count(1) from ROLE_TABLE where ROLE_KEY =@v_ROLE_KEY)=0  
		THEN
		 
	 	 SET ERR_MESSAGE = 'Role "'|| @v_ROLE_KEY|| '" no existed';
		SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = ERR_MESSAGE;
		END IF;
		
		SET v_CURRENT_TIME = (SELECT CURRENT TIMESTAMP FROM SYSIBM.SYSDUMMY1);
		
		
BEGIN  
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
	    SET retcode = SQLCODE;
         
        -- Archive data
        
        INSERT INTO ARCHIVE_ROLE_TABLE
	     (  
	        ROLE_KEY,
			ROLE_SHORT_NAME,
			ROLE_NAME,
			STATUS_CODE,
			ARCHIVED_TIME  
	     )
	    SELECT  ROLE_KEY ,
				ROLE_SHORT_NAME,
				ROLE_NAME,
				STATUS_CODE, 
				current timestamp as ARCHIVED_TIME
		  FROM  ROLE_TABLE
		  WHERE ROLE_KEY = @v_ROLE_KEY;
        
         INSERT INTO ARCHIVE_ROLE_FEATURE_COMPONENT_TABLE
	     ( 
			ROLE_KEY,
			COMPONENT_KEY,
			CREATED_TIME,
			MODIFIED_TIME, 
			ARCHIVED_TIME 
	     )
	     SELECT ROLE_KEY ,
				COMPONENT_KEY,
				CREATED_TIME,
				MODIFIED_TIME, 
				current timestamp as ARCHIVED_TIME
		  FROM  ROLE_FEATURE_COMPONENT_TABLE
		  WHERE ROLE_KEY = @v_ROLE_KEY;
        
          INSERT INTO ARCHIVE_USER_ROLE_TABLE
	     ( 
			USER_KEY,
			ROLE_KEY,
			CREATED_TIME,
			MODIFIED_TIME,
			MODIFIED_BY, 
			ARCHIVED_TIME 
	     )
	     SELECT USER_KEY ,
				ROLE_KEY,
				CREATED_TIME,
				MODIFIED_TIME,
				 MODIFIED_BY,
				current timestamp as ARCHIVED_TIME
		  FROM  USER_ROLE_TABLE
		  WHERE ROLE_KEY = @v_ROLE_KEY;
        -- Delete role
		 
		 DELETE FROM ROLE_FEATURE_COMPONENT_TABLE WHERE ROLE_KEY = @v_ROLE_KEY; 
		 DELETE FROM USER_ROLE_TABLE WHERE ROLE_KEY = @v_ROLE_KEY; 
		 DELETE FROM ROLE_TABLE WHERE ROLE_KEY = @v_ROLE_KEY; 
END;	
	
	IF RETCODE < 0 THEN
			ROLLBACK;
			
			SET ERR_MESSAGE = (SELECT SYSPROC.SQLERRM (CAST(RETCODE AS VARCHAR(20))) FROM SYSIBM.SYSDUMMY1);
			SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = ERR_MESSAGE;
		ELSE
			COMMIT;
			BEGIN
				DECLARE CURSOR1 CURSOR WITH RETURN FOR
				SELECT 1 AS RESULT
				FROM SYSIBM.SYSDUMMY1;
				
				OPEN CURSOR1;
			END;
		END IF;
END P1 