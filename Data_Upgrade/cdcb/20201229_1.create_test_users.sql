INSERT INTO USER_INFO_TABLE
 (   
 	FIRST_NAME,
	LAST_NAME,
	EMAIL_ADDR,
	ORGANIZATION,
	STATUS_CODE,
	TITLE,
	PHONE,
	EMAIL_USE_IND 
 )
 VALUES('Admin','Admin','Admin@cdcb.com', 'CDCB','A','','123',1), 
 ('Anonymous','Anonymous','xxx', 'xxx','A','','',1);
 
 INSERT INTO USER_ACCOUNT_TABLE
 (
    USER_KEY,
	USER_NAME,
	PASSWORD 
 ) 
 
 select USER_KEY,
        FIRST_NAME as user_name,
        '$2b$12$8msO26s5I97jouiWfxD2w.ani20E2NilK6yYqZBDP2E6Cp6gPn0qq' as pass
       
 from USER_INFO_TABLE
 where FIRST_NAME in ('Admin','Anonymous');