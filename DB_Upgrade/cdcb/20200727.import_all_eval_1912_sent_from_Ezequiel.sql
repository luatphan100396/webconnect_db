-- AI STATUS
   
create table TMP_AI_STATUS
(
line varchar(30)
);

create table AI_STATUS
(
 EVAL_PDATE SMALLINT NOT NULL,
 ID17 char(17) NOT NULL,
 STATUS_CODE char(1),
 CONSTRAINT  AI_STATUS_PK PRIMARY KEY(EVAL_PDATE,ID17)
);

-- import 1908 run
  /*
 db2 connect to cdcbdb
 db2 IMPORT FROM "/home/db2inst1/Data/1912/aistatus.819" OF DEL INSERT INTO TMP_AI_STATUS
 */
 

insert into AI_STATUS
select  21762 as eval_pdate,
		substring(line,1,17) as id17,
		substring(line,19,1) as Status_Code
from TMP_AI_STATUS;

 
 truncate table TMP_AI_STATUS immediate;
 
 -- import 1912 run
  /*
 db2 connect to cdcbdb
 db2 IMPORT FROM "/home/db2inst1/Data/1912/aistatus.C19" OF DEL INSERT INTO TMP_AI_STATUS
 */
 
 insert into AI_STATUS
select  21884 as eval_pdate,
		substring(line,1,17) as id17,
		substring(line,19,1) as Status_Code
from TMP_AI_STATUS;

  
  
  -- COW INFORMATION
create table TMP_BREED_COW_PTA_INFO_ANIM_CSV
(
 ID17 char(17),
 INFORMATION varchar(50),
 VALUE varchar(50)
);
 
  
create table BREED_COW_PTA_INFO_ANIM_CSV
(
 EVAL_PDATE smallint not null,
 ID17 varchar(17) not null,
 EVAL_BREED varchar(2),
 BLEND_CODE varchar(1),
 SEX varchar(1),
 SIRE17 varchar(17),
 DAM17 varchar(17),
 BIRTH varchar(8),
 ANIM_NAME varchar(30),
 NAAB_CODE varchar(10),
 SAMPLE_ID varchar(20),
 REQUESTER_ID varchar(30),
 CHIP varchar(50),
 DATE_RECEIVED varchar(8),
 AIS_FEE varchar(30),
 CURRENT varchar(30),
 GROUP_NAME varchar(30),
 HERD_CODE varchar(20),
 CTRL_NUM varchar(20),
 GEN_INB varchar(10),
 PED_INB varchar(10),
 GEN_FUT_INB varchar(10),
 EXP_FUT_INB varchar(10),
 HETEROSIS varchar(10),
 IMP_CALL_RATE varchar(10),
 IS_PTA_MILK varchar(1),
 IS_PTA_CT varchar(1) ,
 constraint BREED_COW_PTA_INFO_ANIM_CSV_PK primary key (EVAL_PDATE,ID17)
);


 /*    
  put in command file:
    connect to cdcbdb;
    IMPORT FROM /home/db2inst1/Data/1912/AY_Cow_PTA_infoANIM_1912.csv of del modified by coldel|  skipcount 2 INSERT INTO TMP_BREED_COW_PTA_INFO_ANIM_CSV;

 db2 -tvf /home/db2inst1/Data/1912/command.txt
 
 */   
insert into BREED_COW_PTA_INFO_ANIM_CSV
select 21884 as EVAL_PDATE,
       ID17, 
       max(case when INFORMATION ='EVAL_BREED' then value else null end) as EVAL_BREED,
       max(case when INFORMATION ='BLEND_CODE' then value else null end) as BLEND_CODE,
       max(case when INFORMATION ='SEX' then value else null end) as SEX,
       max(case when INFORMATION ='SIRE17' then value else null end) as SIRE17,
       max(case when INFORMATION ='DAM17' then value else null end) as DAM17,
       max(case when INFORMATION ='BIRTH' then value else null end) as BIRTH,
       max(case when INFORMATION ='ANIM_NAME' then value else null end) as ANIM_NAME,
       max(case when INFORMATION ='NAAB_CODE' then value else null end) as NAAB_CODE,
       max(case when INFORMATION ='SAMPLE_ID' then value else null end) as SAMPLE_ID,
       max(case when INFORMATION ='REQUESTER_ID' then value else null end) as REQUESTER_ID,
       max(case when INFORMATION ='CHIP' then value else null end) as CHIP,
       max(case when INFORMATION ='DATE_RECEIVED' then value else null end) as DATE_RECEIVED,
       max(case when INFORMATION ='AIS_FEE' then value else null end) as AIS_FEE,
       max(case when INFORMATION ='CURRENT' then value else null end) as CURRENT,
       max(case when INFORMATION ='GROUP_NAME' then value else null end) as GROUP_NAME,
       max(case when INFORMATION ='HERD_CODE' then value else null end) as HERD_CODE,
       max(case when INFORMATION ='CTRL_NUM' then value else null end) as CTRL_NUM,
       max(case when INFORMATION ='GEN_INB' then value else null end) as GEN_INB,
       max(case when INFORMATION ='PED_INB' then value else null end) as PED_INB,
       max(case when INFORMATION ='GEN_FUT_INB' then value else null end) as GEN_FUT_INB,
       max(case when INFORMATION ='EXP_FUT_INB' then value else null end) as EXP_FUT_INB,
       max(case when INFORMATION ='HETEROSIS' then value else null end) as HETEROSIS,
       max(case when INFORMATION ='IMP_CALL_RATE' then value else null end) as IMP_CALL_RATE,
       max(case when INFORMATION ='IS_PTA_MILK' then value else null end) as IS_PTA_MILK,
       max(case when INFORMATION ='IS_PTA_CT' then value else null end) as IS_PTA_CT 

