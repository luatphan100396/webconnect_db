

--- ERROR1_TABLE
create table TMP_ERROR1_TABLE
   (ANIM_ID_NUM                  char(12)      not null,
    BREED_CODE                   char(2)       not null,
    COUNTRY_CODE                 char(3)       not null,
    ANIM_KEY                     integer       not null,
    SIRE_KEY                     integer,
    SOURCE_FILE_NAME             char(9)       not null,
    BASE_RECORD                  char(140)     not null,
    ERR_SEGMENT_QTY              char(1)       not null  default X'00' for bit data,
    ERR_SEGMENT_RECORD           varchar(222)  not null
    );
    
 /*   
cd /home/db2inst1/Data/Goat/20200716.DataGene.GOATS;
db2 connect to cdcbdb; 
db2 "load from export.ERROR1.20200716 of ixf warningcount 0 messages msg.txt insert into TMP_ERROR1_TABLE nonrecoverable"
 */   
  

MERGE INTO ERROR1_TABLE AS A
USING (
		SELECT  *
		from TMP_ERROR1_TABLE n
		where left( base_record,1) in ('0','1')  
) AS B
ON A.ANIM_ID_NUM =B.ANIM_ID_NUM
and A.BREED_CODE =B.BREED_CODE
and A.COUNTRY_CODE =B.COUNTRY_CODE
WHEN NOT MATCHED THEN 
INSERT (ANIM_ID_NUM ,
    BREED_CODE,
    COUNTRY_CODE,
    ANIM_KEY,
    SIRE_KEY,
    SOURCE_FILE_NAME,
    BASE_RECORD ,
    ERR_SEGMENT_QTY ,
    ERR_SEGMENT_RECORD )
  values (
   B.ANIM_ID_NUM ,
    B.BREED_CODE,
    B.COUNTRY_CODE,
    B.ANIM_KEY,
    B.SIRE_KEY,
    B.SOURCE_FILE_NAME,
    B.BASE_RECORD ,
    B.ERR_SEGMENT_QTY ,
    B.ERR_SEGMENT_RECORD  
  )
;

drop table TMP_ERROR1_TABLE;





--- ERROR4_TABLE

create table TMP_ERROR4_TABLE
   (ANIM_ID_NUM                  char(12)      not null,
    BREED_CODE                   char(2)       not null,
    COUNTRY_CODE                 char(3)       not null,
    CALV_PDATE                   smallint      not null,
    DIM_QTY                      smallint      not null,
    HERD_CODE                    integer       not null,
    CTRL_NUM                     integer       not null,
    ANIM_KEY                     integer       not null,
    SIRE_KEY                     integer,
    SOURCE_FILE_NAME             char(9)       not null,
    BASE_RECORD                  char(248)     not null,
    TD_SEGMENT_QTY               char(1)       not null                for bit data,
--                the above field is one byte binary
    TD_SEGMENT_RECORD            varchar(460)  not null,
    ERR_SEGMENT_QTY              char(1)       not null                for bit data,
--                the above field is one byte binary
    ERR_SEGMENT_RECORD           varchar(222)  not null
    );
    
    
    
 /*   
cd /home/db2inst1/Data/Goat/20200716.DataGene.GOATS;
db2 connect to cdcbdb; 
db2 "load from export.ERROR4.20200716.new_data of ixf warningcount 0 messages msg.txt insert into TMP_ERROR4_TABLE nonrecoverable"
 */   
  

