CREATE TABLE SETTING_TABLE
 (
 NAME VARCHAR(128) NOT NULL PRIMARY KEY,
 INT_VALUE INT NULL,
 STRING_VALUE VARCHAR(10000),
 DECIMAL_VALUE decimal(8,2)
 );
 
  
  
 
 INSERT INTO SETTING_TABLE(NAME,INT_VALUE)      
 VALUES     ('Maintenance_Mode',0);	

INSERT INTO SETTING_TABLE(NAME,STRING_VALUE)      
 VALUES     ('Maintenance_Message','The CDCB database is currently locked. Any submission mode will be processed automatically as soon as the database is unlocked');	
INSERT INTO SETTING_TABLE(NAME,STRING_VALUE)      
 VALUES     ('Maintenance_Color','#E79593');	