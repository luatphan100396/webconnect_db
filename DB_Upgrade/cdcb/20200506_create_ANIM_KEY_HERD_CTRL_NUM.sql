
CREATE TABLE ANIM_KEY_HERD_CTRL_NUM
(

INT_ID char(17) not null,
SPECIES_CODE char(1) not null,
HERD_CODE int not null,
CTRL_NUM int not null,
SEX_CODE char(1) not null,
ANIM_KEY int  null,
constraint ANIM_KEY_HERD_CTRL_NUM_PK PRIMARY KEY ( INT_ID,SPECIES_CODE,HERD_CODE,CTRL_NUM,SEX_CODE)
);
create index ANIM_KEY_HERD_CTRL_NUM_HRD_INDEX               on ANIM_KEY_HERD_CTRL_NUM                 (HERD_CODE asc, CTRL_NUM asc) allow reverse scans;
create index ANIM_KEY_HERD_CTRL_NUM_HRD_INDEX_CONCAT               on ANIM_KEY_HERD_CTRL_NUM                 (HERD_CODE ||' '||CTRL_NUM ) allow reverse scans;
 

INSERT INTO ANIM_KEY_HERD_CTRL_NUM
(
INT_ID,
SPECIES_CODE,
HERD_CODE,
CTRL_NUM,
SEX_CODE 
)

 
SELECT distinct   
id.INT_ID,
l.SPECIES_CODE, 
l.HERD_CODE, 
l.CTRL_NUM,
id.SEX_CODE
FROM LACTA90_TABLE l
INNER JOIN ID_XREF_TABLE id 
ON l.anim_key = id.anim_key
and id.SEX_CODE ='F'
and id.SPECIES_CODE =l.SPECIES_CODE
and id.PREFERRED_CODE =1
 
UNION

SELECT  DISTINCT 
BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM as INT_ID,
substring(BASE_RECORD,1,1) AS SPECIES_CODE, 
HERD_CODE, 
CTRL_NUM,
substring(BASE_RECORD,2,1) AS SEX_CODE
FROM ERROR4_TABLE

union
SELECT  DISTINCT  
BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM as INT_ID,
SPECIES_CODE, 
HERD_CODE, 
CTRL_NUM,
'F' AS SEX_CODE

FROM ERROR5_TABLE
union 

SELECT  DISTINCT  
BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM as INT_ID,
SPECIES_CODE, 
HERD_CODE, 
CTRL_NUM,
'F' AS SEX_CODE
FROM ERROR6_TABLE WITH UR
; 
 
 
 
 -- Update anim
merge into ANIM_KEY_HERD_CTRL_NUM as a
using  ID_XREF_TABLE as b
on a.INT_ID = b.INT_ID
and a.SPECIES_CODE = b.SPECIES_CODE
when matched then
update set ANIM_KEY = b.ANIM_KEY;
 
 -- add index to error table

 create index ERROR5_TABLE_INDEX_INT_ID              on ERROR5_TABLE                 (BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM ) allow reverse scans;
 create index ERROR4_TABLE_INDEX_INT_ID              on ERROR4_TABLE                 (BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM ) allow reverse scans;
 create index ERROR1_TABLE_INDEX_INT_ID              on ERROR1_TABLE                 (BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM ) allow reverse scans;
create index ERROR6_TABLE_INDEX_INT_ID              on ERROR6_TABLE                 (BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM ) allow reverse scans;
 
  create index ER4B_SOURCE_FILE_NAME_INDEX   on ERROR4_TABLE    (SOURCE_FILE_NAME DESC, TRIM(SUBSTRING(BASE_RECORD,80,8)) desc, CALV_PDATE DESC  ,DIM_QTY DESC) allow reverse scans;
  create index ER5B_SOURCE_FILE_NAME_INDEX   on ERROR5_TABLE    (SOURCE_FILE_NAME DESC, PROC_PDATE desc, CALV_PDATE DESC) allow reverse scans;