MERGE INTO ERROR4_TABLE AS A
USING (
		SELECT  *
		from TMP_ERROR4_TABLE n 
) AS B
ON A.ANIM_ID_NUM =B.ANIM_ID_NUM
and A.BREED_CODE =B.BREED_CODE
and A.COUNTRY_CODE =B.COUNTRY_CODE
WHEN NOT MATCHED THEN 
INSERT (
	 ANIM_ID_NUM,
	 ANIM_KEY,
	 BASE_RECORD,
	 BREED_CODE,
	 CALV_PDATE,
	 COUNTRY_CODE,
	 CTRL_NUM,
	 DIM_QTY,
	 ERR_SEGMENT_QTY,
	 ERR_SEGMENT_RECORD,
	 HERD_CODE,
	 SIRE_KEY,
	 SOURCE_FILE_NAME,
	 TD_SEGMENT_QTY,
	 TD_SEGMENT_RECORD
 )
  values (
     B.ANIM_ID_NUM,
	 B.ANIM_KEY,
	 B.BASE_RECORD,
	 B.BREED_CODE,
	 B.CALV_PDATE,
	 B.COUNTRY_CODE,
	 B.CTRL_NUM,
	 B.DIM_QTY,
	 B.ERR_SEGMENT_QTY,
	 B.ERR_SEGMENT_RECORD,
	 B.HERD_CODE,
	 B.SIRE_KEY,
	 B.SOURCE_FILE_NAME,
	 B.TD_SEGMENT_QTY,
	 B.TD_SEGMENT_RECORD
  )
;

drop table TMP_ERROR4_TABLE; 


create table TMP_ERROR5_TABLE
   (SPECIES_CODE                 char(1)       not null,
    ANIM_ID_NUM                  char(12)      not null,
    BREED_CODE                   char(2)       not null,
    COUNTRY_CODE                 char(3)       not null,
    CALV_PDATE                   smallint      not null,
    HERD_CODE                    integer       not null,
    PROC_PDATE                   smallint      not null,
    CTRL_NUM                     integer       not null,
    ANIM_KEY                     integer       not null,
    SIRE_KEY                     integer,
    SOURCE_FILE_NAME             char(9)       not null,
    BASE_RECORD                  char(135)     not null,
    REPROD_EVT_CNT               char(1)       not null  default X'00' for bit data,
    REPROD_EVT_SEG               varchar(600)  not null  default,

    ERR_SEGMENT_QTY              char(1)       not null                for bit data,
    ERR_SEGMENT_RECORD           varchar(222)  not null
   );
   
 /*
 cd /home/db2inst1/Data/Goat/20200716.DataGene.GOATS;
db2 connect to cdcbdb; 
db2 "load from export.ERROR5.20200716 of ixf warningcount 0 messages msg.txt insert into TMP_ERROR5_TABLE nonrecoverable"
   */  





MERGE INTO ERROR5_TABLE AS A
USING (
		SELECT *
		from TMP_ERROR5_TABLE n 
) AS B
ON A.SPECIES_CODE =B.SPECIES_CODE
and A.ANIM_ID_NUM =B.ANIM_ID_NUM
and A.BREED_CODE =B.BREED_CODE
and A.COUNTRY_CODE =B.COUNTRY_CODE
and A.CALV_PDATE =B.CALV_PDATE
and A.HERD_CODE =B.HERD_CODE
and A.PROC_PDATE =B.PROC_PDATE
WHEN NOT MATCHED THEN 
INSERT ( 
 ANIM_ID_NUM,
 ANIM_KEY,
 BASE_RECORD,
 BREED_CODE,
 CALV_PDATE,
 COUNTRY_CODE,
 CTRL_NUM,
 ERR_SEGMENT_QTY,
 ERR_SEGMENT_RECORD,
 HERD_CODE,
 PROC_PDATE,
 REPROD_EVT_CNT,
 REPROD_EVT_SEG,
 SIRE_KEY,
 SOURCE_FILE_NAME,
 SPECIES_CODE
 )
  values (
  B.ANIM_ID_NUM,
 B.ANIM_KEY,
 B.BASE_RECORD,
 B.BREED_CODE,
 B.CALV_PDATE,
 B.COUNTRY_CODE,
 B.CTRL_NUM,
 B.ERR_SEGMENT_QTY,
 B.ERR_SEGMENT_RECORD,
 B.HERD_CODE,
 B.PROC_PDATE,
 B.REPROD_EVT_CNT,
 B.REPROD_EVT_SEG,
 B.SIRE_KEY,
 B.SOURCE_FILE_NAME,
 B.SPECIES_CODE
  )
