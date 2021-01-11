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
     
	SET v_REQUEST_KEY = (SELECT REQUEST_KEY FROM DATA_EXCHANGE_OPERATION_TABLE WHERE OPERATION_KEY = @OPERATION_KEY); 
	
	 
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
   
   
   
begin
     declare c1 cursor with return for
       select 1 AS RESULT FROM sysibm.sysdummy1;
     
     open c1;
end;
 	  		 			
  
END P1