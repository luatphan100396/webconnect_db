
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
	  where USER_KEY IN   (4507,4551)
  )u,
    (
	  select GROUP_KEY
	  from GROUP_TABLE
	  where GROUP_SHORT_NAME = 'ADMIN'
  )g
;