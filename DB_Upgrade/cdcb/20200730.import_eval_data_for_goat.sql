CREATE TABLE C19_38G
(
LINE VARCHAR(900)
);

--
--/*
--db2 connect to cdcbdb;
--db2 load from /home/db2inst1/Data/Goat/1912/38G.C19 of del insert into C19_38G
--*/
-- 
 
CREATE TABLE BUCK_EVL_TABLE 
(
 EVAL_PDATE smallint not null, 
 ANIM_KEY int not null,
 INT_ID char(17),
 SPECIES_CODE char(1),
 SEX_CODE char(1),
 SIRE_ID char(17),
 DAM_ID char(17),
 EVAL_BREED_CODE char(2), 
 REGISTRY_STATUS char(2),
 REGISTERED_NAME varchar(30),
 HERD_CODE int,
 MOST_DAU_HERD_QTY int,
 INBRD_PCT varchar(5),
 PTA_MFP_QTY int,
 PTA_MFP_REL_PCT int, -- MFP rel
 MFP_PCTL char(2),
 PTA_MLK_QTY int,
 PTA_FAT_QTY varchar(10),
 PTA_PRO_QTY varchar(10),
 PTA_FAT_PCT varchar(10),
 PTA_PRO_PCT varchar(10),
 PTA_MF_REL_PCT int,
 PTA_PRO_REL_PCT int,
 MF_HERDS_QTY int,
 PRO_HERDS_QTY int,
 AVG_LACT_DAU_MF varchar(10),
 AVG_LACT_DAU_PRO varchar(10),
 AVG_STD_MLK int,
 AVG_STD_FAT int,
 AVG_STD_PRO int ,
 constraint BUCK_EVL_TABLE_PK primary key (ANIM_KEY, EVAL_PDATE)

);
create index BUCK_EVL_TABLE_INDEX2          on BUCK_EVL_TABLE           (EVAL_PDATE desc, EVAL_BREED_CODE asc, ANIM_KEY desc) allow reverse scans;

 

insert into BUCK_EVL_TABLE
(
	 EVAL_PDATE,
	 ANIM_KEY,
	 INT_ID,
	 SPECIES_CODE,
	 SEX_CODE,
	 SIRE_ID,
	 DAM_ID,
	 EVAL_BREED_CODE,
	 REGISTRY_STATUS,
	 REGISTERED_NAME,
	 HERD_CODE,
	 MOST_DAU_HERD_QTY,
	 INBRD_PCT,
	 PTA_MFP_QTY,
	 PTA_MFP_REL_PCT,
	 MFP_PCTL,
	 PTA_MLK_QTY,
	 PTA_FAT_QTY,
	 PTA_PRO_QTY,
	 PTA_FAT_PCT,
	 PTA_PRO_PCT,
	 PTA_MF_REL_PCT,
	 PTA_PRO_REL_PCT,
	 MF_HERDS_QTY,
	 PRO_HERDS_QTY,
	 AVG_LACT_DAU_MF,
	 AVG_LACT_DAU_PRO,
	 AVG_STD_MLK,
	 AVG_STD_FAT,
	 AVG_STD_PRO 

)
select   

 21884 AS EVAL_PDATE,
 id.ANIM_KEY,
 id.INT_ID,
 id.SPECIES_CODE,
 id.SEX_CODE,
 SIRE_ID,
 DAM_ID,
 EVAL_BREED_CODE, 
 REGISTRY_STATUS,
 REGISTERED_NAME,
 CAST(HERD_CODE AS  INT) AS HERD_CODE,
 CAST(MOST_DAU_HERD_QTY AS  INT) AS MOST_DAU_HERD_QTY,
 float2char(CAST(INBRD_PCT AS INT)*0.1,0.1) AS INBRD_PCT,
 CAST(NM_AMT AS  INT) AS PTA_MFP_QTY,
 CAST(PTA_YIELD_REL_PCT AS  INT) AS PTA_MFP_REL_PCT, -- MFP rel
 NM_PCTL AS MFP_PCTL,
 CAST(PTA_MLK_QTY AS  INT) AS PTA_MLK_QTY,
 float2char(CAST(PTA_FAT_QTY AS INT)*0.1,0.1) AS PTA_FAT_QTY,
 float2char(CAST(PTA_PRO_QTY AS  INT)*0.1,0.1) AS PTA_PRO_QTY,
 float2char(CAST(PTA_FAT_PCT AS  INT)*0.01,0.01) AS PTA_FAT_PCT,
 float2char(CAST(PTA_PRO_PCT AS  INT)*0.01,0.01) AS PTA_PRO_PCT,
 CAST(PTA_MF_REL_PCT AS  INT) AS PTA_MF_REL_PCT,
 CAST(PTA_PRO_REL_PCT AS  INT) AS PTA_PRO_REL_PCT,
 CAST(MF_HERDS_QTY AS  INT) AS MF_HERDS_QTY,
 CAST(PRO_HERDS_QTY AS  INT) AS PRO_HERDS_QTY,
 float2char(CAST(AVG_LACT_DAU_MF AS  INT)*0.01,0.01) AS AVG_LACT_DAU_MF,
 float2char(CAST(AVG_LACT_DAU_PRO AS  INT)*0.01,0.01) AS AVG_LACT_DAU_PRO,
 CAST(AVG_STD_MLK AS  INT) AS AVG_STD_MLK,
 CAST(AVG_STD_FAT AS  INT) AS AVG_STD_FAT,
 CAST(AVG_STD_PRO AS  INT) AS AVG_STD_PRO 
 