from TMP_BREED_COW_PTA_INFO_ANIM_CSV
group by ID17;
 

 
 
-- YOUNG ANIMAL INFORMATON
create table TMP_BREED_YOUNG_INFO_ANIM_CSV
(
 ID17 char(17),
 INFORMATION varchar(50),
 VALUE varchar(50)
);
 
  
create table BREED_YOUNG_INFO_ANIM_CSV
(
 EVAL_PDATE smallint not null,
 ID17 varchar(17) not null,
 EVAL_BREED varchar(2),
 BLEND_CODE varchar(1),
 SEX varchar(1),
 SIRE17 varchar(17),
 DAM17 varchar(17),
 BIRTH varchar(8),
 ANIM_NAME varchar(30),
 NAAB_CODE varchar(10),
 SAMPLE_ID varchar(20),
 REQUESTER_ID varchar(30),
 CHIP varchar(50),
 DATE_RECEIVED varchar(8),
 AIS_FEE varchar(30),
 CURRENT varchar(30),
 GROUP_NAME varchar(30),
 HERD_CODE varchar(20),
 CTRL_NUM varchar(20),
 GEN_INB varchar(10),
 PED_INB varchar(10),
 GEN_FUT_INB varchar(10),
 EXP_FUT_INB varchar(10),
 HETEROSIS varchar(10),
 IMP_CALL_RATE varchar(10),
 IS_PTA_MILK varchar(1),
 IS_PTA_CT varchar(1) ,
 constraint BREED_YOUNG_INFO_ANIM_CSV_PK primary key (EVAL_PDATE,ID17)
);


 /*    
  put in command file:
    connect to cdcbdb;
    IMPORT FROM /home/db2inst1/Data/1912/AY_young_infoANIM_1912.csv of del modified by coldel|  skipcount 2 INSERT INTO TMP_BREED_YOUNG_INFO_ANIM_CSV;

 db2 -tvf /home/db2inst1/Data/1912/command.txt
 
 */   
 
 
insert into BREED_YOUNG_INFO_ANIM_CSV
select 21884 as EVAL_PDATE,
       ID17, 
       max(case when INFORMATION ='EVAL_BREED' then value else null end) as EVAL_BREED,
       max(case when INFORMATION ='BLEND_CODE' then value else null end) as BLEND_CODE,
       max(case when INFORMATION ='SEX' then value else null end) as SEX,
       max(case when INFORMATION ='SIRE17' then value else null end) as SIRE17,
       max(case when INFORMATION ='DAM17' then value else null end) as DAM17,
       max(case when INFORMATION ='BIRTH' then value else null end) as BIRTH,
       max(case when INFORMATION ='ANIM_NAME' then value else null end) as ANIM_NAME,
       max(case when INFORMATION ='NAAB_CODE' then value else null end) as NAAB_CODE,
       max(case when INFORMATION ='SAMPLE_ID' then value else null end) as SAMPLE_ID,
       max(case when INFORMATION ='REQUESTER_ID' then value else null end) as REQUESTER_ID,
       max(case when INFORMATION ='CHIP' then value else null end) as CHIP,
       max(case when INFORMATION ='DATE_RECEIVED' then value else null end) as DATE_RECEIVED,
       max(case when INFORMATION ='AIS_FEE' then value else null end) as AIS_FEE,
       max(case when INFORMATION ='CURRENT' then value else null end) as CURRENT,
       max(case when INFORMATION ='GROUP_NAME' then value else null end) as GROUP_NAME,
       max(case when INFORMATION ='HERD_CODE' then value else null end) as HERD_CODE,
       max(case when INFORMATION ='CTRL_NUM' then value else null end) as CTRL_NUM,
       max(case when INFORMATION ='GEN_INB' then value else null end) as GEN_INB,
       max(case when INFORMATION ='PED_INB' then value else null end) as PED_INB,
       max(case when INFORMATION ='GEN_FUT_INB' then value else null end) as GEN_FUT_INB,
       max(case when INFORMATION ='EXP_FUT_INB' then value else null end) as EXP_FUT_INB,
       max(case when INFORMATION ='HETEROSIS' then value else null end) as HETEROSIS,
       max(case when INFORMATION ='IMP_CALL_RATE' then value else null end) as IMP_CALL_RATE,
       max(case when INFORMATION ='IS_PTA_MILK' then value else null end) as IS_PTA_MILK,
       max(case when INFORMATION ='IS_PTA_CT' then value else null end) as IS_PTA_CT 

from TMP_BREED_YOUNG_INFO_ANIM_CSV
group by ID17;
 
 




