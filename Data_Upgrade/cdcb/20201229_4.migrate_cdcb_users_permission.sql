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