;

DROP TABLE TMP_ERROR5_TABLE;

-- ID_XREF_TABLE 
                              
create table TMP_ID_XREF_TABLE                         
   (ANIM_ID_NUM                  char(12)      not null,
    BREED_CODE                   char(2)       not null,
    COUNTRY_CODE                 char(3)       not null,
    SEX_CODE                     char(1)       not null,

    ANIM_KEY                     integer       not null,
    PREFERRED_CODE               char(1)       not null,

    REGIS_STATUS_CODE            char(2)       not null,

    SOURCE_CODE                  char(1)       not null,
--       As of 12/00, this field no longer corresponds to the source
--       of the modify date. It now represents the highest source
--       of touch of the row. This was needed because we were
--       losing breed supplied ids in the new twinrtn reid section.

    MODIFY_PDATE                 smallint      not null  default -21916,
    SPECIES_CODE                 char(1)       not null,

    INIT_TIMESTAMP               TIMESTAMP     default null,
    INIT_PATH_ADDR               varchar(320)  default null
);

/*
cd /home/db2inst1/Data/Goat/20200716.DataGene.GOATS;
db2 connect to cdcbdb; 
db2 "load from export.ID_XREF.20200716 of ixf warningcount 0 messages msg.txt insert into TMP_ID_XREF_TABLE nonrecoverable"
*/    


MERGE INTO ID_XREF_TABLE AS A
USING (
		SELECT  *
		from TMP_ID_XREF_TABLE 
) AS B
ON A.SPECIES_CODE = B.SPECIES_CODE
and A.ANIM_ID_NUM = B.ANIM_ID_NUM
and A.BREED_CODE = B.BREED_CODE
and A.COUNTRY_CODE = B.COUNTRY_CODE
and A.SEX_CODE = B.SEX_CODE 
WHEN NOT MATCHED THEN 
INSERT (  
 ANIM_ID_NUM,
 ANIM_KEY,
 BREED_CODE,
 COUNTRY_CODE,
 INT_ID,
 INIT_PATH_ADDR,
 INIT_TIMESTAMP, 
 MODIFY_PDATE,
 PREFERRED_CODE,
 REGIS_STATUS_CODE,
 SEX_CODE,
 SOURCE_CODE,
 SPECIES_CODE
 )
  values (
	  B.ANIM_ID_NUM,
	 B.ANIM_KEY,
	 B.BREED_CODE,
	 B.COUNTRY_CODE,
	 B.BREED_CODE||B.COUNTRY_CODE || B.ANIM_ID_NUM ,
	 B.INIT_PATH_ADDR,
	 B.INIT_TIMESTAMP, 
	 B.MODIFY_PDATE,
	 B.PREFERRED_CODE,
	 B.REGIS_STATUS_CODE,
	 B.SEX_CODE,
	 B.SOURCE_CODE,
	 B.SPECIES_CODE
  )
;

DROP TABLE TMP_ID_XREF_TABLE;



-- PEDIGREE_TABLE


