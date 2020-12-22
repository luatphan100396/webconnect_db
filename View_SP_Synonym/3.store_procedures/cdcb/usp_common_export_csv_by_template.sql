CREATE OR REPLACE PROCEDURE usp_common_export_csv_by_template
--=================================================================================================
--Author: Nghi Ta
--Created Date: 2020-11-12
--Description: Export data table into json file base on json template
--Output: 
--       +Var1: EXPORT_FILE_NAME
--================================================================================================
(
IN @TABLE_NAME varchar(200), 
IN @TEMPLATE_NAME varchar(200) , 
OUT @EXPORT_FILE_NAME VARCHAR(300)
)
  
  dynamic result sets 4
BEGIN
      
	  DECLARE EXPORT_PATH				VARCHAR(200);
	  DECLARE v_TEMPLATE_DETAIL VARCHAR(10000);
	  DECLARE v_PREFIX_OUTPUT_NAME VARCHAR(200);
	  DECLARE v_Header   VARCHAR(3000);
	  DECLARE v_Field    VARCHAR(3000);
	  DECLARE sql_query varchar(10000);
	  DECLARE template_xml XML;
	   
	    
  	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpTemplate 
		(
			Field      VARCHAR(128),
			Header       VARCHAR(128)
		) WITH REPLACE ON COMMIT PRESERVE ROWS;
	 
	   
	  SET EXPORT_PATH = (SELECT STRING_VALUE FROM dbo.CONSTANTS WHERE NAME = 'Export_Folder');
	 
	  SELECT TEMPLATE_DETAIL, PREFIX_OUTPUT_NAME 
	         INTO v_TEMPLATE_DETAIL, v_PREFIX_OUTPUT_NAME 
	  FROM OUTPUT_FILE_TEMPLATE_TABLE WHERE NAME = @template_name AND TYPE ='CSV' LIMIT 1;
	  
	  SET @EXPORT_FILE_NAME = v_PREFIX_OUTPUT_NAME||'_' || REPLACE(REPLACE(REPLACE(CAST(current timestamp AS VARCHAR(26)), '.', ''), ':' , ''), '-', ''); 
	  SET @EXPORT_FILE_NAME = EXPORT_PATH || '/' || @EXPORT_FILE_NAME || '.csv';
	   
	   
	   
     set template_xml =  xmlparse(document v_TEMPLATE_DETAIL);
	   
	   
	INSERT INTO SESSION.TmpTemplate 
	(    
		Field,
		Header
	)
	 SELECT  
			 XML_BOOKS.Field,
			 XML_BOOKS.Header		 
			FROM  
			XMLTABLE(
			'$doc/Template/Item' 
			PASSING template_xml AS "doc"
			COLUMNS 
			 
			Field      VARCHAR(128)  PATH 'Field',
			Header       VARCHAR(3000)  PATH 'Header' 
			) AS XML_BOOKS;       
		    
 
   
	   set v_Header =(
	   select substr(xmlserialize(xmlagg(xmltext ( ','''||Header||''' as '||Field||'' 
	                                             )  ) as VARCHAR(30000)),2)
	   from   SESSION.TmpTemplate  
	   )  ; 
	   
	   set v_Field =(
	   select substr(xmlserialize(xmlagg(xmltext ( ','||Field||'' 
	                                             )  ) as VARCHAR(30000)),2)
	   from   SESSION.TmpTemplate  
	   )  ; 
	    
    
       
	  SET sql_query =
	  '  SELECT '||v_Field||'
	     FROM 
		 ( 
			  select '||v_Header||', -1 AS ROW_ID
			  from sysibm.sysdummy1
		      union all 
			  
			  SELECT '||v_Field||', ROW_ID 
			  FROM '||@TABLE_NAME||'
		  )
		 ORDER BY ROW_ID
	     WITH UR
	  '; 
	    
  	     call SYSPROC.ADMIN_CMD( 'export to '||@EXPORT_FILE_NAME||' of DEL modified by NOCHARDEL 
        	  		                  '||sql_query||'' );
      	  		                    
	 
END