-- BULL INFORMATON
create table TMP_BREED_BULL_INFO_ANIM_CSV
(
 ID17 char(17),
 INFORMATION varchar(50),
 VALUE varchar(50)
);
 
  
create table BREED_BULL_INFO_ANIM_CSV
(
 EVAL_PDATE smallint not null,
 ID17 varchar(17) not null,
 EVAL_BREED varchar(2),
 BLEND_CODE varchar(1),
 SEX varchar(1),
 SIRE17 varchar(17),
 DAM17 varchar(17),
 BIRTH varchar(8),
 ANIM_NAME varchar(30),
 NAAB_CODE varchar(10),
 SAMPLE_ID varchar(20),
 REQUESTER_ID varchar(30),
 CHIP varchar(50),
 DATE_RECEIVED varchar(8),
 AIS_FEE varchar(30),
 CURRENT varchar(30),
 GROUP_NAME varchar(30),
 HERD_CODE varchar(20),
 CTRL_NUM varchar(20),
 GEN_INB varchar(10),
 PED_INB varchar(10),
 GEN_FUT_INB varchar(10),
 EXP_FUT_INB varchar(10),
 HETEROSIS varchar(10),
 IMP_CALL_RATE varchar(10),
 IS_PTA_MILK varchar(1),
 IS_PTA_CT varchar(1) ,
 constraint BREED_BULL_INFO_ANIM_CSV_PK primary key (EVAL_PDATE,ID17)
);


 /*    
  put in command file:
    connect to cdcbdb;
    IMPORT FROM /home/db2inst1/Data/1912/AY_all_evaluated_infoANIM_1912.csv of del modified by coldel|  skipcount 2 INSERT INTO TMP_BREED_BULL_INFO_ANIM_CSV;

 db2 -tvf /home/db2inst1/Data/1912/command.txt
 
 */   
 
 
insert into BREED_BULL_INFO_ANIM_CSV
select 21884 as EVAL_PDATE,
       ID17, 
       max(case when INFORMATION ='EVAL_BREED' then value else null end) as EVAL_BREED,
       max(case when INFORMATION ='BLEND_CODE' then value else null end) as BLEND_CODE,
       max(case when INFORMATION ='SEX' then value else null end) as SEX,
       max(case when INFORMATION ='SIRE17' then value else null end) as SIRE17,
       max(case when INFORMATION ='DAM17' then value else null end) as DAM17,
       max(case when INFORMATION ='BIRTH' then value else null end) as BIRTH,
       max(case when INFORMATION ='ANIM_NAME' then value else null end) as ANIM_NAME,
       max(case when INFORMATION ='NAAB_CODE' then value else null end) as NAAB_CODE,
       max(case when INFORMATION ='SAMPLE_ID' then value else null end) as SAMPLE_ID,
       max(case when INFORMATION ='REQUESTER_ID' then value else null end) as REQUESTER_ID,
       max(case when INFORMATION ='CHIP' then value else null end) as CHIP,
       max(case when INFORMATION ='DATE_RECEIVED' then value else null end) as DATE_RECEIVED,
       max(case when INFORMATION ='AIS_FEE' then value else null end) as AIS_FEE,
       max(case when INFORMATION ='CURRENT' then value else null end) as CURRENT,
       max(case when INFORMATION ='GROUP_NAME' then value else null end) as GROUP_NAME,
       max(case when INFORMATION ='HERD_CODE' then value else null end) as HERD_CODE,
       max(case when INFORMATION ='CTRL_NUM' then value else null end) as CTRL_NUM,
       max(case when INFORMATION ='GEN_INB' then value else null end) as GEN_INB,
       max(case when INFORMATION ='PED_INB' then value else null end) as PED_INB,
       max(case when INFORMATION ='GEN_FUT_INB' then value else null end) as GEN_FUT_INB,
       max(case when INFORMATION ='EXP_FUT_INB' then value else null end) as EXP_FUT_INB,
       max(case when INFORMATION ='HETEROSIS' then value else null end) as HETEROSIS,
       max(case when INFORMATION ='IMP_CALL_RATE' then value else null end) as IMP_CALL_RATE,
       max(case when INFORMATION ='IS_PTA_MILK' then value else null end) as IS_PTA_MILK,
       max(case when INFORMATION ='IS_PTA_CT' then value else null end) as IS_PTA_CT 

