CREATE OR REPLACE PROCEDURE usp_Get_Herd_Cow_Lactation
--======================================================
--Author: Nghi Ta
--Created Date: 2020-06-18
--Description: Get cow lactation belong to herd
--Output: 
--        +Ds1: animal 17 chars, sex, birth date
--======================================================
( 
   IN @HERD_CODE INT,
   in @page_number smallint default 1, 
   in @row_per_page smallint default 50,
   in @is_export smallint default 0,
   in @export_type varchar(5) default 'CSV'
)
DYNAMIC RESULT SETS 5
    
BEGIN
   
	DECLARE DEFAULT_DATE varchar(10);
	DECLARE v_MIN_SAMPL_PDATE SMALLINT; 
	DECLARE EXPORT_PATH varchar(200);
    DECLARE EXPORT_FILE_NAME varchar(300); 
    
	DECLARE sql_query varchar(30000) default '';
	DECLARE sql_query_main_from varchar(3000) default '';
	DECLARE sql_query_count varchar(3000) default '';
	
	DECLARE C1 CURSOR WITH RETURN FOR D1;   
	DECLARE C2 CURSOR WITH RETURN FOR D2;
	  
	   
	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
      
    SET sql_query_main_from ='
			    lacta90_table lact
				 where herd_code = '||@HERD_CODE||' '; 
    SET sql_query ='
    select          '||case when @is_export = 0 then '
                    case when row_number()over(partition by id.anim_key order by lact.calv_pdate desc ) =1 then ''G1'' else ''G2'' end as Group,'
					        else ''
					   end 
					||'
					row_number()over( order by lact.species_code, lact.anim_key, lact.calv_pdate  ) as OrderBy, 
                    lact.SPECIES_CODE,  
		 	        id.INT_ID,
		 	        cast(ascii(lact.LACT_NUM) as varchar(5)) as LACT_NUM,
					varchar_format(cast('''||DEFAULT_DATE||''' as date) + lact.calv_pdate,''YYYY-MM-DD'') as FRESH_DATE, 
					cast(lact.DIM_QTY as varchar(5)) as DIM_QTY, 
					cast(lact.CTRL_NUM as varchar(10)) as CTRL_NUM,
					varchar_format(cast('''||DEFAULT_DATE||''' as date) + lact.proc_pdate,''YYYY-MM-DD'') as PROC_DATE,
					varchar_format(cast('''||DEFAULT_DATE||''' as date) + lact.modify_pdate,''YYYY-MM-DD'') as MODIFY_DATE,
					lact.LACT_TYPE_CODE,
					lower(hex(lact_mask)) as LACT_MASK,  
					lact.INIT_CODE,
					lact.TERM_CODE, 
					cast(ASCII(lact.OS_PCT) as varchar(5)) as OS_PCT,
					lact.DAYS_OPEN_VERIF_CODE as PREG_CONFIRM_CODE, 
					cast(lact.DAYS_OPEN_QTY as varchar(5)) as DAYS_OPEN_QTY,  
					cast(DCR_YIELD_AVG as varchar(5)) AS DCR_YIELD_AVG,
					cast(lact.ME_MLK_QTY as varchar(10)) as ME_MLK_QTY,
					cast(lact.ME_FAT_QTY as varchar(10)) as ME_FAT_QTY,
					cast(lact.ME_PRO_QTY as varchar(10)) as ME_PRO_QTY,
					cast(uchar2schar(lact.DCR_SCS_QTY) as varchar(5)) AS DCR_SCS_QTY,
					float2char(lact.ME_SCS_QTY*0.01,0.01) as ME_SCS_QTY 
		 	   from
			    (   select *,
			              ROUND((uchar2schar(lact.DCR_MLK_QTY)+uchar2schar(lact.DCR_FAT_QTY)+uchar2schar(lact.DCR_PRO_QTY))/3,0) AS DCR_YIELD_AVG
			      
					from '||sql_query_main_from||' 
					'||case when @is_export = 0 then '
					order by species_code, anim_key, calv_pdate  
					limit '||@row_per_page||' 
				    offset '||cast((@page_number-1)*@row_per_page as varchar(10))||' 
					'
					        else ''
					    end
					  ||'
					with UR
			    )lact
			    inner join id_xref_table id 
				    on lact.anim_key = id.anim_key
					and lact.species_code = id.species_code 
					and id.preferred_code = 1
			    
			    order by OrderBy 
    ';
    -- Get alias
    -- Select Mode
  	  IF @is_export = 0 THEN 
  	  
  	     PREPARE D1 FROM  sql_query;
   	     OPEN C1;
   	     set sql_query_count = '
      		SELECT COUNT(1) AS ROW_COUNT
     		FROM '||sql_query_main_from;   
		 
         PREPARE D2 FROM  sql_query_count;
         OPEN C2;

 
   	  ELSE -- Export mode
  	        
        set sql_query = ' select 
				SPECIES_CODE,
				INT_ID, 
				LACT_NUM, 
				FRESH_DATE, 
				DIM_QTY, 
				CTRL_NUM, 
				PROC_DATE, 
				MODIFY_DATE, 
				LACT_TYPE_CODE,  
				LACT_MASK, 
				INIT_CODE, 
				TERM_CODE,  
				OS_PCT, 
				PREG_CONFIRM_CODE, 
				DAYS_OPEN_QTY,  
				DCR_YIELD_AVG, 
				ME_MLK_QTY, 
				ME_FAT_QTY, 
				ME_PRO_QTY, 
				DCR_SCS_QTY, 
				ME_SCS_QTY   
             from
             (  
                           select 
					           ''-999999'' as OrderBy,  
					           ''Species Code'' as SPECIES_CODE,
								''Animal Id'' as INT_ID, 
								''Lactation Number'' as LACT_NUM, 
								''Fresh Date'' as FRESH_DATE, 
								''Days In Milk'' as DIM_QTY, 
								''Control Number'' as CTRL_NUM, 
								''Processing Date'' as PROC_DATE, 
								''Modification Date'' as MODIFY_DATE, 
								''Lactation Type'' as LACT_TYPE_CODE,  
								''Lactation Mask code'' as LACT_MASK, 
								''Initiation Code'' as INIT_CODE, 
								''Primary Termination Code'' as TERM_CODE,  
								''OS%'' as OS_PCT, 
								''PC'' as PREG_CONFIRM_CODE, 
								''Opn'' as DAYS_OPEN_QTY,  
								''DCR AVG'' as DCR_YIELD_AVG, 
								''Milk'' as ME_MLK_QTY, 
								''Fat'' as ME_FAT_QTY, 
								''Prot'' as ME_PRO_QTY, 
								''DCR SCS'' as DCR_SCS_QTY, 
								''SCS'' as ME_SCS_QTY  
						from sysibm.sysdummy1
						union all ' ||sql_query||'
					)a
			       order by OrderBy 
						';
						
		   set EXPORT_PATH = (select string_value from dbo.constants where name ='Export_Folder');
		   set EXPORT_FILE_NAME =   'Herd_Cow_Lactation_'  ||(select varchar_format(current date,'YYYYMMDD') || replace(cast(current time as varchar(10)),':','') from sysibm.sysdummy1);
		   
		 
		  set EXPORT_FILE_NAME =  EXPORT_PATH||'/'||EXPORT_FILE_NAME||'.csv';
      
            call SYSPROC.ADMIN_CMD( 'export to '||EXPORT_FILE_NAME||' of DEL modified by NOCHARDEL 
   	  		   '||sql_query);
 
  		    begin
  		        declare cir cursor with return for
  		        select  EXPORT_FILE_NAME from sysibm.sysdummy1;
  		        open cir;
  		    end;
      END IF; 
END