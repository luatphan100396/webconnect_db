
drop table BULL_EVL_TABLE_DECODE;
create table BULL_EVL_TABLE_DECODE

   (EVAL_BREED_CODE              char(2)       not null,
    BULL_ID                      char(17)      not null,
    EVAL_PDATE                   smallint      not null,  
    SOURCE_CODE                  char(1)       not null,
    ANIM_KEY                     integer       not null, 
	STATUS_CODE                  char(1)       not null  default 'N',
    NAAB_CODE char(10),
    MOST_DAU_HERD_QTY            smallint,
    NM_AMT varchar(10) null, 
    NM_REL_PCT varchar(10) null, 
    NM_PCTL                      char(2)       not null  default ' ',
	 PTA_MLK_QTY varchar(10) null, 
	 PTA_FAT_QTY varchar(10) null, 
	 PTA_PRO_QTY varchar(10) null, 
	 PTA_PL_QTY varchar(10) null, 
	 PTA_SCS_QTY varchar(10) null, 
	 PTA_DPR_QTY varchar(10) null, 
	 PTA_HCR_QTY varchar(10) null, 
	 PTA_CCR_QTY varchar(10) null, 
	 PTA_LIV_QTY varchar(10) null, 
	 PTA_GL_QTY varchar(10) null, 
	 PTA_MFV_QTY varchar(10) null, 
	 PTA_DAB_QTY varchar(10) null, 
	 PTA_KET_QTY varchar(10) null, 
	 PTA_MAS_QTY varchar(10) null, 
	 PTA_MET_QTY varchar(10) null, 
	 PTA_RPL_QTY varchar(10) null, 
	 PTA_EFC_QTY varchar(10) null, 
	 PTA_MLK_REL_PCT varchar(10) null, 
	 PTA_FAT_REL_PCT varchar(10) null, 
	 PTA_PRO_REL_PCT varchar(10) null, 
	 PTA_PL_REL_PCT varchar(10) null, 
	 PTA_SCS_REL_PCT varchar(10) null, 
	 PTA_DPR_REL_PCT varchar(10) null, 
	 PTA_HCR_REL_PCT varchar(10) null, 
	 PTA_CCR_REL_PCT varchar(10) null, 
	 PTA_LIV_REL_PCT varchar(10) null, 
	 PTA_GL_REL_PCT varchar(10) null, 
	 PTA_MFV_REL_PCT varchar(10) null, 
	 PTA_DAB_REL_PCT varchar(10) null, 
	 PTA_KET_REL_PCT varchar(10) null, 
	 PTA_MAS_REL_PCT varchar(10) null, 
	 PTA_MET_REL_PCT varchar(10) null, 
	 PTA_RPL_REL_PCT varchar(10) null, 
	 PTA_EFC_REL_PCT varchar(10) null, 
	 PTA_FAT_PCT varchar(10) null, 
	 PTA_PRO_PCT varchar(10) null, 
  
constraint BULL_EVL_TABLE_DECODE_PK               primary key (EVAL_BREED_CODE, BULL_ID, EVAL_PDATE, SOURCE_CODE));

--in EVALUATION;

create index BULL_EVL_TABLE_DECODE_INDEX           on BULL_EVL_TABLE_DECODE   (ANIM_KEY   asc)  allow reverse scans;
create index BULL_EVL_TABLE_DECODE_INDEX2          on BULL_EVL_TABLE_DECODE           (EVAL_PDATE desc, EVAL_BREED_CODE asc, ANIM_KEY desc) allow reverse scans;
create index BULL_EVL_TABLE_DECODE_INDEX_STATUS_CODE           on BULL_EVL_TABLE_DECODE   (STATUS_CODE   asc)  allow reverse scans;
 create index BULL_EVL_TABLE_DECODE_INDEX_BIRTH_PDATE           on BULL_EVL_TABLE_DECODE   (BIRTH_PDATE   asc)  allow reverse scans;
 