from TMP_BREED_BULL_INFO_ANIM_CSV
group by ID17;

 
  
  
 -- TRAIT/INDEX GEN DATA
  
 CREATE TABLE ALL_GEN_EVAL_TABLE
 (
     eval_pdate smallint not null,
     eval_breed varchar(2) ,
	 blend_code varchar(1),
	 id17 varchar(17) not null,
	 sex varchar(1),
	 sire17 varchar(17),
	 dam17 varchar(17),
	 anim_name varchar(128),
	 naab_code varchar(10),
	 sample_ID varchar(128),
     NM_Gen varchar(10),
     CM_Gen varchar(10),
     FM_Gen varchar(10),
     GM_Gen varchar(10),
     NM_GenREL varchar(5),
     NM_GenPA varchar(10),
     NM_GenSons varchar(10),   
	 Milk_GenPTA varchar(10),
	 Fat_GenPTA varchar(10),
	 Pro_GenPTA varchar(10),
	 PL_GenPTA varchar(10) ,
	 SCS_GenPTA varchar(10),
	 DPR_GenPTA varchar(10),
	 HCR_GenPTA varchar(10),
	 CCR_GenPTA varchar(10),
	 LIV_GenPTA varchar(10),
	 GL_GenPTA varchar(10),
	 MFV_GenPTA varchar(10),
	 DAB_GenPTA varchar(10),
	 KET_GenPTA varchar(10),
	 MAS_GenPTA varchar(10),
	 MET_GenPTA varchar(10),
	 RPL_GenPTA varchar(10),
	 EFC_GenPTA varchar(10),
	 FatPct_GenPTA varchar(10),
	 ProPct_GenPTA varchar(10),
	 Milk_GenREL varchar(5),
	 Fat_GenREL varchar(5),
	 Pro_GenREL varchar(5),
	 PL_GenREL varchar(5),
	 SCS_GenREL varchar(5),
	 DPR_GenREL varchar(5),
	 HCR_GenREL varchar(5),
	 CCR_GenREL varchar(5),
	 LIV_GenREL varchar(5),
	 GL_GenREL varchar(5),
	 MFV_GenREL varchar(5),
	 DAB_GenREL varchar(5),
	 KET_GenREL varchar(5),
	 MAS_GenREL varchar(5),
	 MET_GenREL varchar(5),
	 RPL_GenREL varchar(5),
	 EFC_GenREL varchar(5),
	 FatPct_GenREL varchar(5),
	 ProPct_GenREL varchar(5) ,
	 Milk_GenPA varchar(10),
	 Fat_GenPA varchar(10),
	 Pro_GenPA varchar(10),
	 PL_GenPA varchar(10),
	 SCS_GenPA varchar(10),
	 DPR_GenPA varchar(10),
	 HCR_GenPA varchar(10),
	 CCR_GenPA varchar(10),
	 LIV_GenPA varchar(10),
	 GL_GenPA varchar(10),
	 MFV_GenPA varchar(10),
	 DAB_GenPA varchar(10),
	 KET_GenPA varchar(10),
	 MAS_GenPA varchar(10),
	 MET_GenPA varchar(10) ,
	 RPL_GenPA varchar(10),
	 EFC_GenPA varchar(10),
	 FatPct_GenPA varchar(10),
	 ProPct_GenPA varchar(10),
	 Milk_GenSons varchar(10),
	 Fat_GenSons varchar(10),
	 Pro_GenSons varchar(10),
	 PL_GenSons varchar(10) ,
	 SCS_GenSons varchar(10),
	 DPR_GenSons varchar(10),
	 HCR_GenSons varchar(10),
	 CCR_GenSons varchar(10),
	 LIV_GenSons varchar(10),
	 GL_GenSons varchar(10),
	 MFV_GenSons varchar(10),
	 DAB_GenSons varchar(10),
	 KET_GenSons varchar(10),
	 MAS_GenSons varchar(10),
	 MET_GenSons varchar(10),
	 RPL_GenSons varchar(10),
	 EFC_GenSons varchar(10),
	 FatPct_GenSons varchar(10),
	 ProPct_GenSons varchar(10) ,
	 Gen_Inb varchar(10),
	 Ped_Inb varchar(10),
	 Gen_Fut_Inb varchar(10),
	 Exp_Fut_Inb varchar(10),
	 Heterosis varchar(3),
	 is_PTA_milk varchar(1),
	 is_PTA_ct varchar(1), 
	 constraint  ALL_GEN_EVAL_TABLE_PK primary key (eval_pdate,id17)
 
 );
 
  
  
  INSERT INTO ALL_GEN_EVAL_TABLE
   
  SELECT  21884 AS eval_pdate,
		 XML_BOOKS.* 	 
		FROM (
				  select * 
				  from TMP_BREED_ALL_NEW_GENOTYPED_XML 
				  where line like '<Record%' 
			 ) d, 
		XMLTABLE(
		'$doc/Record' 
		PASSING xmlparse(document d.line) AS "doc"
		COLUMNS 
		 eval_breed varchar(2) path '@eval_breed',
		 blend_code varchar(1) path '@blend_code',
		 id17 varchar(17) path '@id17',
		 sex varchar(1) path '@sex',
		 sire17 varchar(17) path '@sire17',
		 dam17 varchar(17) path '@dam17',
		 anim_name varchar(128) path '@anim_name',
		 naab_code varchar(10) path '@naab_code',
		 sample_ID varchar(128) path '@sample_ID',
         NM_Gen varchar(10) path '@NM_Gen',
         CM_Gen varchar(10) path '@CM_Gen',
         FM_Gen varchar(10) path '@FM_Gen',
         GM_Gen varchar(10) path '@GM_Gen',
         NM_GenREL varchar(5) path '@NM_GenREL',
         NM_GenPA varchar(10) path '@NM_GenPA',
         NM_GenSons varchar(10) path '@NM_GenSons',   
		 Milk_GenPTA varchar(10) path '@Milk_GenPTA',
		 Fat_GenPTA varchar(10) path '@Fat_GenPTA',
		 Pro_GenPTA varchar(10) path '@Pro_GenPTA',
		 PL_GenPTA varchar(10) path '@PL_GenPTA',
		 SCS_GenPTA varchar(10) path '@SCS_GenPTA',
		 DPR_GenPTA varchar(10) path '@DPR_GenPTA',
		 HCR_GenPTA varchar(10) path '@HCR_GenPTA',
		 CCR_GenPTA varchar(10) path '@CCR_GenPTA',
		 LIV_GenPTA varchar(10) path '@LIV_GenPTA',
		 GL_GenPTA varchar(10) path '@GL_GenPTA',
		 MFV_GenPTA varchar(10) path '@MFV_GenPTA',
		 DAB_GenPTA varchar(10) path '@DAB_GenPTA',
		 KET_GenPTA varchar(10) path '@KET_GenPTA',
		 MAS_GenPTA varchar(10) path '@MAS_GenPTA',
		 MET_GenPTA varchar(10) path '@MET_GenPTA',
		 RPL_GenPTA varchar(10) path '@RPL_GenPTA',
		 EFC_GenPTA varchar(10) path '@EFC_GenPTA',
		 FatPct_GenPTA varchar(10) path '@FatPct_GenPTA',
		 ProPct_GenPTA varchar(10) path '@ProPct_GenPTA',
		 Milk_GenREL varchar(5) path '@Milk_GenREL',
		 Fat_GenREL varchar(5) path '@Fat_GenREL',
		 Pro_GenREL varchar(5) path '@Pro_GenREL',
		 PL_GenREL varchar(5) path '@PL_GenREL',
		 SCS_GenREL varchar(5) path '@SCS_GenREL',
		 DPR_GenREL varchar(5) path '@DPR_GenREL',
		 HCR_GenREL varchar(5) path '@HCR_GenREL',
		 CCR_GenREL varchar(5) path '@CCR_GenREL',
		 LIV_GenREL varchar(5) path '@LIV_GenREL',
		 GL_GenREL varchar(5) path '@GL_GenREL',
		 MFV_GenREL varchar(5) path '@MFV_GenREL',
		 DAB_GenREL varchar(5) path '@DAB_GenREL',
		 KET_GenREL varchar(5) path '@KET_GenREL',
		 MAS_GenREL varchar(5) path '@MAS_GenREL',
		 MET_GenREL varchar(5) path '@MET_GenREL',
		 RPL_GenREL varchar(5) path '@RPL_GenREL',
		 EFC_GenREL varchar(5) path '@EFC_GenREL',
		 FatPct_GenREL varchar(5) path '@FatPct_GenREL',
		 ProPct_GenREL varchar(5) path '@ProPct_GenREL',
		 Milk_GenPA varchar(10) path '@Milk_GenPA',
		 Fat_GenPA varchar(10) path '@Fat_GenPA',
		 Pro_GenPA varchar(10) path '@Pro_GenPA',
		 PL_GenPA varchar(10) path '@PL_GenPA',
		 SCS_GenPA varchar(10) path '@SCS_GenPA',
		 DPR_GenPA varchar(10) path '@DPR_GenPA',
		 HCR_GenPA varchar(10) path '@HCR_GenPA',
		 CCR_GenPA varchar(10) path '@CCR_GenPA',
		 LIV_GenPA varchar(10) path '@LIV_GenPA',
		 GL_GenPA varchar(10) path '@GL_GenPA',
		 MFV_GenPA varchar(10) path '@MFV_GenPA',
		 DAB_GenPA varchar(10) path '@DAB_GenPA',
		 KET_GenPA varchar(10) path '@KET_GenPA',
		 MAS_GenPA varchar(10) path '@MAS_GenPA',
		 MET_GenPA varchar(10) path '@MET_GenPA',
		 RPL_GenPA varchar(10) path '@RPL_GenPA',
		 EFC_GenPA varchar(10) path '@EFC_GenPA',
		 FatPct_GenPA varchar(10) path '@FatPct_GenPA',
		 ProPct_GenPA varchar(10) path '@ProPct_GenPA',
		 Milk_GenSons varchar(10) path '@Milk_GenSons',
		 Fat_GenSons varchar(10) path '@Fat_GenSons',
		 Pro_GenSons varchar(10) path '@Pro_GenSons',
		 PL_GenSons varchar(10) path '@PL_GenSons',
		 SCS_GenSons varchar(10) path '@SCS_GenSons',
		 DPR_GenSons varchar(10) path '@DPR_GenSons',
		 HCR_GenSons varchar(10) path '@HCR_GenSons',
		 CCR_GenSons varchar(10) path '@CCR_GenSons',
		 LIV_GenSons varchar(10) path '@LIV_GenSons',
		 GL_GenSons varchar(10) path '@GL_GenSons',
		 MFV_GenSons varchar(10) path '@MFV_GenSons',
		 DAB_GenSons varchar(10) path '@DAB_GenSons',
		 KET_GenSons varchar(10) path '@KET_GenSons',
		 MAS_GenSons varchar(10) path '@MAS_GenSons',
		 MET_GenSons varchar(10) path '@MET_GenSons',
		 RPL_GenSons varchar(10) path '@RPL_GenSons',
		 EFC_GenSons varchar(10) path '@EFC_GenSons',
		 FatPct_GenSons varchar(10) path '@FatPct_GenSons',
		 ProPct_GenSons varchar(10) path '@ProPct_GenSons',
		 Gen_Inb varchar(10) path '@Gen_Inb',
		 Ped_Inb varchar(10) path '@Ped_Inb',
		 Gen_Fut_Inb varchar(10) path '@Gen_Fut_Inb',
		 Exp_Fut_Inb varchar(10) path '@Exp_Fut_Inb',
		 Heterosis varchar(3) path '@Heterosis',
		 is_PTA_milk varchar(1) path '@is_PTA_milk',
		 is_PTA_ct varchar(1) path '@is_PTA_ct' 
		 
		) AS XML_BOOKS;    
		


 
 CREATE TABLE ALL_TRAD_EVAL_TABLE
 (
     eval_pdate smallint not null,
     eval_breed varchar(2) ,
	 blend_code varchar(1),
	 id17 varchar(17) not null,
	 sex varchar(1),
	 sire17 varchar(17),
	 dam17 varchar(17),
	 anim_name varchar(128),
	 naab_code varchar(10),
	 NM_Trad varchar(10),
     CM_Trad varchar(10),
     FM_Trad varchar(10),
     GM_Trad varchar(10),
     NM_TradREL varchar(5), 
     Milk_Trad varchar(10),
	 Fat_Trad varchar(10),
	 Pro_Trad varchar(10),
	 PL_Trad varchar(10),
	 SCS_Trad varchar(10),
	 DPR_Trad varchar(10),
	 HCR_Trad varchar(10),
	 CCR_Trad varchar(10),
	 LIV_Trad varchar(10),
	 GL_Trad varchar(10),
	 MFV_Trad varchar(10),
	 DAB_Trad varchar(10),
	 KET_Trad varchar(10),
	 MAS_Trad varchar(10),
	 MET_Trad varchar(10),
	 RPL_Trad varchar(10),
	 EFC_Trad varchar(10),
	 FatPct_Trad varchar(10),
	 ProPct_Trad varchar(10),
	 Milk_TradREL varchar(5),
	 Fat_TradREL varchar(5),
	 Pro_TradREL varchar(5),
	 PL_TradREL varchar(5),
	 SCS_TradREL varchar(5),
	 DPR_TradREL varchar(5),
	 HCR_TradREL varchar(5),
	 CCR_TradREL varchar(5),
	 LIV_TradREL varchar(5),
	 GL_TradREL varchar(5),
	 MFV_TradREL varchar(5),
	 DAB_TradREL varchar(5),
	 KET_TradREL varchar(5),
	 MAS_TradREL varchar(5),
	 MET_TradREL varchar(5),
	 RPL_TradREL varchar(5),
	 EFC_TradREL varchar(5),
	 FatPct_TradREL varchar(5),
	 ProPct_TradREL varchar(5),
	 CONSTRAINT ALL_TRAD_EVAL_TABLE_PK PRIMARY KEY (eval_pdate,id17)
 );		
		


