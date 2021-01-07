
-- Public user
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
	  from USER_ACCOUNT_TABLE
	  where USER_NAME = 'Anonymous'
  )u,
  (
	  select GROUP_KEY
	  from GROUP_TABLE
	  where GROUP_SHORT_NAME = 'PUBLIC'
  )g
;

-- Administrators have full permission
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
	  from USER_ACCOUNT_TABLE
	  where USER_NAME = 'Admin'
  )u,
    (
	  select GROUP_KEY
	  from GROUP_TABLE
	  where GROUP_SHORT_NAME = 'ADMIN'
  )g
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
	  from USER_ACCOUNT_TABLE
	  where USER_NAME = 'Admin'
  )u,ROLE_TABLE r
;  
     