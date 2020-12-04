 alter table ID_XREF_TABLE add column INT_ID char(17);
  call sysproc.admin_cmd ('reorg table ID_XREF_TABLE');
  CREATE INDEX NIX_ID_XREF_TABLE_INT_ID
ON  ID_XREF_TABLE (
   INT_ID
) CLUSTER;
  
  update ID_XREF_TABLE set INT_ID = BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM;
  
 alter table ANIM_NAME_TABLE add column INT_ID char(17);
 call sysproc.admin_cmd ('reorg table ANIM_NAME_TABLE');
  
  CREATE INDEX NIX_ANIM_NAME_TABLE_INT_ID
ON  ANIM_NAME_TABLE (
   INT_ID
) CLUSTER;
  
  update ANIM_NAME_TABLE set INT_ID = BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM;
  
  alter table GENOTYPE_TABLE add column GENOTYPE_ID_NUM char(18);
  call sysproc.admin_cmd ('reorg table GENOTYPE_TABLE');

  CREATE INDEX NIX_GENOTYPE_TABLE_GENOTYPE_ID_NUM
ON  GENOTYPE_TABLE (
   GENOTYPE_ID_NUM
) CLUSTER;
  
  update GENOTYPE_TABLE set GENOTYPE_ID_NUM = SENTRIX_BARCODE||SENTRIX_POSITION;


  
alter table trait_table add column UNIT varchar(30);
alter table trait_table alter column trait_short_name set data type char(4);
call sysproc.admin_cmd ('reorg table trait_table');

alter table INDEX_TABLE add column UNIT varchar(30);
call sysproc.admin_cmd ('reorg table INDEX_TABLE');