INSERT INTO ALL_TRAD_EVAL_TABLE
  SELECT  21884 AS eval_pdate,
		 XML_BOOKS.* 	 
		FROM (
				  select * 
				  from TMP_BREED_ALL_NEW_GENOTYPED_XML 
				  where line like '<Record%' 
			 ) d, 
		XMLTABLE(
		'$doc/Record' 
		PASSING xmlparse(document d.line) AS "doc"
		COLUMNS 
		 eval_breed varchar(2) path '@eval_breed',
		 blend_code varchar(1) path '@blend_code',
		 id17 varchar(17) path '@id17',
		 sex varchar(1) path '@sex',
		 sire17 varchar(17) path '@sire17',
		 dam17 varchar(17) path '@dam17',
		 anim_name varchar(128) path '@anim_name',
		 naab_code varchar(10) path '@naab_code',  
         NM_Trad varchar(10) path '@NM_Trad',
         CM_Trad varchar(10) path '@CM_Trad',
         FM_Trad varchar(10) path '@FM_Trad',
         GM_Trad varchar(10) path '@GM_Trad',
         NM_TradREL varchar(5) path '@NM_TradREL', 
         Milk_Trad varchar(10) path '@Milk_Trad',
		 Fat_Trad varchar(10) path '@Fat_Trad',
		 Pro_Trad varchar(10) path '@Pro_Trad',
		 PL_Trad varchar(10) path '@PL_Trad',
		 SCS_Trad varchar(10) path '@SCS_Trad',
		 DPR_Trad varchar(10) path '@DPR_Trad',
		 HCR_Trad varchar(10) path '@HCR_Trad',
		 CCR_Trad varchar(10) path '@CCR_Trad',
		 LIV_Trad varchar(10) path '@LIV_Trad',
		 GL_Trad varchar(10) path '@GL_Trad',
		 MFV_Trad varchar(10) path '@MFV_Trad',
		 DAB_Trad varchar(10) path '@DAB_Trad',
		 KET_Trad varchar(10) path '@KET_Trad',
		 MAS_Trad varchar(10) path '@MAS_Trad',
		 MET_Trad varchar(10) path '@MET_Trad',
		 RPL_Trad varchar(10) path '@RPL_Trad',
		 EFC_Trad varchar(10) path '@EFC_Trad',
		 FatPct_Trad varchar(10) path '@FatPct_Trad',
		 ProPct_Trad varchar(10) path '@ProPct_Trad',
		 Milk_TradREL varchar(5) path '@Milk_TradREL',
		 Fat_TradREL varchar(5) path '@Fat_TradREL',
		 Pro_TradREL varchar(5) path '@Pro_TradREL',
		 PL_TradREL varchar(5) path '@PL_TradREL',
		 SCS_TradREL varchar(5) path '@SCS_TradREL',
		 DPR_TradREL varchar(5) path '@DPR_TradREL',
		 HCR_TradREL varchar(5) path '@HCR_TradREL',
		 CCR_TradREL varchar(5) path '@CCR_TradREL',
		 LIV_TradREL varchar(5) path '@LIV_TradREL',
		 GL_TradREL varchar(5) path '@GL_TradREL',
		 MFV_TradREL varchar(5) path '@MFV_TradREL',
		 DAB_TradREL varchar(5) path '@DAB_TradREL',
		 KET_TradREL varchar(5) path '@KET_TradREL',
		 MAS_TradREL varchar(5) path '@MAS_TradREL',
		 MET_TradREL varchar(5) path '@MET_TradREL',
		 RPL_TradREL varchar(5) path '@RPL_TradREL',
		 EFC_TradREL varchar(5) path '@EFC_TradREL',
		 FatPct_TradREL varchar(5) path '@FatPct_TradREL',
		 ProPct_TradREL varchar(5) path '@ProPct_TradREL'
		 
		) AS XML_BOOKS;    
		
	 
	 
	 

 
 CREATE TABLE ALL_DGV_EVAL_TABLE
 (
     eval_pdate smallint not null,
     eval_breed varchar(2) ,
	 blend_code varchar(1),
	 id17 varchar(17) not null,
	 sex varchar(1),
	 sire17 varchar(17),
	 dam17 varchar(17),
	 anim_name varchar(128),
	 naab_code varchar(10),
	 NM_DGV varchar(10),
     Milk_DGV varchar(10),
	 Fat_DGV varchar(10),
	 Pro_DGV varchar(10),
	 PL_DGV varchar(10),
	 SCS_DGV varchar(10),
	 DPR_DGV varchar(10),
	 HCR_DGV varchar(10),
	 CCR_DGV varchar(10),
	 LIV_DGV varchar(10),
	 GL_DGV varchar(10),
	 MFV_DGV varchar(10),
	 DAB_DGV varchar(10) ,
	 KET_DGV varchar(10),
	 MAS_DGV varchar(10),
	 MET_DGV varchar(10),
	 RPL_DGV varchar(10),
	 EFC_DGV varchar(10),
	 FatPct_DGV varchar(10),
	 ProPct_DGV varchar(10),
	 CONSTRAINT ALL_DGV_EVAL_TABLE_PK PRIMARY KEY (eval_pdate,id17)
 );		
		


