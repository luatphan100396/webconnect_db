 
CREATE TABLE ACCOUNT_REQUEST_TABLE (
	REQUEST_KEY INT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1),
	FIRST_NAME VARCHAR(30) NOT NULL,
	LAST_NAME VARCHAR(50) NOT NULL,
	EMAIL_ADDR VARCHAR(200) NOT NULL,
	ORGANIZATION VARCHAR(200), 
	TITLE VARCHAR(200),
	PHONE VARCHAR(30),
	EMAIL_USE_IND VARCHAR(1),
	STATUS VARCHAR(10), -- Approved, Rejected, New
	REQUESTED_CREDENTIAL varchar(500),
	USER_NAME VARCHAR(128) NOT NULL,
	PASSWORD VARCHAR(128) NOT NULL,
	CREATED_TIME timestamp NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_TIME timestamp NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_BY VARCHAR(50) NULL, 
	constraint ACCOUNT_REQUEST_TABLE_PK PRIMARY KEY (REQUEST_KEY));
  

CREATE TABLE USER_INFO_TABLE (
	USER_KEY INT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1),
	FIRST_NAME VARCHAR(30) NOT NULL,
	LAST_NAME VARCHAR(50) NOT NULL,
	EMAIL_ADDR VARCHAR(200) NOT NULL,
	ORGANIZATION VARCHAR(200),
	STATUS_CODE VARCHAR(1) NOT NULL,
	TITLE VARCHAR(200),
	PHONE VARCHAR(30),
	EMAIL_USE_IND VARCHAR(1),
	CREATED_TIME TIMESTAMP  NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_TIME TIMESTAMP NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_BY VARCHAR(50) NULL,
	constraint USER_INFO_TABLE_PK PRIMARY KEY (USER_KEY));
	  
CREATE TABLE USER_ACCOUNT_TABLE (
	USER_KEY INT NOT NULL,
	USER_NAME VARCHAR(128) UNIQUE NOT NULL,
	PASSWORD VARCHAR(128) NOT NULL,
	CREATED_TIME TIMESTAMP  NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_TIME TIMESTAMP NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_BY VARCHAR(50) NULL,
	constraint USER_ACCOUNT_TABLE_PK PRIMARY KEY (USER_KEY));
  
  
CREATE TABLE GROUP_TABLE (
	GROUP_KEY INT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1),
	GROUP_SHORT_NAME VARCHAR(50) NOT NULL,
	GROUP_NAME VARCHAR(200)  NULL,
	STATUS_CODE VARCHAR(1) NOT NULL,
	constraint GROUP_TABLE_PK PRIMARY KEY (GROUP_KEY));
 
CREATE TABLE ROLE_TABLE (
	ROLE_KEY INT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1),
	ROLE_SHORT_NAME VARCHAR(50)  NULL,
	ROLE_NAME VARCHAR(200) NOT NULL,
	STATUS_CODE VARCHAR(1) NOT NULL,
	constraint ROLE_TABLE_PK PRIMARY KEY (ROLE_KEY));
 
CREATE TABLE FEATURE_TABLE (
	FEATURE_KEY INT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1),
	FEATURE_NAME VARCHAR(200) NOT NULL,
	constraint FEATURE_TABLE_PK PRIMARY KEY (FEATURE_KEY)); 
 
 
CREATE TABLE FEATURE_COMPONENT_TABLE (
	COMPONENT_KEY INT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1),
	COMPONENT_NAME VARCHAR(200) NOT NULL,
	FEATURE_KEY INT NOT NULL,
	CREATED_TIME timestamp NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_TIME timestamp NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_BY VARCHAR(50) NULL,
	constraint FEATURE_COMPONENT_TABLE_PK PRIMARY KEY (COMPONENT_KEY));
 
 CREATE TABLE FIELD_TABLE (
	FIELD_KEY INT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1), 
	COMPONENT_KEY INT ,
	FIELD_NAME VARCHAR(200) NOT NULL,
	CREATED_TIME timestamp NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_TIME timestamp NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_BY VARCHAR(50) NULL,
	constraint FIELD_TABLE_PK PRIMARY KEY (FIELD_KEY));
  
 
CREATE TABLE GROUP_FEATURE_COMPONENT_TABLE (
	GROUP_KEY INT NOT NULL,
	COMPONENT_KEY INT NOT NULL,
	CREATED_TIME TIMESTAMP  NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_TIME TIMESTAMP NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_BY VARCHAR(50) NULL,
	constraint GROUP_FEATURE_COMPONENT_TABLE_PK PRIMARY KEY (GROUP_KEY,COMPONENT_KEY));

 
 
CREATE TABLE ROLE_FEATURE_COMPONENT_TABLE (
	ROLE_KEY INT NOT NULL,
	COMPONENT_KEY INT NOT NULL,
	CREATED_TIME TIMESTAMP  NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_TIME TIMESTAMP NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_BY VARCHAR(50)  NULL ,
	constraint ROLE_FEATURE_COMPONENT_TABLE_PK PRIMARY KEY (ROLE_KEY,COMPONENT_KEY)); 
 
