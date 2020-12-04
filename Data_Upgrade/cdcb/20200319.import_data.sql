
 INSERT INTO dbo.CONSTANTS(NAME,INT_VALUE)
 VALUES('Type_PTA_chart_min',-6),
       ('Type_PTA_chart_max',6);	
 INSERT INTO dbo.CONSTANTS(NAME,STRING_VALUE)      
 VALUES     ('Default_Date_Value','1960-01-01');	


INSERT INTO dbo.USERS(USER_NAME,PASSWORD) 
VALUES 	('admin','$2b$12$0THlGdAG4yid9UB7uG6VuOz7qGPXjN/VKOGuG.dPydWftiGp3dhse')
		,('creator','$2b$12$pT9XPmTHxT/ilE21M4TsxevZz48xh8jgwKPEmE4QtSZeLlbqRGTGy')
 		,('guest', '$2b$12$Hu1GFSHWGkdNoUNCzU9LGeE2L6nOoweRmViYv5E2nwirDzI2CbyVa');
 
 		
INSERT INTO dbo.ROLES(ROLE)
VALUES 	('admin')
 	   	,('creator')
 		,('guest');

INSERT INTO dbo.USER_ROLES(ROLE,USER_NAME)
VALUES 	('admin','admin')
 	   	,('creator','admin')
  	   	,('creator','creator') 	   	
 		,('guest','admin')
  	   	,('guest','guest');

insert into trait_table  
select 
24 as trait_num,
'Fat%' as trait_name,
'Fat Percentage' as trait_full_name,
'Fat%' as trait_short_name,
2 as decimal_adjust_code,
publish_pdate,
comment,
modify_pdate,
'Percent' UNIT
from trait_table 
where trait_name ='Fat';
 

insert into trait_table  
select 
25 as trait_num,
'Pro%' as trait_name,
'Pro Percentage' as trait_full_name,
'Pro%' as trait_short_name,
2 as decimal_adjust_code,
publish_pdate,
comment,
modify_pdate,
'Percent' UNIT
from trait_table 
where trait_name ='Protein';

 
 
update trait_table set unit = 'Pounds' where trait_short_name = 'Pro';
 update trait_table set unit = 'Pounds' where trait_short_name = 'Mlk';
 update trait_table set unit = 'Pounds' where trait_short_name = 'Fat';
 update trait_table set unit = 'Percent' where trait_short_name = 'RPL';
 update trait_table set unit = 'Percent' where trait_short_name = 'MFV';
 update trait_table set unit = 'Percent' where trait_short_name = 'MET';
 update trait_table set unit = 'Percent' where trait_short_name = 'MAS';
 update trait_table set unit = 'Percent' where trait_short_name = 'LIV';
 update trait_table set unit = 'Percent' where trait_short_name = 'KET';
 update trait_table set unit = 'Percent' where trait_short_name = 'HCR';
 update trait_table set unit = 'Percent' where trait_short_name = 'DPR';
 update trait_table set unit = 'Percent' where trait_short_name = 'DAB';
 update trait_table set unit = 'Percent' where trait_short_name = 'CCR';
 update trait_table set unit = 'Months' where trait_short_name = 'PL';
 update trait_table set unit = 'Log Base 2 Units' where trait_short_name = 'SCS';
  
 update trait_table set unit = 'Days' where trait_short_name = 'GL';
 update trait_table set unit = 'Days' where trait_short_name = 'EFC';
 
  
update index_table set unit ='Dollars';
  