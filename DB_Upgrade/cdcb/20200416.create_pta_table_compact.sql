
drop table PTA_COW_TABLE_COMPACT;
CREATE TABLE PTA_COW_TABLE_COMPACT
(
  ANIM_KEY int not null,
  INT_ID char(17)  not null, 
  EVAL_BREED_CODE char(2),
  EVAL_PDATE smallint not null,
  ELITE_STATUS_CODE smallint null,
  SIRE_ID char(17) null,
  BIRTH_PDATE smallint null,
  NM_AMT varchar(10) null,
 NM_PCTL varchar(10) null,
 NM_REL_PCT varchar(10) null,
 PA_NM_AMT varchar(10) null,
 PA_NM_REL_PCT varchar(10) null,
 CM_AMT varchar(10) null,
 FM_AMT varchar(10) null,
 GM_AMT varchar(10) null,
 PTA_CCR_QTY varchar(10) null,
 PTA_CCR_REL_PCT varchar(10) null,
 PTA_DPR_QTY varchar(10) null,
 PTA_DPR_REL_PCT varchar(10) null,
 PTA_FAT_PCT varchar(10) null,
 PTA_FAT_QTY varchar(10) null,
 PTA_HCR_QTY varchar(10) null,
 PTA_HCR_REL_PCT varchar(10) null,
 PTA_LIV_QTY varchar(10) null,
 PTA_LIV_REL_PCT varchar(10) null,
 PTA_MF_REL_PCT varchar(10) null,
 PTA_MFP_REL_PCT varchar(10) null,
 PTA_MLK_QTY varchar(10) null,
 PTA_PL_QTY varchar(10) null,
 PTA_PL_REL_PCT varchar(10) null,
 PTA_PRO_PCT varchar(10) null,
 PTA_PRO_QTY varchar(10) null,
 PTA_PRO_REL_PCT varchar(10) null,
 PTA_SCS_QTY varchar(10) null,
 PTA_SCS_REL_PCT varchar(10) null,
 constraint PTA_COW_TABLE_COMPACT_PK primary key (ANIM_KEY,EVAL_PDATE)

);

 

INSERT INTO PTA_COW_TABLE_COMPACT
( 
 ANIM_KEY,
 INT_ID,
 EVAL_BREED_CODE,
 EVAL_PDATE,
 ELITE_STATUS_CODE,
 SIRE_ID,
 BIRTH_PDATE ,
 NM_AMT,
 NM_PCTL,
 NM_REL_PCT,
 PA_NM_AMT,
 PA_NM_REL_PCT,
 CM_AMT,
 FM_AMT,
 GM_AMT,
 PTA_CCR_QTY,
 PTA_CCR_REL_PCT,
 PTA_DPR_QTY,
 PTA_DPR_REL_PCT,
 PTA_FAT_PCT,
 PTA_FAT_QTY,
 PTA_HCR_QTY,
 PTA_HCR_REL_PCT,
 PTA_LIV_QTY,
 PTA_LIV_REL_PCT,
 PTA_MF_REL_PCT,
 PTA_MFP_REL_PCT,
 PTA_MLK_QTY,
 PTA_PL_QTY,
 PTA_PL_REL_PCT,
 PTA_PRO_PCT,
 PTA_PRO_QTY,
 PTA_PRO_REL_PCT,
 PTA_SCS_QTY,
 PTA_SCS_REL_PCT 
)