INSERT INTO ALL_DGV_EVAL_TABLE
  SELECT  21884 AS eval_pdate,
		 XML_BOOKS.* 	 
		FROM (
				  select * 
				  from TMP_BREED_ALL_NEW_GENOTYPED_XML 
				  where line like '<Record%' 
			 ) d, 
		XMLTABLE(
		'$doc/Record' 
		PASSING xmlparse(document d.line) AS "doc"
		COLUMNS 
		 eval_breed varchar(2) path '@eval_breed',
		 blend_code varchar(1) path '@blend_code',
		 id17 varchar(17) path '@id17',
		 sex varchar(1) path '@sex',
		 sire17 varchar(17) path '@sire17',
		 dam17 varchar(17) path '@dam17',
		 anim_name varchar(128) path '@anim_name',
		 naab_code varchar(10) path '@naab_code',  
		 NM_DGV varchar(10) path '@NM_DGV',
         Milk_DGV varchar(10) path '@Milk_DGV',
		 Fat_DGV varchar(10) path '@Fat_DGV',
		 Pro_DGV varchar(10) path '@Pro_DGV',
		 PL_DGV varchar(10) path '@PL_DGV',
		 SCS_DGV varchar(10) path '@SCS_DGV',
		 DPR_DGV varchar(10) path '@DPR_DGV',
		 HCR_DGV varchar(10) path '@HCR_DGV',
		 CCR_DGV varchar(10) path '@CCR_DGV',
		 LIV_DGV varchar(10) path '@LIV_DGV',
		 GL_DGV varchar(10) path '@GL_DGV',
		 MFV_DGV varchar(10) path '@MFV_DGV',
		 DAB_DGV varchar(10) path '@DAB_DGV',
		 KET_DGV varchar(10) path '@KET_DGV',
		 MAS_DGV varchar(10) path '@MAS_DGV',
		 MET_DGV varchar(10) path '@MET_DGV',
		 RPL_DGV varchar(10) path '@RPL_DGV',
		 EFC_DGV varchar(10) path '@EFC_DGV',
		 FatPct_DGV varchar(10) path '@FatPct_DGV',
		 ProPct_DGV varchar(10) path '@ProPct_DGV' 
		 
		) AS XML_BOOKS;    
		
	
  ALTER TABLE ALL_GEN_EVAL_TABLE ADD PTAT_GenPTA varchar(10);
  ALTER TABLE ALL_GEN_EVAL_TABLE ADD PTAT_GenREL varchar(5);
  ALTER TABLE ALL_TRAD_EVAL_TABLE ADD PTAT_Trad varchar(10);
  ALTER TABLE ALL_TRAD_EVAL_TABLE ADD PTAT_TradREL varchar(5);    
            
  
         
         
