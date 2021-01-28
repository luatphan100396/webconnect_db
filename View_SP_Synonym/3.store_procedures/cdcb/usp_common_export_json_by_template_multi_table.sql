CREATE OR REPLACE PROCEDURE usp_common_export_json_by_template_multi_table
--=================================================================================================
--Author: Nghi Ta
--Created Date: 2020-11-12
--Description: Export data table into json file base on json template
--Output: 
--       +Var1: EXPORT_FILE_NAME
--================================================================================================
( 
IN @LAST_ROW_ID varchar(5),
 OUT @EXPORT_FILE_NAME VARCHAR(300)
)
  
  dynamic result sets 1
BEGIN
     
     declare sql_query varchar(30000);
     declare template_main varchar(200);
     declare template_main_detail varchar(10000);
     declare alias_main varchar(30);
     declare tabname_main varchar(200);
      
     DECLARE EXPORT_PATH				VARCHAR(200); 
	 DECLARE v_PREFIX_OUTPUT_NAME VARCHAR(200);
	 
	  
      
     	MERGE INTO SESSION.TmpDataExchangeInputTables  as A
		 using
		 ( 
			 select t.tabname,
			        t.template,
			        REPLACE(REPLACE(o.TEMPLATE_DETAIL,'<','''||trim(coalesce('),'>',',''''))||''') as TEMPLATE_DETAIL
		     from SESSION.TmpDataExchangeInputTables t
		     inner join OUTPUT_FILE_TEMPLATE_TABLE o
		     on t.template = o.name
		 )AS B
		 	ON  A.template = B.template 
		 	and A.tabname = B.tabname 
		 	
		 WHEN MATCHED THEN UPDATE
		 SET template_detail = B.TEMPLATE_DETAIL 
		 ;
		 
		 
		 
	     select template, 
		        alias,
		        tabname,
		        template_detail
	     into template_main,
	          alias_main,
	          tabname_main,
	          template_main_detail
	     from SESSION.TmpDataExchangeInputTables  
	     order by order
	     limit 1; 
	     
	 set sql_query =  'select '''||template_main_detail||'''' ;
       
     set sql_query =sql_query||'
     || case when '||alias_main||'.ROW_ID <>'||coalesce(@LAST_ROW_ID,'-999')||' then '','' else '''' end
     from  '||tabname_main||' '||alias_main||'
     ';
      
     
     
     set sql_query = sql_query||( select substr(xmlserialize(xmlagg(xmltext ( 
           'left join '||tabname||' '||alias||'
                 on '||alias_main||'.ROOT_ANIMAL_ID = '||alias||'.ROOT_ANIMAL_ID
            '
								                                             )order by order  ) as VARCHAR(30000)),1)
						         from SESSION.TmpDataExchangeInputTables 
						         where tabname <>tabname_main
							   );
      
      set sql_query = replace(sql_query,'&#xD;',''); 
        
          SET sql_query =
	  '
	  select ''['' from sysibm.sysdummy1
      union all 
	  
	  '||sql_query||'
	  
	  union all
	  select '']'' from sysibm.sysdummy1
	  '; 
	  
	  
	  INSERT INTO TEST VALUES(sql_query);
	  
	  SELECT   PREFIX_OUTPUT_NAME 
	  INTO   v_PREFIX_OUTPUT_NAME 
	  FROM OUTPUT_FILE_TEMPLATE_TABLE WHERE NAME = template_main AND TYPE ='JSON' LIMIT 1;
	 
	  SET EXPORT_PATH = (SELECT STRING_VALUE FROM dbo.CONSTANTS WHERE NAME = 'Export_Folder');
	 
	 SET @EXPORT_FILE_NAME = v_PREFIX_OUTPUT_NAME ||'_' || REPLACE(REPLACE(REPLACE(CAST(current timestamp AS VARCHAR(26)), '.', ''), ':' , ''), '-', ''); 
	 SET @EXPORT_FILE_NAME = EXPORT_PATH || '/' || @EXPORT_FILE_NAME || '.json';
	
	    
       call SYSPROC.ADMIN_CMD( 'export to '||@EXPORT_FILE_NAME||' of DEL modified by NOCHARDEL 
  	        '||sql_query||'' );             
       
      
      	  		                    
END