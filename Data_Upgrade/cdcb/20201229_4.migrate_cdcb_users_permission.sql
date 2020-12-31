----MIGRATE CDCB USERS INTO USER_GROUP_TABLE ----- 
 
INSERT INTO USER_GROUP_TABLE
(
USER_KEY,
GROUP_KEY,
CREATED_TIME,
MODIFIED_TIME 
)
  
  select
         u.USER_KEY,
         g.GROUP_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME  
  from 
  (
	  select USER_KEY
	  from TMP_USER_INFO_TABLE
	  where group = 'aipl'
  )u,
  (
	  select GROUP_KEY
	  from GROUP_TABLE
	  where GROUP_SHORT_NAME = 'CDCB'
  )g
;



INSERT INTO USER_GROUP_TABLE
(
USER_KEY,
GROUP_KEY,
CREATED_TIME,
MODIFIED_TIME 
)
  
  select
         u.USER_KEY,
         g.GROUP_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME  
  from 
  (
	  select USER_KEY
	  from TMP_USER_INFO_TABLE
	  where group = 'breed'
  )u,
  (
	  select GROUP_KEY
	  from GROUP_TABLE
	  where GROUP_SHORT_NAME = 'BREED'
  )g
;
 

INSERT INTO USER_GROUP_TABLE
(
USER_KEY,
GROUP_KEY,
CREATED_TIME,
MODIFIED_TIME 
)
  
  select
         u.USER_KEY,
         g.GROUP_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME  
  from 
  (
	  select USER_KEY
	  from TMP_USER_INFO_TABLE
	  where group = 'drpc'
  )u,
  (
	  select GROUP_KEY
	  from GROUP_TABLE
	  where GROUP_SHORT_NAME = 'DRPC'
  )g
;

INSERT INTO USER_GROUP_TABLE
(
USER_KEY,
GROUP_KEY,
CREATED_TIME,
MODIFIED_TIME 
)
  
  select
         u.USER_KEY,
         g.GROUP_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME  
  from 
  (
	  select USER_KEY
	  from TMP_USER_INFO_TABLE
	  where group = 'naab'
  )u,
  (
	  select GROUP_KEY
	  from GROUP_TABLE
	  where GROUP_SHORT_NAME = 'NAAB'
  )g
;



INSERT INTO USER_GROUP_TABLE
(
USER_KEY,
GROUP_KEY,
CREATED_TIME,
MODIFIED_TIME 
)
  
  select
         u.USER_KEY,
         g.GROUP_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME  
  from 
  (
	  select USER_KEY
	  from TMP_USER_INFO_TABLE
	  where group = 'ndhia'
  )u,
  (
	  select GROUP_KEY
	  from GROUP_TABLE
	  where GROUP_SHORT_NAME = 'NDHIA'
  )g
;



INSERT INTO USER_GROUP_TABLE
(
USER_KEY,
GROUP_KEY,
CREATED_TIME,
MODIFIED_TIME 
)
  
  select
         u.USER_KEY,
         g.GROUP_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME  
  from 
  (
	  select USER_KEY
	  from TMP_USER_INFO_TABLE
	  where group = 'stud'
  )u,
  (
	  select GROUP_KEY
	  from GROUP_TABLE
	  where GROUP_SHORT_NAME = 'STUD'
  )g
;
 

INSERT INTO USER_GROUP_TABLE
(
USER_KEY,
GROUP_KEY,
CREATED_TIME,
MODIFIED_TIME 
)
  
  select
         u.USER_KEY,
         g.GROUP_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME  
  from 
  (
	  select USER_KEY
	  from TMP_USER_INFO_TABLE
	  where group = 'dhias'
  )u,
  (
	  select GROUP_KEY
	  from GROUP_TABLE
	  where GROUP_SHORT_NAME = 'DHIA'
  )g
;

----MIGRATE CDCB USERS INTO USER_ROLE_TABLE -----  
  

INSERT INTO USER_ROLE_TABLE
(
USER_KEY,
ROLE_KEY,
CREATED_TIME,
MODIFIED_TIME 
)
  
  select
         u.USER_KEY,
         r.ROLE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME  
  from 
  (
	  select USER_KEY
	  from TMP_USER_INFO_TABLE
	  where roles like '%aipl%'
  )u,
  (
	  select ROLE_KEY
	  from ROLE_TABLE
	  where ROLE_SHORT_NAME = 'STAFF'
  )r
;  
  
 INSERT INTO USER_ROLE_TABLE
(
USER_KEY,
ROLE_KEY,
CREATED_TIME,
MODIFIED_TIME 
)
  
  select
         u.USER_KEY,
         r.ROLE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME  
  from 
  (
	  select USER_KEY
	  from TMP_USER_INFO_TABLE
	  where roles like '%GenoTypeLab%'
  )u,
  (
	  select ROLE_KEY
	  from ROLE_TABLE
	  where ROLE_SHORT_NAME = 'LAB'
  )r
;  

  
 INSERT INTO USER_ROLE_TABLE
(
USER_KEY,
ROLE_KEY,
CREATED_TIME,
MODIFIED_TIME 
)
  
  select
         u.USER_KEY,
         r.ROLE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME  
  from 
  (
	  select USER_KEY
	  from TMP_USER_INFO_TABLE
	  where roles like '%Nominator%'
  )u,
  (
	  select ROLE_KEY
	  from ROLE_TABLE
	  where ROLE_SHORT_NAME = 'NOMINATOR'
  )r
;  

----USER_AFFILIATION_TABLE----
INSERT INTO USER_AFFILIATION_TABLE
  (
	  USER_KEY,
	  DATA_SOURCE_KEY,
	  READ_PERMISSION,
	  WRITE_PERMISSION,
	  CREATED_TIME,
	  MODIFIED_TIME 
  )
  
 select   a.USER_KEY,
		  d.DATA_SOURCE_KEY,
		  '1' AS READ_PERMISSION,
		  '0' AS WRITE_PERMISSION,
		  current timestamp as CREATED_TIME,
		  current timestamp as MODIFIED_TIME 
 from
 ( 
	  select t.user_key,
	         a.item as AFFILIATE 
	  from  
	  (
	  select user_key, 
	         replace(replace(AFFILIATES,'{',''),'}','') as AFFILIATES
	   from TMP_USER_INFO_TABLE
	  ) t
	  ,table(fn_Split_String (t.AFFILIATES,',')) a
	  where a.item<>''
  )a
  inner join DATA_SOURCE_TABLE d
  on a.AFFILIATE = d.SOURCE_SHORT_NAME 
  ;
  