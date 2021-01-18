
 CREATE TABLE INPUT_FILE_TEMPLATE_TABLE
( 
NAME varchar(200) not null, 
TEMPLATE_DETAIL varchar(10000) not null,
CREATE_DATE DATE not null,
 constraint INPUT_FILE_TEMPLATE_TABLE_PK primary key (NAME)
);

INSERT INTO INPUT_FILE_TEMPLATE_TABLE
(
NAME,
TEMPLATE_DETAIL,
CREATE_DATE
)
VALUES 
('INPUT_TEMPLATE_ID_LIST_ANIM_FORMATTED_PEDIGREE',
'{
 "id_list": ["JEUSA000118662185","JEUSA000067106977","JEUSA000116279413"]
 "request_data": "Get Animal Formatted Pedigree Information"
}',
current timestamp
),
('INPUT_TEMPLATE_FILE_ANIM_FORMATTED_PEDIGREE',
'{
 "input_file": "/home/cdcb/upload_folder/TEST_2000_ANIMALS.txt"
 "request_data": "Get Animal Formatted Pedigree Information"
}',
current timestamp
);
