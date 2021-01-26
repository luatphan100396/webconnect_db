
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