INSERT INTO BULL_EVL_TABLE_DECODE
(
EVAL_BREED_CODE
,BULL_ID
,EVAL_PDATE
,SOURCE_CODE
,ANIM_KEY
,STATUS_CODE
,NAAB_CODE
,MOST_DAU_HERD_QTY
,NM_AMT
,NM_REL_PCT
,NM_PCTL
,PTA_MLK_QTY,PTA_MLK_REL_PCT,PTA_FAT_QTY,PTA_FAT_REL_PCT,PTA_PRO_QTY,PTA_PRO_REL_PCT,PTA_PL_QTY,PTA_PL_REL_PCT,PTA_SCS_QTY,PTA_SCS_REL_PCT,PTA_DPR_QTY,PTA_DPR_REL_PCT,PTA_HCR_QTY,PTA_HCR_REL_PCT,PTA_CCR_QTY,PTA_CCR_REL_PCT,PTA_LIV_QTY,PTA_LIV_REL_PCT,PTA_GL_QTY,PTA_GL_REL_PCT,PTA_MFV_QTY,PTA_MFV_REL_PCT,PTA_DAB_QTY,PTA_DAB_REL_PCT,PTA_KET_QTY,PTA_KET_REL_PCT,PTA_MAS_QTY,PTA_MAS_REL_PCT,PTA_MET_QTY,PTA_MET_REL_PCT,PTA_RPL_QTY,PTA_RPL_REL_PCT,PTA_EFC_QTY,PTA_EFC_REL_PCT
,PTA_FAT_PCT
,PTA_PRO_PCT
)
SELECT 
EVAL_BREED_CODE
,BULL_ID
,EVAL_PDATE
,SOURCE_CODE
,ANIM_KEY
,STATUS_CODE
,case when length(bv.NAAB10_SEG) >=10 then substring(bv.NAAB10_SEG,1,10)
		              else null 
  end  AS NAAB_CODE
,MOST_DAU_HERD_QTY
,cast(case when bv.INDEX_CNT>= 1 then str2int(substring(bv.INDEX_AMT_SEG,1,2))
       else null
    end as varchar(10)) as NM_AMT 
,cast(NM_REL_PCT as varchar(5)) as NM_REL_PCT
,cast(NM_PCTL as varchar(5)) as NM_PCTL
,FLOAT2CHAR(case when bv.TRAIT_CNT>= 1 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,1,2)) else null end *1,1) AS  MLK_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 1 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,1,2)) else null end*0.1,1)  AS  MLK_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 2 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,3,2)) else null end *1,1) AS  FAT_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 2 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,3,2)) else null end*0.1,1)  AS  FAT_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 3 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,5,2)) else null end *1,1) AS  PRO_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 3 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,5,2)) else null end*0.1,1)  AS  PRO_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 4 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,7,2)) else null end *0.1,0.1) AS  PL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 4 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,7,2)) else null end*0.1,1)  AS  PL_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 5 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,9,2)) else null end *0.01,0.01) AS  SCS_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 5 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,9,2)) else null end*0.1,1)  AS  SCS_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 9 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,17,2)) else null end *0.1,0.1) AS  DPR_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 9 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,17,2)) else null end*0.1,1)  AS  DPR_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 11 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,21,2)) else null end *0.1,0.1) AS  HCR_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 11 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,21,2)) else null end*0.1,1)  AS  HCR_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 12 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,23,2)) else null end *0.1,0.1) AS  CCR_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 12 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,23,2)) else null end*0.1,1)  AS  CCR_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 13 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,25,2)) else null end *0.1,0.1) AS  LIV_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 13 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,25,2)) else null end*0.1,1)  AS  LIV_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 14 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,27,2)) else null end *0.1,0.1) AS  GL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 14 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,27,2)) else null end*0.1,1)  AS  GL_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 17 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,33,2)) else null end *0.1,0.1) AS  MFV_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 17 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,33,2)) else null end*0.1,1)  AS  MFV_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 18 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,35,2)) else null end *0.1,0.1) AS  DAB_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 18 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,35,2)) else null end*0.1,1)  AS  DAB_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 19 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,37,2)) else null end *0.1,0.1) AS  KET_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 19 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,37,2)) else null end*0.1,1)  AS  KET_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 20 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,39,2)) else null end *0.1,0.1) AS  MAS_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 20 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,39,2)) else null end*0.1,1)  AS  MAS_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 21 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,41,2)) else null end *0.1,0.1) AS  MET_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 21 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,41,2)) else null end*0.1,1)  AS  MET_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 22 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,43,2)) else null end *0.1,0.1) AS  RPL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 22 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,43,2)) else null end*0.1,1)  AS  RPL_REL_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT>= 23 then str2int(substring(bv.TRAIT_PTA_QTY_SEG,45,2)) else null end *0.1,0.1) AS  EFC_PTA,FLOAT2CHAR(case when bv.TRAIT_CNT >= 23 then str2int(substring(bv.TRAIT_PTA_REL_PCT_SEG,45,2)) else null end*0.1,1)  AS  EFC_REL_PTA
,FLOAT2CHAR(PTA_FAT_PCT*0.01,0.01) as FLOAT2CHAR
,FLOAT2CHAR(PTA_PRO_PCT*0.01,0.01)  as PTA_PRO_PCT
FROM BULL_EVL_TABLE bv
where eval_pdate in (21884,21762,21640)
and official_ind ='Y';


ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN CM_AMT varchar(10) null;
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN FM_AMT varchar(10) null;
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN GM_AMT varchar(10) null;
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN PA_NM_AMT varchar(10) null; 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN PA_NM_REL_PCT varchar(10) null; 
 