create table TMP_PEDIGREE_TABLE                        
   (ANIM_KEY                     integer       not null,

    SEX_CODE                     char(1)       not null,
    SIRE_KEY                     integer,
    DAM_KEY                      integer,
    BIRTH_PDATE                  smallint,

    MULTI_BIRTH_CODE             char(1)       not null,
--                  1 = Single
--                  2 = Twin
--                  3 = Embryo transplant
--                  4 = Split embryo; clone
--                  5 = Nuclear
--                  6 = Not yet born

    ANIM_INFO_MASK               char(1)       not null  default X'00' for bit data,
--                x'80' = Donor dam
--                x'40' = Verified unknown sire
--                x'20' = Verified unknown dam
--                x'10' = Estimated birth
--                x'08' = Birth day is 0
--                x'04' = IHF
--                x'02' = (legacy issue) Animal born <= 426 days from dam
--                x'01' = (legacy issue) Animal born <= 426 days from sire

    ANIM_ID_CHNG_MASK            char(1)       not null  default X'00' for bit data,
--                x'80' = Change in cow ID
--                x'40' = Change in sire ID
--                x'20' = Change in dam ID
--                x'10' = Change in cow birth date
--                x'08' = Unspecified change in identification
--                x'04' = Dam confirmed with genotype
--                x'02' = Sire confirmed with genotype
--                x'01' = Animal is twin with different sire. Manually set.

    SOURCE_CODE                  char(1)       not null,
    MODIFY_PDATE                 smallint      not null  default -21916,
    SPECIES_CODE                 char(1)       not null,
   
    INIT_TIMESTAMP               TIMESTAMP     default null,
    INIT_PATH_ADDR               varchar(320)  default null,
 
    SIRE_SOURCE_CODE             smallint      not null  default 0,
    DAM_SOURCE_CODE              smallint      not null  default 0
);




/*
cd /home/db2inst1/Data/Goat/20200716.DataGene.GOATS;
db2 connect to cdcbdb; 
db2 "load from export.PEDIGREE.20200716 of ixf warningcount 0 messages msg.txt insert into TMP_PEDIGREE_TABLE nonrecoverable"
*/  


MERGE INTO PEDIGREE_TABLE AS A
USING (
		SELECT  *
		from TMP_PEDIGREE_TABLE
) AS B
ON A.SPECIES_CODE = B.SPECIES_CODE
and A.ANIM_KEY = B.ANIM_KEY 
WHEN NOT MATCHED THEN 
INSERT (  
		 ANIM_ID_CHNG_MASK,
		 ANIM_INFO_MASK,
		 ANIM_KEY,
		 BIRTH_PDATE,
		 DAM_KEY,
		 DAM_SOURCE_CODE,
		 INIT_PATH_ADDR,
		 INIT_TIMESTAMP,
		 MODIFY_PDATE,
		 MULTI_BIRTH_CODE,
		 SEX_CODE,
		 SIRE_KEY,
		 SIRE_SOURCE_CODE,
		 SOURCE_CODE,
		 SPECIES_CODE 
 )
  values (
	 
		B.ANIM_ID_CHNG_MASK,
		 B.ANIM_INFO_MASK,
		 B.ANIM_KEY,
		 B.BIRTH_PDATE,
		 B.DAM_KEY,
		 B.DAM_SOURCE_CODE,
		 B.INIT_PATH_ADDR,
		 B.INIT_TIMESTAMP,
		 B.MODIFY_PDATE,
		 B.MULTI_BIRTH_CODE,
		 B.SEX_CODE,
		 B.SIRE_KEY,
		 B.SIRE_SOURCE_CODE,
		 B.SOURCE_CODE,
		 B.SPECIES_CODE 
  )
;


DROP TABLE TMP_PEDIGREE_TABLE;


