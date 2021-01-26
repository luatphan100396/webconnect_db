   
 INSERT INTO QUERY_TABLE
 ( 
  QUERY_NAME,
  CALL_COMMAND 
 )
 VALUES(
 'Get Animal Formatted Pedigree Information',
 'CALL usp_Get_Animal_Formatted_Pedigree_Info('''',0,'''','''',''1'',@REQUEST_KEY,@OPERATION_KEY)'
 );
  

INSERT INTO QUERY_TABLE
 ( 
  QUERY_NAME,
  CALL_COMMAND 
 )
 VALUES(
 'Get Animal Information by Naab Code',
 'CALL usp_Search_Animal_By_Naab_Code(''CATTLE'','''','','',''1'',@REQUEST_KEY,@OPERATION_KEY)'
 );

  INSERT INTO QUERY_TABLE
 ( 
  QUERY_NAME,
  CALL_COMMAND 
 )
 VALUES(
 'Get animal 5-generation pedigrees',
 'CALL usp_Get_5first_Generation_Pedigrees('''',0,'''','''',''1'',@REQUEST_KEY,@OPERATION_KEY)'
 );   
     
INSERT INTO QUERY_TABLE
 ( 
  QUERY_NAME,
  CALL_COMMAND 
 )
 VALUES(
 'Get Animal Information Id Evaluation by Animal 12 chars',
 'CALL usp_Get_Animal_ID_Evaluation_By_12_Character('''',0,'''','''',''1'',@REQUEST_KEY,@OPERATION_KEY)'
 );
  

  ---Author: Linh Pham 26/01/2021
  INSERT INTO QUERY_TABLE
 ( 
  QUERY_NAME,
  CALL_COMMAND 
 )
 VALUES(
 'Get Cow Herd And Cow Control Numbers By ID',
 'CALL usp_Get_Cow_Herd_And_Cow_Control_Numbers_By_ID('''',0,'''','''',''1'',@REQUEST_KEY,@OPERATION_KEY)'
 );


--25/01/2021 insert query table for data exchange retrieve parentage validation
INSERT INTO QUERY_TABLE
 ( 
  QUERY_NAME,
  CALL_COMMAND 
 )
 VALUES(
 'Retrieve Parentage Validation Record',
 'CALL usp_Get_Animals_Parentage_Ver_Record_By_id('''',0,'''','''','''',''1'',@REQUEST_KEY,@OPERATION_KEY)'
 );
--AUTHOR: Linh Pham 26/01/2021 Get Cow Key And ID By Herd Cow Control Number
 INSERT INTO QUERY_TABLE
 ( 
  QUERY_NAME,
  CALL_COMMAND 
 )
 VALUES(
 'Get Cow Key And ID By Herd Cow Control Number',
 'CALL usp_Search_Animal_By_Herd_Cow_Control_Number(''CATTLE'','''','','',''1'',@REQUEST_KEY,@OPERATION_KEY)'
 );