
CREATE TABLE OUTPUT_FILE_TEMPLATE_TABLE
( 
NAME varchar(200) not null,
TYPE varchar(50) not null,
TEMPLATE_DETAIL varchar(10000) not null,
PREFIX_OUTPUT_NAME varchar(200) not null,
CREATE_DATE DATE not null,
 constraint OUTPUT_FILE_TEMPLATE_TABLE_PK primary key (NAME,TYPE)
);
