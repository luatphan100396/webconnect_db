
  INSERT INTO QUERY_TABLE
 ( 
  QUERY_NAME,
  CALL_COMMAND 
 )
 VALUES(
 'Get Animal Information by Animal 12 chars',
 'CALL usp_DataExchange_Get_Animal_Formatted_Pedigree_Info('''',0,'''','''',''1'',@REQUEST_KEY,@OPERATION_KEY)'
 );
  