MERGE INTO BULL_EVL_TABLE_DECODE AS A
USING (
SELECT ANIM_KEY
,eval_pdate
,cast(case when bv.INDEX_CNT>= 3 then str2int(substring(bv.INDEX_AMT_SEG,3,2))
       else null
    end as varchar(10)) as PA_NM_AMT 
,cast(case when bv.INDEX_CNT>= 3 then str2int(substring(bv.INDEX_AMT_SEG,5,2))
       else null
    end as varchar(10)) as FM_AMT 
 ,cast(case when bv.INDEX_CNT>= 4 then str2int(substring(bv.INDEX_AMT_SEG,7,2))
       else null
    end as varchar(10)) as CM_AMT 
 ,cast(case when bv.INDEX_CNT>=5  then str2int(substring(bv.INDEX_AMT_SEG,9,2))
       else null
    end as varchar(10)) as GM_AMT 
,PA_NM_REL_PCT
FROM  BULL_EVL_TABLE bv
where eval_pdate in (21884,21762,21640)
and official_ind ='Y') AS B
ON A.ANIM_KEY =B.ANIM_KEY
and A.eval_pdate =B.eval_pdate
WHEN MATCHED THEN UPDATE 
SET CM_AMT = B.CM_AMT,
	FM_AMT = B.FM_AMT,
	GM_AMT = B.GM_AMT,
	PA_NM_AMT = B.PA_NM_AMT,
	PA_NM_REL_PCT = B.PA_NM_REL_PCT 

;
 
 -- add MF_LACT_DAU_QTY
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN MF_LACT_DAU_QTY smallint;
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN YLD_REL_PCT smallint;
 
MERGE INTO BULL_EVL_TABLE_DECODE AS A
USING (
SELECT ANIM_KEY
,eval_pdate
,MF_LACT_DAU_QTY
,YLD_REL_PCT

FROM  BULL_EVL_TABLE bv
where eval_pdate in (21884,21762,21640)
and official_ind ='Y') AS B
ON A.ANIM_KEY =B.ANIM_KEY
and A.eval_pdate =B.eval_pdate
WHEN MATCHED THEN UPDATE 
SET MF_LACT_DAU_QTY = B.MF_LACT_DAU_QTY,
YLD_REL_PCT = B.YLD_REL_PCT 
;

-- add MLK_DAUS_QTY, MLK_HERDS_QTY
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN MLK_DAUS_QTY int;
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN MLK_HERDS_QTY int;
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN GENOMICS_IND char(1); 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN BIRTH_PDATE smallint; 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN INBRD_PCT smallint; 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN GENOMICS_INBRD_PCT smallint; 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN FUTURE_GENOMICS_INBRD_PCT smallint; 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN ENTER_AI_PDATE smallint; 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN MLK_HIGH_EVAL_NUM smallint; 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN FUTURE_DAU_INBRD_PCT smallint; 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN DAU_INBRD_PCT smallint; 

