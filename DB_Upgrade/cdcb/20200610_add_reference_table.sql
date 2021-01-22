CREATE TABLE REFERENCE_TABLE
(TYPE varchar(50) not null,
 CODE varchar(50) not null,
 DESCRIPTION varchar(500),
 constraint REFERENCE_TABLE_PK primary key (TYPE,CODE)
);

INSERT INTO REFERENCE_TABLE (TYPE,CODE,DESCRIPTION)
VALUES 
('SOURCE_CODE','B','Breed Associations (USA and CAN)'),
('SOURCE_CODE','D','Dairy Records Processing Center (DRPC)'),
('SOURCE_CODE','N','NAAB, studs, and other non-breed requestors'),
('SOURCE_CODE','I','Interbull and International Breed Associations'),
('SOURCE_CODE','A','Animal Improvement Programs Laboratory (AIPL)'),
('SOURCE_CODE','C','Animal Improvement Programs Laboratory (AIPL) internal use only');


INSERT INTO REFERENCE_TABLE (TYPE,CODE,DESCRIPTION)
VALUES 
('MBC','1','Single'),
('MBC','2','Multiple birth (not from embryo transfer)'),
('MBC','3','Birth from embryo transfer'),
('MBC','4','Split embryo (artificially)'),
('MBC','5','Clone from nuclear transfer'),
('MBC','6','Embryo pedigree (implantation date stored as birth date)');

INSERT INTO REFERENCE_TABLE (TYPE,CODE,DESCRIPTION)
VALUES 
('TERM_CODE','0','Lactation in progress or ended normally without an abortion'),
('TERM_CODE','8','Lactation ended with an abortion at >=152 days and < 251 days (261 days for Brown Swiss) after conception, or aborted at >= 200 days in milk if no breeding date'),
('TERM_CODE','2','Cow sold/transferred to another dairy alive to provide income from milk, calves, or embryos'),
('TERM_CODE','1','Cow sold for locomotion problems (feet, legs, lameness)'),
('TERM_CODE','3','Cow sold for poor production (low production not caused by other reasons)'),
('TERM_CODE','4','Cow sold because of reproductive problems'),
('TERM_CODE','7','Cow sold due to mastitis or high somatic cells'),
('TERM_CODE','9','Cow sold due to udder problems (conformation or injury)'),
('TERM_CODE','A','Cow sold due to undesirable conformation (other than udder)'),
('TERM_CODE','B','Cow sold due to aggressive behavior (undesirable temperament)'),
('TERM_CODE','5','Cow sold for any other reason, or reason not specified'),
('TERM_CODE','6','Cow died on the dairy; downer cows that were euthanized should be included here') ;

INSERT INTO REFERENCE_TABLE (TYPE,CODE,DESCRIPTION)
VALUES 
('REC_CODE','*','Change in pedigree information after second test following entry into herd'),
('REC_CODE','N','All records not usable, including first lactation records in progress with less than 40 days in milk'),
('REC_CODE','R','Record from last lactation is a record in progress'),
('REC_CODE','A','First lactation record is from predominately unsupervised testing.');

INSERT INTO REFERENCE_TABLE (TYPE,CODE,DESCRIPTION)
VALUES 
('ERROR_ACTION_CODE','R','Rejected'),
('ERROR_ACTION_CODE','C','Changed'),
('ERROR_ACTION_CODE','N','Notified');