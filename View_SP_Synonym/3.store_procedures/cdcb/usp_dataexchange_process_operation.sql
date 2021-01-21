CREATE OR REPLACE PROCEDURE usp_DataExchange_Process_Operation
--======================================================
--Author: Nghi Ta
--Created Date: 2020-12-14
--Description: process data exchange operation/subtask in a request
--birth date, cross reference...
--Output: 
--        +JSON file output
--======================================================
(    
	IN @OPERATION_KEY BIGINT
)
	DYNAMIC RESULT SETS 10
P1: BEGIN
 
    DECLARE v_REQUEST_KEY BIGINT;
    DECLARE query VARCHAR(3000);
    
    DECLARE v_INPUT_PATH VARCHAR(3000);
    
    DECLARE SQLCODE INTEGER DEFAULT 0; 
    DECLARE retcode_Operation INTEGER DEFAULT 0;
    DECLARE err_message varchar(300);
    

    
    -- VALIDATE INPUT
    IF (select count(1) from DATA_EXCHANGE_OPERATION_TABLE where OPERATION_KEY = @OPERATION_KEY) =0 THEN
		    SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'The operation key does not exist';
	END IF;
     
    IF (select count(1) from DATA_EXCHANGE_OPERATION_TABLE where OPERATION_KEY = @OPERATION_KEY AND UPPER(STATUS) <>'NEW') >0 THEN
		    SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'The operation is inprocess or processed';
	END IF;
     
     
	SET v_REQUEST_KEY = (SELECT REQUEST_KEY FROM DATA_EXCHANGE_OPERATION_TABLE WHERE OPERATION_KEY = @OPERATION_KEY); 
	 
	 BEGIN  
 
 
		     DECLARE EXIT HANDLER FOR SQLEXCEPTION
		     SET retcode_Operation = SQLCODE;
		     
		      
			 --START PROCESS
			 UPDATE DATA_EXCHANGE_OPERATION_TABLE SET STATUS = 'Processing', START_TIME = current timestamp
			 WHERE OPERATION_KEY = @OPERATION_KEY;
				
				
			 
			select CALL_COMMAND
			into query
			from
			(   select OPERATION_NAME as QUERY_NAME
				from DATA_EXCHANGE_OPERATION_TABLE d 
				where OPERATION_KEY = @OPERATION_KEY
			)d
			inner join QUERY_TABLE q
			on d.QUERY_NAME = q.QUERY_NAME
			;
			
			
			
		    SET query = replace(query,'@REQUEST_KEY',cast(v_REQUEST_KEY as varchar(20))); 
		    SET query = replace(query,'@OPERATION_KEY',cast(@OPERATION_KEY as varchar(20))); 
		    EXECUTE IMMEDIATE query;
		    
		    
		    UPDATE DATA_EXCHANGE_OPERATION_TABLE SET STATUS = 'Completed', END_TIME = current timestamp
			WHERE OPERATION_KEY = @OPERATION_KEY;
			
			--COMMIT;
    
    END;
			 
	  	     IF retcode_Operation < 0 THEN 
				 
				 SET err_message = (SELECT SYSPROC.SQLERRM (cast(retcode_Operation as varchar(20))) FROM SYSIBM.SYSDUMMY1); 
				 
				 UPDATE DATA_EXCHANGE_OPERATION_TABLE  SET   STATUS = 'Failed', MESSAGE = err_message, END_TIME = current timestamp
			     WHERE OPERATION_KEY = @OPERATION_KEY; 
				  
				 
				 BEGIN
						DECLARE cursor1 CURSOR WITH RETURN for
						SELECT retcode_Operation
						FROM sysibm.sysdummy1;
					 
						OPEN cursor1;
					END;
				 
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