MERGE INTO BULL_EVL_TABLE_DECODE AS A
USING (
	SELECT ANIM_KEY
	,eval_pdate
	,str2int(substring(TRAIT_DAU_QTY_SEG,1,4)) AS MLK_DAUS_QTY
	,str2int(substring(TRAIT_HERDS_QTY_SEG,1,4)) AS MLK_HERDS_QTY
	,GENOMICS_IND
	,INBRD_PCT
	,GENOMICS_INBRD_PCT
	,FUTURE_GENOMICS_INBRD_PCT
	,ENTER_AI_PDATE
	,MLK_HIGH_EVAL_NUM
	,BIRTH_PDATE
	,FUTURE_DAU_INBRD_PCT
	,DAU_INBRD_PCT
	FROM  BULL_EVL_TABLE bv
	where eval_pdate in (21884,21762,21640)
	and official_ind ='Y') AS B
ON A.ANIM_KEY =B.ANIM_KEY
and A.eval_pdate =B.eval_pdate

WHEN MATCHED THEN UPDATE 
SET MLK_DAUS_QTY = B.MLK_DAUS_QTY,
MLK_HERDS_QTY = B.MLK_HERDS_QTY ,
GENOMICS_IND = B.GENOMICS_IND,
BIRTH_PDATE =  B.BIRTH_PDATE,
INBRD_PCT = B.INBRD_PCT,
GENOMICS_INBRD_PCT = B.GENOMICS_INBRD_PCT ,
FUTURE_GENOMICS_INBRD_PCT = B.FUTURE_GENOMICS_INBRD_PCT,
ENTER_AI_PDATE = B.ENTER_AI_PDATE,
MLK_HIGH_EVAL_NUM = B.MLK_HIGH_EVAL_NUM,
FUTURE_DAU_INBRD_PCT = B.FUTURE_DAU_INBRD_PCT,
DAU_INBRD_PCT = B.DAU_INBRD_PCT  
;


 -- add MF_LACT_DAU_QTY
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN PED_COMP_PCT smallint; 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN NAAB10_SEG varchar(60); 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN CTRL_STUD_CODE smallint;
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN SAMP_CTRL_CODE smallint;
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN SAMP_STATUS_CODE char(1); 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN SIRE_ID char(17); 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN DAM_ID char(17); 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN INTERNATIONAL_ID_IND char(1); 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN REGIS_STATUS_CODE char(2); 
ALTER TABLE BULL_EVL_TABLE_DECODE ADD COLUMN HERD_WITH_MOST_DAU integer;  

MERGE INTO BULL_EVL_TABLE_DECODE AS A
USING (
SELECT ANIM_KEY
,eval_pdate
,PED_COMP_PCT
,NAAB10_SEG
,CTRL_STUD_CODE
,SAMP_CTRL_CODE
,SAMP_STATUS_CODE
,SIRE_ID
,DAM_ID
,INTERNATIONAL_ID_IND 
,REGIS_STATUS_CODE
,HERD_WITH_MOST_DAU


FROM  BULL_EVL_TABLE bv
where eval_pdate in (21884,21762,21640)
and official_ind ='Y') AS B
ON A.ANIM_KEY =B.ANIM_KEY
and A.eval_pdate =B.eval_pdate
WHEN MATCHED THEN UPDATE 
SET PED_COMP_PCT = B.PED_COMP_PCT  
,NAAB10_SEG = B.NAAB10_SEG 
,CTRL_STUD_CODE = B.CTRL_STUD_CODE 
,SAMP_CTRL_CODE = B.SAMP_CTRL_CODE  
,SAMP_STATUS_CODE = B.SAMP_STATUS_CODE 
,SIRE_ID = B.SIRE_ID 
,DAM_ID = B.DAM_ID 
,INTERNATIONAL_ID_IND = B.INTERNATIONAL_ID_IND  
,REGIS_STATUS_CODE = B.REGIS_STATUS_CODE 
,HERD_WITH_MOST_DAU = B.HERD_WITH_MOST_DAU 
;

