

INSERT INTO QUERY_TABLE
 ( 
  QUERY_NAME,
  CALL_COMMAND 
 )
 VALUES(
 'Get animal 5-generation pedigrees',
 'CALL usp_Dataexchange_Get_5first_Generation_Of_One_Animal('''',0,'''','''',''1'',@REQUEST_KEY,@OPERATION_KEY)'
 );
  
 