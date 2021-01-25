 INSERT INTO QUERY_TABLE
 ( 
  QUERY_NAME,
  CALL_COMMAND 
 )
 VALUES(
 'Get animal 5-generation pedigrees',
 'CALL usp_Get_5first_Generation_Pedigrees('''',0,'''','''',''1'',@REQUEST_KEY,@OPERATION_KEY)'
 );
     