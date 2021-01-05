INSERT INTO USER_INFO_TABLE
 (   
 	FIRST_NAME,
	LAST_NAME,
	EMAIL_ADDR,
	ORGANIZATION,
	STATUS_CODE,
	TITLE,
	PHONE,
	EMAIL_USE_IND,
	CREATED_TIME,
	MODIFIED_TIME 
 )
 VALUES('Admin','Admin','Admin@cdcb.com', 'CDCB','A','','123',1, current timestamp,current timestamp), 
 ('Anonymous','Anonymous','xxx', 'xxx','A','','',1,current timestamp,current timestamp);
 
 INSERT INTO USER_ACCOUNT_TABLE
 (
    USER_KEY,
	USER_NAME,
	PASSWORD,
	CREATED_TIME,
	MODIFIED_TIME  

 ) 
 
 select USER_KEY,
        FIRST_NAME as user_name,
        '$2b$12$8msO26s5I97jouiWfxD2w.ani20E2NilK6yYqZBDP2E6Cp6gPn0qq' as pass,
		,current timestamp
		,current timestamp
       
 from USER_INFO_TABLE
 where FIRST_NAME in ('Admin','Anonymous');



 --- TMA user

 INSERT INTO USER_INFO_TABLE
 (   
 	FIRST_NAME,
	LAST_NAME,
	EMAIL_ADDR,
	ORGANIZATION,
	STATUS_CODE,
	TITLE,
	PHONE,
	EMAIL_USE_IND,
	CREATED_TIME,
	MODIFIED_TIME 
 )
 VALUES('dung','tran','nqdung2@tma.com.vn', 'TMA','A','','123',1,current timestamp,current timestamp
       );
 
 INSERT INTO USER_ACCOUNT_TABLE
 (
    USER_KEY,
	USER_NAME,
	PASSWORD,
	CREATED_TIME,
	MODIFIED_TIME 
 ) 
 
 select USER_KEY,
        'nqdung' as user_name,
        '$2b$12$8msO26s5I97jouiWfxD2w.ani20E2NilK6yYqZBDP2E6Cp6gPn0qq' as pass
		,current timestamp
		,current timestamp
       
 from USER_INFO_TABLE
 where EMAIL_ADDR in ('nqdung2@tma.com.vn' );
 
 