--LACTA90_TABLE


 
create table TMP_LACTA90_TABLE
   (SPECIES_CODE                 char(1)       not null,
    ANIM_KEY                     integer       not null,
    CALV_PDATE                   smallint      not null,
    HERD_CODE                    integer       not null,

    CTRL_NUM                     integer       not null,
    LACT_NUM                     char(1)       not null                for bit data,
--                the above field is one byte binary
    DIM_QTY                      smallint      not null,

    PROC_PDATE                   smallint      not null  default -21916,
    MODIFY_PDATE                 smallint      not null  default -21916,

    LACT_TYPE_CODE               char(1)       not null,
--                 '2' is stored only if the DIM_QTY = 305/365 and DIM_QTY > last TD_DIM_QTY
--                 otherwise '2' is changed to '1'
--                 Goats will store a '2' if the DIM_QTY_F4 = 305 and it is a new calving/herd or previous 
--                 DIM_QTY <= 305

    LACT_MASK                    char(1)       not null  default X'00' for bit data,
--                x'80' = Record incomplete
--                x'40' = Previous days dry
--                x'20' = Protein not useable
--                x'10' = Crossbred cow - record not used
--                x'08' = Lactation not useable
--                x'04' = Somatic cell (not used as of 9/21/98)
--                x'02' =
--                x'01' =

    INIT_CODE                    char(1)       not null,
    TERM_CODE                    char(1)       not null,

    OS_PCT                       char(1)       not null                for bit data,
--                the above field is one byte binary

    DAYS_OPEN_VERIF_CODE         char(1)       not null,
    DAYS_OPEN_QTY                smallint      not null,

    DCR_MLK_QTY                  char(1)       not null                for bit data,
--                the above field is one byte binary
--                -1 denotes missing value
    ME_MLK_QTY                   integer       not null,
--                -1 denotes missing value
    ME_FAT_QTY                   smallint      not null,
--                -1 denotes missing value
    ME_PRO_QTY                   smallint      not null,
--                -1 denotes missing value
    DCR_SCS_QTY                  char(1)       not null                for bit data,
--                the above field is one byte binary
--                -1 denotes missing value
    ME_SCS_QTY                   smallint      not null,
--                -1 denotes missing value

    PROGENY_QTY                  char(1)       not null  default '0',

    TESTDAY_CNT                  char(1)       not null                for bit data,
--                the above field is one byte binary
    TESTDAY_SEG                  varchar(400)  not null,
--                Testday segments 50 x 8 = 400
--  TD_DIM_QTY                   smallint
--  TD_MLK_QTY                   smallint
--                -1 denotes missing value
--  TD_FAT_PCT                   char(1)
--                -1 denotes missing value
--  TD_PRO_PCT                   char(1)
--                -1 denotes missing value
--  TD_SCS_QTY                   char(1)
--                -1 denotes missing value
--  TD_FREQ_QTY                  char(1)

    REPROD_EVT_CNT               char(1)       not null  default X'00' for bit data,
--                the above field is one byte binary
    REPROD_EVT_SEG               varchar(450)  not null  default,
--                Event segments 50 x 9 = 450
--  SERVICE_SIRE_KEY         long
--  EVENT_PDATE                  smallint
--  EVENT_TYPE_CODE              char(1)
--  DATE_TYPE_CODE               char(1)
--  EVENT_SEQ_NUM                char(1)
--                the above field is one byte binary
    TERM_2ND_CODE                char(1)       not null,
    LEFT_HERD_PDATE              smallint      not null  default -21916,

    DCR_FAT_QTY                  char(1)       not null  for bit data default X'FF',
    DCR_PRO_QTY                  char(1)       not null  for bit data default X'FF',

    ACT_MLK_QTY                  integer       not null  default -1,
    ACT_FAT_QTY                  smallint      not null  default -1,
    ACT_PRO_QTY                  smallint      not null  default -1,
    ACT_SCS_QTY                  smallint      not null  default -1,

    PRS_MLK_QTY                  smallint                default NULL,
    PRS_FAT_QTY                  smallint                default NULL,
    PRS_PRO_QTY                  smallint                default NULL,
    PRS_SCS_QTY                  smallint                default NULL,

    PRS_MLK_REL_PCT              smallint      not null  default 0,
    PRS_FAT_REL_PCT              smallint      not null  default 0,
    PRS_PRO_REL_PCT              smallint      not null  default 0,
    PRS_SCS_REL_PCT              smallint      not null  default 0

--                Event segments 50 x 13 = 650
--  HEALTH_EVT_PDATE             smallint 
--  HEALTH_EVT_CODE              char(4)
--  SOURCE_CODE                  char(1)
--  HEALTH_EVT_DETAIL            char(6)
);


/*
cd /home/db2inst1/Data/Goat/20200716.DataGene.GOATS;
db2 connect to cdcbdb; 
db2 "load from export.LACTA90.20200716 of ixf warningcount 0 messages msg.txt insert into TMP_LACTA90_TABLE nonrecoverable"
*/  
 

