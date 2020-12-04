 
 CREATE TABLE breedmeans_within_1912
(
LINE VARCHAR(128)
);

/*
db2 connect to cdcbdb;
db2 load from /home/db2inst1/Data/breedmeans.within_1912 of del insert into breedmeans_within_1912
*/
  
CREATE TABLE BREED_MEANS
(
EVAL_PDATE smallint not null,
BREED_CODE char(2) not null,
TRAIT_NUM char(3),
TRAIT_SHORT_NAME varchar(5) not null,
BIRTH_YEAR varchar(4) not null,
NUM_COW int,
SD_RATIO varchar(15),
wEBV varchar(15),
SireEBV varchar(15),
REL varchar(5),
SireREL varchar(5),
Inbrd varchar(5),
EFI varchar(5),
Het varchar(5),
First_Lac_Y varchar(15),
constraint BREED_MEANS_PK PRIMARY KEY (EVAL_PDATE,BREED_CODE,TRAIT_SHORT_NAME,BIRTH_YEAR)
);
 
 create index BREED_MEANS_INDEX1           on BREED_MEANS   (EVAL_PDATE   desc)  allow reverse scans;
 create index BREED_MEANS_INDEX2           on BREED_MEANS   (BREED_CODE   asc, TRAIT_SHORT_NAME asc)  allow reverse scans;
 
 insert into BREED_MEANS
 (
	EVAL_PDATE, 
	BREED_CODE,
	TRAIT_NUM,
	TRAIT_SHORT_NAME,
	BIRTH_YEAR,
	NUM_COW,
	SD_RATIO,
	wEBV,
	SireEBV,
	REL,
	SireREL,
	Inbrd,
	EFI,
	Het,
	First_Lac_Y 
 )
 SELECT 21884 as eval_pdate,
		 trim(substring(t.line,1,5)) as BREED_CODE,
		 TRIM(substring(t.line,6,4)) as TRAIT_NUM,
		 trim(tr.TRAIT_SHORT_NAME) as TRAIT_SHORT_NAME,
		 trim(substring(t.line,10,6)) as Biryr,
		 trim(substring(t.line,16,6)) as Cows,
		 trim(substring(t.line,22,8)) as SDratio,
		 trim(substring(t.line,30,8)) as wEBV,
		 trim(substring(t.line,38,10)) as SireEBV,
		 trim(substring(t.line,48,6)) as REL,
		 trim(substring(t.line,54,7)) as SireREL,
		 trim(substring(t.line,61,8)) as Inbrd,
		 trim(substring(t.line,69,6)) as EFI,
		 trim(substring(t.line,75,6)) as Het,
		 trim(substring(t.line,81,12)) as First_Lac_Y  
 FROM breedmeans_within_1912 t
 INNER JOIN TRAIT_TABLE tr
 ON tr.TRAIT_NUM = TRIM(substring(t.line,6,4))
 where  substring(t.line,1,5) <>'Breed';
 
 
 