from
(
		 select substring(line,1,1) AS SPECIES_CODE,
				substring(LINE,2,2) as EVAL_BREED_CODE,
				substring(LINE,4,17) as INT_ID,
				substring(LINE,21,17) as SIRE_ID,
				substring(LINE,38,17) as DAM_ID, 
				nullif(trim(substring(LINE,89,8) ),'00000000')as BIRTH_DATE,
				nullif(trim(substring(LINE,97,2) ),'')as REGISTRY_STATUS,
				nullif(trim(substring(LINE,99,30) ),'')as REGISTERED_NAME,  		
				nullif(trim(substring(LINE,206,8) ),'')as HERD_CODE,
				nullif(trim(substring(LINE,214,4) ),'')as MOST_DAU_HERD_QTY,  
				nullif(trim(substring(LINE,225,3) ),'')as INBRD_PCT, 
				nullif(trim(substring(LINE,234,2) ),'')as PTA_YIELD_REL_PCT,   
				nullif(trim(substring(LINE,278,5) ),'')as NM_AMT,
				nullif(trim(substring(LINE,288,2) ),'')as NM_PCTL,  
				nullif(trim(substring(LINE,238,5) ),'')as PTA_MLK_QTY, 
				nullif(trim(substring(LINE,245,4) ),'')as PTA_FAT_QTY,
				nullif(trim(substring(LINE,254,4) ),'')as PTA_PRO_QTY,
				nullif(trim(substring(LINE,249,3) ),'')as PTA_FAT_PCT, 		
				nullif(trim(substring(LINE,258,3) ),'')as PTA_PRO_PCT,		
				nullif(trim(substring(LINE,243,2) ),'')as PTA_MF_REL_PCT,   
				nullif(trim(substring(LINE,252,2) ),'')as PTA_PRO_REL_PCT, 
				nullif(trim(substring(LINE,317,5) ),'')as MF_HERDS_QTY,
				nullif(trim(substring(LINE,322,5) ),'')as PRO_HERDS_QTY,
				nullif(trim(substring(LINE,342,5) ),'')as MF_DAU_QTY, 
				nullif(trim(substring(LINE,347,5) ),'')as PRO_DAU_QTY,  
				nullif(trim(substring(LINE,365,3) ),'')as AVG_LACT_DAU_MF,
		        nullif(trim(substring(LINE,368,3) ),'')as AVG_LACT_DAU_PRO,  
		        nullif(trim(substring(LINE,385,5) ),'')as AVG_STD_MLK,
		        nullif(trim(substring(LINE,390,4) ),'')as AVG_STD_FAT,
		        nullif(trim(substring(LINE,401,4) ),'')as AVG_STD_PRO  
		 from C19_38G
		 where substring(line,1,1) ='1'  
 )bv
 inner join id_xref_table id
 on id.int_id = bv.int_id
 and id.species_code ='1'
 and id.sex_code ='M'
 
 ;
 
 
  