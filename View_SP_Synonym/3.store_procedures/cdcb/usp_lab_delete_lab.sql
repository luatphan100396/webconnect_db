CREATE OR REPLACE PROCEDURE usp_Lab_Delete_Lab
--======================================================
--Author: Tri Do
--Created Date: 2021-01-12
--Description: Delete
--Output:
--        +Ds1: 1 if success. Failed will raise exception
--======================================================
(
	@DATA_SOURCE_KEY INT
)
	DYNAMIC RESULT SETS 1
	LANGUAGE SQL
P1: BEGIN	    
	    DECLARE SQLCODE INTEGER DEFAULT 0; 
	    DECLARE retcode INTEGER DEFAULT 0;
	    DECLARE err_message varchar(300);
	    
	   -- INPUT VALIDATION
		IF  @DATA_SOURCE_KEY IS NULL
		THEN
		 
			SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'Input is not valid';
		
		END IF;

 		BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		SET retcode = SQLCODE;
	    
		-- Archive data
		INSERT INTO ARCHIVE_DATA_SOURCE_TABLE
		( 
			DATA_SOURCE_KEY,
			CLASS_CODE,
			HEALTH_SOURCE_CODE,
			SOURCE_SHORT_NAME,
			SOURCE_NAME,
			STATUS_CODE,
			WITHIN_CLASS_KEY,
			CDDR_IND,
			CONTACT_NAME,
			EMAIL_ADDR,
			PATH_ADDR,
			MODIFY_TIMESTAMP,
			COMMENT,
			ARCHIVED_TIME
		)
		SELECT  DATA_SOURCE_KEY,
				CLASS_CODE,
				HEALTH_SOURCE_CODE,
				SOURCE_SHORT_NAME,
				SOURCE_NAME,
				STATUS_CODE,
				WITHIN_CLASS_KEY,
				CDDR_IND,
				CONTACT_NAME,
				EMAIL_ADDR,
				PATH_ADDR,
				MODIFY_TIMESTAMP,
				COMMENT,
				current timestamp as ARCHIVED_TIME
		FROM  DATA_SOURCE_TABLE
		WHERE DATA_SOURCE_KEY = @DATA_SOURCE_KEY;
			
		-- Delete user info
		
		DELETE FROM DATA_SOURCE_TABLE WHERE DATA_SOURCE_KEY = @DATA_SOURCE_KEY;
		
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