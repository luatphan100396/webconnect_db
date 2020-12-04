
DROP TABLE HEIFER_FLATFILE;
CREATE TABLE HEIFER_FLATFILE
(
LINE VARCHAR(530)
);

/*
db2 connect to cdcbdb;
db2 load from /home/shared/Data/420.eliteflat of del insert into HEIFER_FLATFILE
*/
 
 DROP TABLE HEIFER_LIST;
CREATE TABLE HEIFER_LIST
(
ANIM_KEY int not null primary key 
--INT_ID char(17) not null
);
 
 
INSERT INTO HEIFER_LIST(ANIM_KEY)
SELECT distinct id.anim_key
FROM HEIFER_FLATFILE hl
inner join id_xref_table id 
on SUBSTRING(hl.LINE,1,17) = id.int_id 
and id.species_code =0 
and id.PREFERRED_CODE =1
and id.sex_code ='F'
;
  
   