select   
id.ANIM_KEY as ANIM_KEY ,
 id.INT_ID  AS INT_ID,
 bv.EVAL_BREED_CODE,
 bv.EVAL_PDATE as EVAL_PDATE,
 AGILSMALL(bv.ELITE_STATUS_CODE) as ELITE_STATUS_CODE,
 sireID.int_id as SIRE_ID,
 ped.birth_pdate  as BIRTH_PDATE,
 cast(bv.NM_AMT as varchar(10)) as NM_AMT,
 cast(bv.NM_PCTL as varchar(10)) AS NM_PCTL,
 cast(AGILSMALL(bv.NM_REL_PCT) as varchar(10)) AS NM_REL_PCT,
 cast(bv.PA_NM_AMT as varchar(10)) as PA_NM_AMT,
 cast(AGILSMALL(bv.PA_NM_REL_PCT) as varchar(10)) AS PA_NM_REL_PCT, 
 cast(CM_AMT as varchar(10)) as CM_AMT,
 cast(FM_AMT as varchar(10)) as FM_AMT,
 cast(GM_AMT as varchar(10)) as GM_AMT, 
 FLOAT2CHAR(PTA_CCR_QTY*0.1, 0.1) as PTA_CCR_QTY,
 FLOAT2CHAR(PTA_CCR_REL_PCT, 1) as PTA_CCR_REL_PCT,
 FLOAT2CHAR(AGILSMALL(PTA_DPR_QTY)*0.1, 0.1) as PTA_DPR_QTY,
 FLOAT2CHAR(AGILSMALL(PTA_DPR_REL_PCT), 1) as PTA_DPR_REL_PCT,
 FLOAT2CHAR(AGILSMALL(bv.PTA_FAT_PCT)*0.01, 0.01) as PTA_FAT_PCT,
 FLOAT2CHAR(PTA_FAT_QTY*1, 1) as PTA_FAT_QTY,
 FLOAT2CHAR(PTA_HCR_QTY*0.1, 0.1) as PTA_HCR_QTY,
 FLOAT2CHAR(PTA_HCR_REL_PCT, 1) as PTA_HCR_REL_PCT,
 FLOAT2CHAR(PTA_LIV_QTY*0.1, 0.1) as PTA_LIV_QTY,
 FLOAT2CHAR(PTA_LIV_REL_PCT, 1) as PTA_LIV_REL_PCT,
 FLOAT2CHAR(AGILSMALL(PTA_MF_REL_PCT), 1) as PTA_MF_REL_PCT,
 FLOAT2CHAR(AGILSMALL(PTA_MFP_REL_PCT), 1) as PTA_MFP_REL_PCT,
 FLOAT2CHAR(PTA_MLK_QTY*1, 1) as PTA_MLK_QTY,
 FLOAT2CHAR(AGILSMALL(PTA_PL_QTY)*0.1, 0.1) as PTA_PL_QTY,
 FLOAT2CHAR(AGILSMALL(PTA_PL_REL_PCT), 1) as PTA_PL_REL_PCT,
 FLOAT2CHAR(AGILSMALL(bv.PTA_PRO_PCT)*0.01, 0.01) as PTA_PRO_PCT,
 FLOAT2CHAR(PTA_PRO_QTY*1, 1) as PTA_PRO_QTY,
 FLOAT2CHAR(AGILSMALL(PTA_PRO_REL_PCT), 1) as PTA_PRO_REL_PCT,
 FLOAT2CHAR(PTA_SCS_QTY*0.01, 0.01) as PTA_SCS_QTY,
 FLOAT2CHAR(AGILSMALL(PTA_SCS_REL_PCT), 1) as PTA_SCS_REL_PCT 	 

from (
	  select *
			   
	   from 
      PTA_COW_TABLE bv    
       WHERE  bv.EVAL_PDATE =   21762 
	  
	  )bv 
		 
	inner join id_xref_table id 
		 on id.anim_key = bv.anim_key 
		 and id.species_code = 0 
		 and id.sex_code='F'
		 and id.PREFERRED_CODE =1 
		 
	 left join pedigree_table ped 
	   on ped.anim_key = bv.anim_key
	   and ped.species_code = 0
	 left join id_xref_table sireID 
		 on sireID.anim_key = ped.sire_key 
		 and sireID.species_code = 0 
		 and sireID.sex_code='M' 
		 and sireID.PREFERRED_CODE=1  ;
		 
		   
		 
     
 
	   
	   