MERGE INTO ALL_GEN_EVAL_TABLE AS A
USING (

	  SELECT  21884 AS eval_pdate,
			 XML_BOOKS.* 	 
			FROM (
					  select * 
					  from TMP_BREED_ALL_NEW_GENOTYPED_XML 
					  where line like '<Record%' 
				 ) d, 
			XMLTABLE(
			'$doc/Record' 
			PASSING xmlparse(document d.line) AS "doc"
			COLUMNS 
			 id17 varchar(17) path '@id17',
			 PTAT_GenPTA varchar(10) path '@PTAT_GenPTA',
			 PTAT_GenREL varchar(5) path '@PTAT_GenREL' 
			  
			) AS XML_BOOKS 

) AS B
ON A.id17 =B.id17
and A.eval_pdate =B.eval_pdate
WHEN MATCHED THEN UPDATE 
SET PTAT_GenPTA = B.PTAT_GenPTA,
PTAT_GenREL = B.PTAT_GenREL 
;


         
MERGE INTO ALL_TRAD_EVAL_TABLE AS A
USING (

	  SELECT  21884 AS eval_pdate,
			 XML_BOOKS.* 	 
			FROM (
					  select * 
					  from TMP_BREED_ALL_NEW_GENOTYPED_XML 
					  where line like '<Record%' 
				 ) d, 
			XMLTABLE(
			'$doc/Record' 
			PASSING xmlparse(document d.line) AS "doc"
			COLUMNS 
			 id17 varchar(17) path '@id17',
			 PTAT_Trad varchar(10) path '@PTAT_Trad',
			 PTAT_TradREL varchar(5) path '@PTAT_TradREL' 
			  
			) AS XML_BOOKS 

) AS B
ON A.id17 =B.id17
and A.eval_pdate =B.eval_pdate
WHEN MATCHED THEN UPDATE 
SET PTAT_Trad = B.PTAT_Trad,
PTAT_TradREL = B.PTAT_TradREL 
;
 
	
 -- Parse CT but no data
 /*
 
  SELECT  21884 AS eval_pdate,
		 XML_BOOKS.* 	 
		FROM (
				  select * 
				  from TMP_BREED_ALL_NEW_GENOTYPED_XML 
				  where line like '<Record%' 
			 ) d, 
		XMLTABLE(
		'$doc/Record' 
		PASSING xmlparse(document d.line) AS "doc"
		COLUMNS 
		 eval_breed varchar(2) path '@eval_breed',
		 blend_code varchar(1) path '@blend_code',
		 id17 varchar(17) path '@id17',
		 sex varchar(1) path '@sex',
		 sire17 varchar(17) path '@sire17',
		 dam17 varchar(17) path '@dam17',
		 anim_name varchar(128) path '@anim_name',
		 naab_code varchar(10) path '@naab_code',   
		 SCE_GenPTA varchar(10) path '@SCE_GenPTA',
         SCE_GenREL varchar(10) path '@SCE_GenREL',
		 SCE_GenPA varchar(10) path '@SCE_GenPA',
		 SCE_GenSons varchar(10) path '@SCE_GenSons',
		 SCE_Trad varchar(10) path '@SCE_Trad',
		 SCE_TradREL varchar(10) path '@SCE_TradREL',
		 DCE_GenPTA varchar(10) path '@DCE_GenPTA',
		 DCE_GenREL varchar(10) path '@DCE_GenREL',
		 DCE_GenPA varchar(10) path '@DCE_GenPA',
		 DCE_GenSons varchar(10) path '@DCE_GenSons',
		 DCE_Trad varchar(10) path '@DCE_Trad',
		 DCE_TradREL varchar(10) path '@DCE_TradREL',
		 SSB_GenPTA varchar(10) path '@SSB_GenPTA',
		 SSB_GenREL varchar(10) path '@SSB_GenREL',
		 SSB_GenPA varchar(10) path '@SSB_GenPA',
		 SSB_GenSons varchar(10) path '@SSB_GenSons',
		 SSB_Trad varchar(10) path '@SSB_Trad',
		 SSB_TradREL varchar(10) path '@SSB_TradREL',
		 DSB_GenPTA varchar(10) path '@DSB_GenPTA',
		 DSB_GenREL varchar(10) path '@DSB_GenREL' ,
		 DSB_GenPA varchar(10) path '@DSB_GenPA' ,
		 DSB_GenSons varchar(10) path '@DSB_GenSons' ,
		 DSB_Trad varchar(10) path '@DSB_Trad' ,
		 DSB_TradREL varchar(10) path '@DSB_TradREL'  
		) AS XML_BOOKS
		
		WHERE  XML_BOOKS.SCE_GenPTA <>''
		
	 
	*/
	 