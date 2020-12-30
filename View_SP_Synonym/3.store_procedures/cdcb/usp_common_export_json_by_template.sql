CREATE OR REPLACE PROCEDURE usp_common_export_json_by_template
--=================================================================================================
--Author: Nghi Ta
--Created Date: 2020-11-12
--Description: Export data table into json file base on json template
--Output: 
--       +Var1: EXPORT_FILE_NAME
--================================================================================================
(
IN @TABLE_NAME varchar(200), 
IN @TEMPLATE_NAME varchar(200),
IN @LAST_ROW_ID varchar(5),
OUT @EXPORT_FILE_NAME VARCHAR(300)
)
  
  dynamic result sets 1
BEGIN
     
	  DECLARE EXPORT_PATH				VARCHAR(200);
	  DECLARE v_TEMPLATE_DETAIL VARCHAR(10000);
	  DECLARE v_PREFIX_OUTPUT_NAME VARCHAR(200);
	  DECLARE sql_query varchar(10000);
	  
	  SET EXPORT_PATH = (SELECT STRING_VALUE FROM dbo.CONSTANTS WHERE NAME = 'Export_Folder');
	 
	  SELECT TEMPLATE_DETAIL, PREFIX_OUTPUT_NAME 
	         INTO v_TEMPLATE_DETAIL, v_PREFIX_OUTPUT_NAME 
	  FROM OUTPUT_FILE_TEMPLATE_TABLE WHERE NAME = @template_name AND TYPE ='JSON' LIMIT 1;
	  
	  SET @EXPORT_FILE_NAME = v_PREFIX_OUTPUT_NAME ||'_' || REPLACE(REPLACE(REPLACE(CAST(current timestamp AS VARCHAR(26)), '.', ''), ':' , ''), '-', ''); 
	  SET @EXPORT_FILE_NAME = EXPORT_PATH || '/' || @EXPORT_FILE_NAME || '.json';
	   
      SET v_TEMPLATE_DETAIL= REPLACE(REPLACE(v_TEMPLATE_DETAIL,'<','''||trim(coalesce('),'>',',''''))||''');
       
	  SET sql_query =
	  '
	  select ''['' from sysibm.sysdummy1
      union all 
	  
	  SELECT '''||v_TEMPLATE_DETAIL||''' || case when ROW_ID <>'||@LAST_ROW_ID||' then '','' else '''' end
	  FROM '||@TABLE_NAME||'
	  
	  union all
	  select '']'' from sysibm.sysdummy1
	  '; 
	    
 	     call SYSPROC.ADMIN_CMD( 'export to '||@EXPORT_FILE_NAME||' of DEL modified by NOCHARDEL 
       	  		                  '||sql_query||'' );
      	  		                    
END