CREATE TABLE GROUP_RESTRICTED_FIELD_TABLE (
	GROUP_KEY INT NOT NULL,
	FIELD_KEY INT NOT NULL,
	CREATED_TIME TIMESTAMP  NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_TIME TIMESTAMP NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_BY VARCHAR(50) NULL,
	constraint GROUP_RESTRICTED_FIELD_TABLE_PK PRIMARY KEY (GROUP_KEY,FIELD_KEY)
);

CREATE TABLE ROLE_RESTRICTED_FIELD_TABLE (
	ROLE_KEY INT NOT NULL,
	FIELD_KEY INT NOT NULL,
	CREATED_TIME TIMESTAMP  NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_TIME TIMESTAMP NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_BY VARCHAR(50) NULL,
	constraint ROLE_RESTRICTED_FIELD_TABLE_PK PRIMARY KEY (ROLE_KEY,FIELD_KEY)
);

CREATE TABLE USER_GROUP_TABLE (
	USER_KEY INT NOT NULL,
	GROUP_KEY INT NOT NULL,
	CREATED_TIME TIMESTAMP  NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_TIME TIMESTAMP NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_BY VARCHAR(50)  NULL,
	constraint USER_GROUP_TABLE_PK PRIMARY KEY (USER_KEY,GROUP_KEY));

CREATE TABLE USER_ROLE_TABLE (
	USER_KEY INT NOT NULL,
	ROLE_KEY INT NOT NULL,
	CREATED_TIME TIMESTAMP  NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_TIME TIMESTAMP NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_BY VARCHAR(50)  NULL,
	constraint USER_ROLE_TABLE_PK PRIMARY KEY (USER_KEY,ROLE_KEY));

 
CREATE TABLE USER_AFFILIATION_TABLE (
	USER_KEY INT NOT NULL,
	DATA_SOURCE_KEY INT NOT NULL,
	READ_PERMISSION char(1),
	WRITE_PERMISSION char(1),
	CREATED_TIME TIMESTAMP  NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_TIME TIMESTAMP NOT NULL DEFAULT  CURRENT TIMESTAMP,
	MODIFIED_BY VARCHAR(50)  NULL,
	constraint USER_AFFILIATION_TABLE_PK PRIMARY KEY (USER_KEY,DATA_SOURCE_KEY));
 
 
 
 
CREATE TABLE USER_VISIT_HISTORY_TABLE (
	ID BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1),
	USER_KEY INT NOT NULL,
	ACCESS_TIME TIMESTAMP NOT NULL,
	IP_ADDRESS VARCHAR(20),
	WEB_BROWSER VARCHAR(50),
	DEVICE VARCHAR(50),
	constraint USER_VISIT_HISTORY_TABLE_PK PRIMARY KEY (ID));
	
	
	

CREATE TABLE ARCHIVE_USER_INFO_TABLE (
	USER_KEY INT NOT NULL,
	FIRST_NAME VARCHAR(30)  NULL,
	LAST_NAME VARCHAR(50)  NULL,
	EMAIL_ADDR VARCHAR(200)  NULL,
	ORGANIZATION VARCHAR(200),
	STATUS_CODE VARCHAR(1)  NULL,
	TITLE VARCHAR(200),
	PHONE VARCHAR(30),
	EMAIL_USE_IND VARCHAR(1),
	CREATED_TIME TIMESTAMP   NULL,
	MODIFIED_TIME TIMESTAMP  NULL,
	MODIFIED_BY VARCHAR(50) NULL,
	ARCHIVED_TIME TIMESTAMP NOT  NULL 
	);
	  
CREATE TABLE ARCHIVE_USER_ACCOUNT_TABLE (
	USER_KEY INT NOT NULL,
	USER_NAME VARCHAR(128) NOT NULL,
	PASSWORD VARCHAR(128) NOT NULL,
	CREATED_TIME TIMESTAMP  NOT NULL,
	MODIFIED_TIME TIMESTAMP NOT NULL,
	MODIFIED_BY VARCHAR(50) NULL,
	ARCHIVED_TIME TIMESTAMP NOT  NULL  
	);
	
	
	
CREATE TABLE ARCHIVE_USER_GROUP_TABLE (
	USER_KEY INT NOT NULL,
	GROUP_KEY INT NOT NULL,
	CREATED_TIME TIMESTAMP  NOT NULL,
	MODIFIED_TIME TIMESTAMP NOT NULL,
	MODIFIED_BY VARCHAR(50)  NULL,
	ARCHIVED_TIME TIMESTAMP NOT  NULL 
	);

