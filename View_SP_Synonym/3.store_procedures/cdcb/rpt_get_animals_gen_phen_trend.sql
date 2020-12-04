CREATE OR REPLACE PROCEDURE rpt_Get_Animals_Gen_Phen_trend
--======================================================================================
--Author: Nghi Ta
--Created Date: 2020-06-08
--Description: get animal genetic and phenotypic trend
--Output: 
--       +Ds1: data includ: birth year, number of cow, bv, rel, sire bv
--======================================================================================
( in @input_char varchar(10000))
 
 dynamic result sets  2
BEGIN
    
    DECLARE input_xml XML;
    
   DECLARE v_BREED_CODE varchar(15);
   DECLARE v_TRAIT varchar(5); 
   
   DECLARE v_EVAL_PDATE SMALLINT;
   DECLARE DEFAULT_DATE VARCHAR(10);
   DECLARE BIRTH_PDATE_THRESHOLD smallint;
   DECLARE CURRENT_YEAR SMALLINT;
   
   DECLARE v_TRAIT_VALUE_DECIMAL_ADJUST VARCHAR(5);
   DECLARE v_BV_DECIMAL_ADJUST VARCHAR(5);
   DECLARE v_REL_DECIMAL_ADJUST VARCHAR(5);
   DECLARE v_SIRE_BV_DECIMAL_ADJUST VARCHAR(5);
   
   DECLARE sql_query varchar(30000);
   DECLARE C1 CURSOR WITH RETURN FOR D1; 

    DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpFilterInputs 
	(
		Field      VARCHAR(50),
		Value       VARCHAR(50)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	    DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpTraitColPosition
	(
		TRAIT            VARCHAR(5),
		MEAN_UOM_START_INDEX      SMALLINT,
		MEAN_UOM_LENGTH           SMALLINT,
		MEAN_PTA_START_INDEX      SMALLINT,
		MEAN_PTA_LENGTH           SMALLINT,
		MEAN_REL_PTA_START_INDEX      SMALLINT,
		MEAN_REL_PTA_LENGTH           SMALLINT
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
		 
   SET v_BREED_CODE = (SELECT TRIM(VALUE) FROM SESSION.TmpFilterInputs WHERE FIELD ='BREED_CODE' limit 1);
   SET v_TRAIT = (SELECT  TRIM(VALUE) FROM SESSION.TmpFilterInputs WHERE FIELD ='TRAIT' limit 1);
      
   SET v_EVAL_PDATE = (select max(RUN_PDATE) FROM ENV_VAR_TABLE);
   SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
   SET CURRENT_YEAR =  (select year(current date) from sysibm.sysdummy1);
   SET BIRTH_PDATE_THRESHOLD = (select days( cast(CURRENT_YEAR-2 as int) ||'-12-31')  - days(DEFAULT_DATE)  from sysibm.sysdummy1);
   
   
  
   SET v_TRAIT_VALUE_DECIMAL_ADJUST = case when v_TRAIT in('DPR','HCR','CCR') then '0.1' 
                                           when v_TRAIT in('PL','SCS','LIV') then '0.01' 
                                           else '1' 
                                       end;
 
   SET v_BV_DECIMAL_ADJUST = case when v_TRAIT in('PL','SCS', 'DPR','HCR','CCR','LIV') then '0.01'  
                                  else '1' 
                              end;
   
   
   SET v_SIRE_BV_DECIMAL_ADJUST = case when v_TRAIT in('PL','SCS', 'DPR','HCR','CCR','LIV') then '0.01'  
                                           else '1' 
                                       end;
                                       
   
 
    
IF v_TRAIT IN ('CE','SB') THEN
  SET sql_query ='
	 select  coalesce(s_ct.BIRTH_YEAR, d_ct.BIRTH_YEAR) as BIRTH_YEAR,
	 s_ct.S'||v_TRAIT||'_CALVING_QTY,
	 s_ct.MEAN_S'||v_TRAIT||'_PTA, 
	 s_ct.MEAN_S'||v_TRAIT||'_REL_PCT,
	 d_ct.D'||v_TRAIT||'_CALVING_QTY,
	 d_ct.MEAN_D'||v_TRAIT||'_PTA,
	 d_ct.MEAN_D'||v_TRAIT||'_REL_PCT
	 
	 from
	 (
	    select  
	         year(cast('''||DEFAULT_DATE||''' as date) + ped.birth_pdate) AS BIRTH_YEAR,
			 sum(ct.S'||v_TRAIT||'_CALVING_QTY) as S'||v_TRAIT||'_CALVING_QTY,
			 float2char(avg(cast(ct.S'||v_TRAIT||'_DIFF_BIRTH_PCT as float)),0.1) as MEAN_S'||v_TRAIT||'_PTA, 
			 avg(ct.S'||v_TRAIT||'_REL_PCT) as MEAN_S'||v_TRAIT||'_REL_PCT,
		     count(1) as COUNT_S'||v_TRAIT||' 
	    from CT_HISTORY_TABLE ct
	    inner join pedigree_table ped 
		   on ct.anim_key = ped.anim_key
		   and ped.species_code =0
	       and ct.eval_pdate = '||v_EVAL_PDATE||'
	       and ct.eval_breed_code ='''||v_BREED_CODE||'''
	       and ct.S'||v_TRAIT||'_SOURCE_CODE   = ''D''
           and ct.S'||v_TRAIT||'_OFFICIAL_CODE = ''Y''
           and ped.birth_pdate <= '||BIRTH_PDATE_THRESHOLD||'
          
         group by year(cast('''||DEFAULT_DATE||''' as date) + ped.birth_pdate)
	   
	 )s_ct
	 full join
	 (
	    select  
	         year(cast('''||DEFAULT_DATE||''' as date) + ped.birth_pdate) AS BIRTH_YEAR,
			 sum(ct.D'||v_TRAIT||'_CALVING_QTY) as D'||v_TRAIT||'_CALVING_QTY,
			 float2char(avg(cast(ct.D'||v_TRAIT||'_DIFF_BIRTH_PCT as float)),0.1) as MEAN_D'||v_TRAIT||'_PTA,  
			 avg(ct.D'||v_TRAIT||'_REL_PCT) as MEAN_D'||v_TRAIT||'_REL_PCT,
		     count(1) as COUNT_D'||v_TRAIT||' 
	    from CT_HISTORY_TABLE ct
	    inner join pedigree_table ped 
		   on ct.anim_key = ped.anim_key
		   and ped.species_code =0
	       and ct.eval_pdate = '||v_EVAL_PDATE||'
	       and ct.eval_breed_code ='''||v_BREED_CODE||'''
	       and ct.D'||v_TRAIT||'_SOURCE_CODE   = ''D''
           and ct.D'||v_TRAIT||'_OFFICIAL_CODE = ''Y''
           and ped.birth_pdate <= '||BIRTH_PDATE_THRESHOLD||'
         group by year(cast('''||DEFAULT_DATE||''' as date) + ped.birth_pdate)
	   
	 )d_ct
	 ON s_ct.BIRTH_YEAR = d_ct.BIRTH_YEAR
	 order by coalesce(s_ct.BIRTH_YEAR, d_ct.BIRTH_YEAR) desc
	  
';
ELSE   
	SET sql_query =
	    ' select  BIRTH_YEAR ,
         NUM_COW,
         '|| case when v_TRAIT ='LIV' then 'float2char(round((100 - (First_Lac_Y * 2.8 * 1.63)) * 100)*0.01,'||v_TRAIT_VALUE_DECIMAL_ADJUST||')'
                  when v_TRAIT in ('PL','SCS') then 'float2char(First_Lac_Y*0.01,'||v_TRAIT_VALUE_DECIMAL_ADJUST||')'
                  else 'float2char(First_Lac_Y,'||v_TRAIT_VALUE_DECIMAL_ADJUST||')'
             end  
         ||'  as TRAIT_VALUE, 
         float2char(WEBV,'||v_BV_DECIMAL_ADJUST||') AS BV,
         float2char(REL*0.01,0.01) as REL,
         float2char(SIREEBV,'||v_SIRE_BV_DECIMAL_ADJUST||') AS SIRE_BV 
  from BREED_MEANS bv
  where breed_code = '''||v_BREED_CODE||'''
  and eval_pdate = '||v_EVAL_PDATE||'
  and trait_short_name ='''||v_TRAIT||'''
  order by birth_year desc
 
	    ';  
END IF; 
   
     set sql_query = replace(sql_query,'SB_DIFF_BIRTH_PCT','SB_EVAL_PCT');
	 
 	 PREPARE D1 FROM  sql_query;
 	 OPEN C1;
  
END

 
