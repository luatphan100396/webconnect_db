INSERT INTO QUERY_TABLE
 ( 
  QUERY_NAME,
  CALL_COMMAND 
 )
 VALUES(
 'Get Animal Information Id Evaluation by Animal 12 chars',
 'CALL usp_Get_Animal_ID_Evaluation_By_12_Character('''',0,'''','''',''1'',@REQUEST_KEY,@OPERATION_KEY)'
 );
  