CREATE TABLE ARCHIVE_USER_ROLE_TABLE (
	USER_KEY INT NOT NULL,
	ROLE_KEY INT NOT NULL,
	CREATED_TIME TIMESTAMP  NOT NULL,
	MODIFIED_TIME TIMESTAMP NOT NULL,
	MODIFIED_BY VARCHAR(50)  NULL,
	ARCHIVED_TIME TIMESTAMP NOT  NULL 
);

 
CREATE TABLE ARCHIVE_USER_AFFILIATION_TABLE (
	USER_KEY INT NOT NULL,
	DATA_SOURCE_KEY INT NOT NULL,
	READ_PERMISSION char(1),
	WRITE_PERMISSION char(1),
	CREATED_TIME TIMESTAMP  NOT NULL,
	MODIFIED_TIME TIMESTAMP NOT NULL,
	MODIFIED_BY VARCHAR(50)  NULL,
	ARCHIVED_TIME TIMESTAMP NOT  NULL 
	);
 
  
ALTER TABLE USER_ACCOUNT_TABLE ADD CONSTRAINT USER_ACCOUNT_TABLE_fk0 FOREIGN KEY (USER_KEY) REFERENCES USER_INFO_TABLE(USER_KEY) ON DELETE CASCADE ;
  

ALTER TABLE USER_GROUP_TABLE ADD CONSTRAINT USER_GROUP_TABLE_fk0 FOREIGN KEY (USER_KEY) REFERENCES USER_INFO_TABLE(USER_KEY) ON DELETE CASCADE ;
ALTER TABLE USER_GROUP_TABLE ADD CONSTRAINT USER_GROUP_TABLE_fk1 FOREIGN KEY (GROUP_KEY) REFERENCES GROUP_TABLE(GROUP_KEY);

ALTER TABLE GROUP_FEATURE_COMPONENT_TABLE ADD CONSTRAINT GROUP_FEATURE_COMPONENT_TABLE_fk0 FOREIGN KEY (GROUP_KEY) REFERENCES GROUP_TABLE(GROUP_KEY);
ALTER TABLE GROUP_FEATURE_COMPONENT_TABLE ADD CONSTRAINT GROUP_FEATURE_COMPONENT_TABLE_fk1 FOREIGN KEY (COMPONENT_KEY) REFERENCES FEATURE_COMPONENT_TABLE(COMPONENT_KEY);

ALTER TABLE ROLE_FEATURE_COMPONENT_TABLE ADD CONSTRAINT ROLE_FEATURE_COMPONENT_TABLE_fk0 FOREIGN KEY (ROLE_KEY) REFERENCES ROLE_TABLE(ROLE_KEY);
ALTER TABLE ROLE_FEATURE_COMPONENT_TABLE ADD CONSTRAINT ROLE_FEATURE_COMPONENT_TABLE_fk1 FOREIGN KEY (COMPONENT_KEY) REFERENCES FEATURE_COMPONENT_TABLE(COMPONENT_KEY);

ALTER TABLE FEATURE_COMPONENT_TABLE ADD CONSTRAINT FEATURE_COMPONENT_TABLE_fk0 FOREIGN KEY (FEATURE_KEY) REFERENCES FEATURE_TABLE(FEATURE_KEY);

 

ALTER TABLE USER_ROLE_TABLE ADD CONSTRAINT USER_ROLE_TABLE_fk0 FOREIGN KEY (USER_KEY) REFERENCES USER_INFO_TABLE(USER_KEY) ON DELETE CASCADE ;
ALTER TABLE USER_ROLE_TABLE ADD CONSTRAINT USER_ROLE_TABLE_fk1 FOREIGN KEY (ROLE_KEY) REFERENCES ROLE_TABLE(ROLE_KEY);

 

ALTER TABLE USER_AFFILIATION_TABLE ADD CONSTRAINT USER_AFFILIATION_TABLE_fk0 FOREIGN KEY (USER_KEY) REFERENCES USER_INFO_TABLE(USER_KEY) ON DELETE CASCADE ;
ALTER TABLE USER_AFFILIATION_TABLE ADD CONSTRAINT USER_AFFILIATION_TABLE_fk1 FOREIGN KEY (DATA_SOURCE_KEY) REFERENCES DATA_SOURCE_TABLE(DATA_SOURCE_KEY);
 
ALTER TABLE GROUP_RESTRICTED_FIELD_TABLE ADD CONSTRAINT GROUP_RESTRICTED_FIELD_TABLE_fk0 FOREIGN KEY (GROUP_KEY) REFERENCES GROUP_TABLE(GROUP_KEY);
ALTER TABLE GROUP_RESTRICTED_FIELD_TABLE ADD CONSTRAINT GROUP_RESTRICTED_FIELD_TABLE_fk1 FOREIGN KEY (FIELD_KEY) REFERENCES FIELD_TABLE(FIELD_KEY);
 
ALTER TABLE ROLE_RESTRICTED_FIELD_TABLE ADD CONSTRAINT ROLE_RESTRICTED_FIELD_TABLE_fk0 FOREIGN KEY (ROLE_KEY) REFERENCES ROLE_TABLE(ROLE_KEY);
ALTER TABLE ROLE_RESTRICTED_FIELD_TABLE ADD CONSTRAINT ROLE_RESTRICTED_FIELD_TABLE_fk1 FOREIGN KEY (FIELD_KEY) REFERENCES FIELD_TABLE(FIELD_KEY);


