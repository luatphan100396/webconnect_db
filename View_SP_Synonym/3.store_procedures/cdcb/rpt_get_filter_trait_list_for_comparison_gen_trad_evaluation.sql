CREATE OR REPLACE PROCEDURE rpt_Comparision_Gen_Trad_Evaluation
--======================================================================================
--Author: Nghi Ta
--Created Date: 2020-06-15
--Description: Does a Comparison of Genomic and Traditional evaluations
--Output: 
--       +Ds1: data includ: birth year, number of cow, bv, rel, sire bv
--======================================================================================
( in @input_char varchar(10000))
 
 dynamic result sets  10
BEGIN
    
    DECLARE input_xml XML;
      
   DECLARE v_SEX CHAR(1);
   DECLARE v_BREED_CODE CHAR(2);
   DECLARE v_SUBSET_CODE varchar(30); 
   DECLARE v_EVAL_PDATE smallint;
   DECLARE v_PRE_EVAL_PDATE smallint;
   DECLARE DEFAULT_DATE VARCHAR(10);
   DECLARE v_SUBSET_CODE_CONDITION varchar(100);
   DECLARE v_IS_SHOW_SCR smallint default 0;
   DECLARE v_IS_SHOW_TYPE_TRAIT smallint default 0;
   
   DECLARE sql_trait_code_1 varchar(10000);
   DECLARE sql_trait_code_gen varchar(10000);
   DECLARE sql_trait_code_trad varchar(10000);
   DECLARE sql_trait_code_std_dev varchar(10000); 
   DECLARE sql_trait_code_gen_rel varchar(10000);
   DECLARE sql_trait_code_trad_rel varchar(10000);
   
   DECLARE sql_query varchar(30000);
   DECLARE sql_query_main_from varchar(30000);
   
   DECLARE C1 CURSOR WITH RETURN FOR D1; 

    DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpFilterInputs 
	(
		Field      VARCHAR(50),
		Value       VARCHAR(50)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpFilterInputsMultiSelect 
	(
		Field      VARCHAR(128),
		Value       VARCHAR(128),
		Order  smallint  GENERATED BY DEFAULT AS IDENTITY  (START WITH 1 INCREMENT BY 1)  
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
	 DECLARE GLOBAL TEMPORARY TABLE SESSION.v_TmpTraitList
	(
		TRAIT  varchar(10), 
		TRAIT_FULL_NAME varchar(50),
		UNIT varchar(30),
		DECIMAL_ADJUST_CODE varchar(5),
		TYPE varchar(30),
		ORDER smallint
	) WITH REPLACE ON COMMIT PRESERVE ROWS;

     
    SET input_xml =  xmlparse(document @input_char);
    
	INSERT INTO SESSION.TmpFilterInputs 
	(    
		Field,
		Value
	)
	 SELECT  
		 XML_BOOKS.Field,
		 XML_BOOKS.Value		 
		FROM  
		XMLTABLE(
		'$doc/Inputs/Item' 
		PASSING input_xml AS "doc"
		COLUMNS 
		 
		Field      VARCHAR(128)  PATH 'Field',
		Value       VARCHAR(3000)  PATH 'Value' 
		) AS XML_BOOKS;     
		 
		 
   INSERT INTO SESSION.TmpFilterInputsMultiSelect 
	(    
		Field,
		Value 
	)
   SELECT  
		 XML_BOOKS.Field,
		 XML_BOOKS.Value		 
		FROM  
		XMLTABLE(
		'$doc/Inputs/Multi_Item/Item' 
		PASSING input_xml AS "doc"
		COLUMNS 
		 
		Field      VARCHAR(128)  PATH 'Field',
		Value       VARCHAR(3000)  PATH 'Value' 
		) AS XML_BOOKS;  
		
   INSERT INTO SESSION.v_TmpTraitList
   (
   TRAIT,  
   TRAIT_FULL_NAME,
   UNIT,
   DECIMAL_ADJUST_CODE,
   TYPE,
   ORDER
   )
  
   SELECT REPLACE(REPLACE(upper(trim(t.VALUE)),'%','_PCT'),'$','_AMT') as TRAIT, 
          trait.TRAIT_FULL_NAME AS TRAIT_FULL_NAME,
          trait.UNIT,
          case when trait.DECIMAL_ADJUST_CODE = '0' then '1'
               when trait.DECIMAL_ADJUST_CODE = '1' then '0.1'
               when trait.DECIMAL_ADJUST_CODE = '2' then '0.01'
          end as DECIMAL_ADJUST_CODE,
          t.FIELD,
          ORDER
   FROM 
   ( 
   SELECT VALUE, ORDER, FIELD
   FROM SESSION.TmpFilterInputsMultiSelect
   WHERE FIELD IN ('TRAIT','INDEX','TYPE_TRAIT')
   )t
   LEFT JOIN 
   (
      select  TRAIT, 
		      TRAIT_FULL_NAME, 
		      UNIT, 
		      DECIMAL_ADJUST_CODE
      from table(fn_Get_List_traits())
   )trait
   on trait.TRAIT = t.VALUE
   
   ;
    
     
   
   SET v_EVAL_PDATE = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE FIELD ='RUN_PDATE' limit 1);
  -- SET v_PRE_EVAL_PDATE = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE FIELD ='PRE_RUN_PDATE' limit 1);
   SET v_SEX = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE FIELD ='SEX' limit 1);
   SET v_BREED_CODE = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE FIELD ='BREED_CODE' limit 1);
   SET v_SUBSET_CODE = (SELECT VALUE FROM SESSION.TmpFilterInputs WHERE FIELD ='SUBSET' limit 1);
   SET v_IS_SHOW_SCR = (SELECT count(1) FROM SESSION.v_TmpTraitList where trait ='SCR' limit 1);
   SET v_IS_SHOW_TYPE_TRAIT = (SELECT count(1) FROM SESSION.v_TmpTraitList where type ='TYPE_TRAIT' limit 1);
   
   
   
   
   SET v_SUBSET_CODE_CONDITION = CASE WHEN v_SUBSET_CODE ='Active Bulls' THEN '''A'',''F'''
                                      ELSE NULL
                                  END;
   
    
    SET v_PRE_EVAL_PDATE = (SELECT MAX(RUN_PDATE) FROM TABLE (fn_Get_List_Run_Date()) WHERE RUN_PDATE < v_EVAL_PDATE );
   
   -- set dynamic trait list
   select  
		substr(xmlserialize(xmlagg(xmltext( 
		case when t.Type in ( 'TRAIT','INDEX') then 
		                 ',float2char(avg(case when bv.GENOMICS_IND =1 then bv.PTA_'||t.trait||'_QTY else null end),'||DECIMAL_ADJUST_CODE||') as MEAN_GEN_PTA_'||t.trait||'
						 ,float2char(avg(bv.PTA_'||t.trait||'_QTY),'||DECIMAL_ADJUST_CODE||') as MEAN_TRAD_PTA_'||t.trait||'
						 ,float2char(stddev(bv.PTA_'||t.trait||'_QTY),'||DECIMAL_ADJUST_CODE||') as STD_DEV_PTA_'||t.trait||'
						 '||case when t.trait not in ('FAT_PCT','PRO_PCT') then ',float2char(avg(case when bv.GENOMICS_IND =1 then bv.PTA_'||t.trait||'_REL_PCT else null end),'||DECIMAL_ADJUST_CODE||') as MEAN_GEN_REL_'||t.trait 
						         else ''
						    end 
						   || 
						   '
						   '||case when t.trait not in ('FAT_PCT','PRO_PCT') then ',float2char(avg(bv.PTA_'||t.trait||'_REL_PCT),'||DECIMAL_ADJUST_CODE||') as MEAN_TRAD_REL_'||t.trait 
						         else ''
						    end 
		      when t.Type in ('TYPE_TRAIT') then 
		                 ',avg(case when bv.GENOMICS_IND =1 then typeTable.PTA'||t.trait||' else null end) as MEAN_GEN_PTA_'||t.trait||'
						 ,avg(bv.PTA'||t.trait||') as MEAN_TRAD_PTA_'||t.trait||'
						 ,stddev(bv.PTA'||t.trait||') as STD_DEV_PTA_'||t.trait||'
						 ,avg(case when bv.GENOMICS_IND =1 then typeTable.REL'||t.trait||' else null end) as MEAN_GEN_REL_'||t.trait||'
						 ,avg(bv.REL'||t.trait||') as MEAN_TRAD_REL_'||t.trait||'
						 '
		      else ''
		  end
		    
		  
										 	 ) order by  t.Order) as VARCHAR(30000)),2)
		,substr(xmlserialize(xmlagg(xmltext( 'when tr.TRAIT = '''||t.trait||''' then bv.MEAN_GEN_PTA_'||t.trait||'
               '
										 	 ) order by  t.Order) as VARCHAR(30000)),1)
	   ,substr(xmlserialize(xmlagg(xmltext( 'when tr.TRAIT = '''||t.trait||''' then bv.MEAN_TRAD_PTA_'||t.trait||'
               '
										 	 ) order by  t.Order) as VARCHAR(30000)),1)
	    ,substr(xmlserialize(xmlagg(xmltext( 'when tr.TRAIT = '''||t.trait||''' then bv.STD_DEV_PTA_'||t.trait||'
               '
										 	 ) order by  t.Order) as VARCHAR(30000)),1)
										 	 
	    ,substr(xmlserialize(xmlagg(xmltext( case when t.trait not in ('FAT_PCT','PRO_PCT') then 'when tr.TRAIT = '''||t.trait||''' then bv.MEAN_GEN_REL_'||t.trait||'
               '
                                                  else ''
                                              end
										 	 ) order by  t.Order) as VARCHAR(30000)),1) 
	     ,substr(xmlserialize(xmlagg(xmltext(case when t.trait not in ('FAT_PCT','PRO_PCT') then 'when tr.TRAIT = '''||t.trait||''' then bv.MEAN_TRAD_REL_'||t.trait||'
               '
              	                                   else ''
                                              end
										 	 ) order by  t.Order) as VARCHAR(30000)),1)    
	       
		 into  sql_trait_code_1,
		 sql_trait_code_gen,
		 sql_trait_code_trad,
		 sql_trait_code_std_dev,
		 sql_trait_code_gen_rel,
		 sql_trait_code_trad_rel
   from  SESSION.v_TmpTraitList t ; 
     
  SET sql_query_main_from = 
  case when v_SUBSET_CODE ='Active Bulls' then '
	 (
	 select anim_key
	 from bull_evl_table_decode 
	 where eval_pdate = '||v_PRE_EVAL_PDATE||'
	  and status_code in ('||v_SUBSET_CODE_CONDITION||') 
	  and eval_breed_code ='''||v_BREED_CODE||'''
	 )ai_bull
	 inner join bull_evl_table_decode bv
	 on bv.anim_key = ai_bull.anim_key
	 and bv.eval_pdate = '||v_EVAL_PDATE||'
  '
       else '
     bull_evl_table_decode bv
	 where bv.eval_pdate = '||v_EVAL_PDATE||' 
	 and bv.eval_breed_code ='''||v_BREED_CODE||'''
           
                                 '
 end;
       
  SET sql_query =' 
  select bv.TRAIT_FULL_NAME,
         bv.MEAN_GEN_PTA,
         bv.MEAN_TRAD_PTA,
         bv.MEAN_GEN_PTA - bv.MEAN_TRAD_PTA as DIF_MEAN_PTA ,
         bv.STD_DEV_PTA,
         bv.MEAN_GEN_REL,
         bv.MEAN_TRAD_REL,
         bv.MEAN_GEN_REL - bv.MEAN_TRAD_REL as DIF_MEAN_REL
  from       
  (
	  select tr.TRAIT_FULL_NAME
	         ,tr.UNIT
	         ,tr.Order
	         ,case '||sql_trait_code_gen||'
	          end as MEAN_GEN_PTA
	         ,case '||sql_trait_code_trad||'
	          end as MEAN_TRAD_PTA
	         ,case '||sql_trait_code_std_dev||'
	          end as STD_DEV_PTA
	         ,case '||sql_trait_code_gen_rel||'
	          end as MEAN_GEN_REL
	         ,case '||sql_trait_code_trad_rel||'
	          end as MEAN_TRAD_REL
	  from SESSION.v_TmpTraitList tr
	     cross join
	     (
		 select  '||sql_trait_code_1||'
		 from  '||sql_query_main_from||'
		 '||case when v_IS_SHOW_SCR = 1 then 
		 'left join bull_fert_table bfert
	       on bfert.anim_key = bv.anim_key
	       and bfert.eval_pdate = bv.eval_pdate'  
	            else ''
	        end    
		 ||' 
		 '||case when v_IS_SHOW_TYPE_TRAIT = 1 then 
		 'left join SIRE_TYPE_TABLE typeTable
	       on typeTable.anim_key = bv.anim_key
	       and typeTable.eval_pdate = bv.eval_pdate'  
	            else ''
	        end    
		 ||'
		 )bv
	 
)bv
 order by bv.order
	 
'; 
 
   
  set sql_query = replace(replace(sql_query,'&gt;','>'),'&lt;','<');  
  set sql_query = replace(sql_query,'PTA_FAT_PCT_QTY','PTA_FAT_PCT');
  set sql_query = replace(sql_query,'PTA_PRO_PCT_QTY','PTA_PRO_PCT');
  set sql_query = replace(sql_query,'PTA_NM_AMT_QTY','NM_AMT');
  set sql_query = replace(sql_query,'PTA_FM_AMT_QTY','FM_AMT');
  set sql_query = replace(sql_query,'PTA_CM_AMT_QTY','CM_AMT');
  set sql_query = replace(sql_query,'PTA_GM_AMT_QTY','GM_AMT');  
  set sql_query = replace(sql_query,'PTA_NM_AMT_REL_PCT','NM_REL_PCT'); 
  set sql_query = replace(sql_query,'PTA_FM_AMT_REL_PCT','NM_REL_PCT'); 
  set sql_query = replace(sql_query,'PTA_CM_AMT_REL_PCT','NM_REL_PCT'); 
  set sql_query = replace(sql_query,'PTA_GM_AMT_REL_PCT','NM_REL_PCT'); 
 set sql_query = replace(sql_query,'bv.PTA_SCR_QTY','bfert.ERCR_QTY*0.1'); 
 set sql_query = replace(sql_query,'bv.PTA_SCR_REL_PCT','bfert.ERCR_REL_PCT'); 
  
  
  
--  set sql_query = replace(sql_query,'bv.PTA_SCR_QTY','bfert.ERCR_QTY*0.1'); 
--  set sql_query = replace(sql_query,'PTA_REL_QTY','YLD_REL_PCT'); 
--  set sql_query = replace(sql_query,'PTA_DAUS_QTY','MLK_DAUS_QTY'); 
--  set sql_query = replace(sql_query,'PTA_HERDS_QTY','MLK_HERDS_QTY');  
--  
   
   
  
  -- Get Comparison of current and previous evaluations
    
    
    begin
       declare c1 cursor with return for 
       select sql_query, v_SUBSET_CODE
       from sysibm.sysdummy1;
       open c1;
        
       
    end;

 PREPARE D1 FROM  sql_query;
     OPEN C1;
  
END