MERGE INTO LACTA90_TABLE AS A
USING (
		SELECT  *
		from TMP_LACTA90_TABLE
) AS B
ON A.SPECIES_CODE = B.SPECIES_CODE
and A.ANIM_KEY = B.ANIM_KEY
and A.CALV_PDATE = B.CALV_PDATE
and A.HERD_CODE = B.HERD_CODE 
WHEN NOT MATCHED THEN 
INSERT ( 
	 ACT_FAT_QTY,
	 ACT_MLK_QTY,
	 ACT_PRO_QTY,
	 ACT_SCS_QTY,
	 ANIM_KEY,
	 CALV_PDATE,
	 CTRL_NUM,
	 DAYS_OPEN_QTY,
	 DAYS_OPEN_VERIF_CODE,
	 DCR_FAT_QTY,
	 DCR_MLK_QTY,
	 DCR_PRO_QTY,
	 DCR_SCS_QTY,
	 DIM_QTY,
	 --HEALTH_EVT_CNT,
	 --HEALTH_EVT_SEG,
	 HERD_CODE,
	 INIT_CODE,
	 LACT_MASK,
	 LACT_NUM,
	 LACT_TYPE_CODE,
	 LEFT_HERD_PDATE,
	 ME_FAT_QTY,
	 ME_MLK_QTY,
	 ME_PRO_QTY,
	 ME_SCS_QTY,
	 MODIFY_PDATE,
	 OS_PCT,
	 PROC_PDATE,
	 PROGENY_QTY,
	 PRS_FAT_QTY,
	 PRS_FAT_REL_PCT,
	 PRS_MLK_QTY,
	 PRS_MLK_REL_PCT,
	 PRS_PRO_QTY,
	 PRS_PRO_REL_PCT,
	 PRS_SCS_QTY,
	 PRS_SCS_REL_PCT,
	 REPROD_EVT_CNT,
	 REPROD_EVT_SEG,
	 SPECIES_CODE,
	 TERM_2ND_CODE,
	 TERM_CODE,
	 TESTDAY_CNT,
	 TESTDAY_SEG

 )
  values (
	 
		 B.ACT_FAT_QTY,
		 B.ACT_MLK_QTY,
		 B.ACT_PRO_QTY,
		 B.ACT_SCS_QTY,
		 B.ANIM_KEY,
		 B.CALV_PDATE,
		 B.CTRL_NUM,
		 B.DAYS_OPEN_QTY,
		 B.DAYS_OPEN_VERIF_CODE,
		 B.DCR_FAT_QTY,
		 B.DCR_MLK_QTY,
		 B.DCR_PRO_QTY,
		 B.DCR_SCS_QTY,
		 B.DIM_QTY,
--		 B.HEALTH_EVT_CNT,
--		 B.HEALTH_EVT_SEG,
		 B.HERD_CODE,
		 B.INIT_CODE,
		 B.LACT_MASK,
		 B.LACT_NUM,
		 B.LACT_TYPE_CODE,
		 B.LEFT_HERD_PDATE,
		 B.ME_FAT_QTY,
		 B.ME_MLK_QTY,
		 B.ME_PRO_QTY,
		 B.ME_SCS_QTY,
		 B.MODIFY_PDATE,
		 B.OS_PCT,
		 B.PROC_PDATE,
		 B.PROGENY_QTY,
		 B.PRS_FAT_QTY,
		 B.PRS_FAT_REL_PCT,
		 B.PRS_MLK_QTY,
		 B.PRS_MLK_REL_PCT,
		 B.PRS_PRO_QTY,
		 B.PRS_PRO_REL_PCT,
		 B.PRS_SCS_QTY,
		 B.PRS_SCS_REL_PCT,
		 B.REPROD_EVT_CNT,
		 B.REPROD_EVT_SEG,
		 B.SPECIES_CODE,
		 B.TERM_2ND_CODE,
		 B.TERM_CODE,
		 B.TESTDAY_CNT,
		 B.TESTDAY_SEG
  )
;


drop table TMP_LACTA90_TABLE;
