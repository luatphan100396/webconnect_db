
alter table breed_table add column BREED_3CHAR char(3);
call‬‎ ‪sysproc‬‎.‪admin_cmd‬‎(‪‬‎'‪reorg table db2inst1.breed_table'‬‎)‪
  
MERGE INTO BREED_TABLE as A
	 using
	 (
       SELECT *
	    FROM ( values 
				 ('AY','RDC'),
				 ('BS','BSW'),
				 ('GU','GUE'),
				 ('HO','HOL'),
				 ('JE','JER'),
				 ('MO','MON'),
				 ('NO','NMD'),
				 ('NR','RDC'),
				 ('RE','RDC'),
				 ('SM','SIM'),
				 ('SR','RDC'),
				 ('AN','AAN'),
				 ('BB','BBL'),
				 ('BD','BAQ'),
				 ('BM','BMA'),
				 ('BN','BRG'),
				 ('BO','BFD'),
				 ('BR','BRM'),
				 ('CA','CIA'),
				 ('CH','CHA'),
				 ('DR','DXT'),
				 ('GA','GLW'),
				 ('GV','GVH'),
				 ('LM','LIM'),
				 ('MG','MGR'),
				 ('MR','MAR'),
				 ('PI','PIE'),
				 ('PZ','PIN'),
				 ('RN','ROM'),
				 ('RW','RED'),
				 ('SG','SGE'),
				 ('SW','SAH'),
				 ('TA','TAR'),
				 ('WB','WBL')  
	    )t (BREED_CODE, BREED_3CHAR)
	 )AS B
	 ON  A.BREED_CODE = B.BREED_CODE 
	 WHEN MATCHED THEN UPDATE
	 SET BREED_3CHAR = B.BREED_3CHAR 
	 ;