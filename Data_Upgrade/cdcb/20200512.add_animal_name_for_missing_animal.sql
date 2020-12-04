                                           
 INSERT INTO  ANIM_NAME_TABLE
 (SPECIES_CODE,
 ANIM_ID_NUM,
 BREED_CODE,
 COUNTRY_CODE,
 SEX_CODE,
 INT_ID,
 ANIM_NAME
 )
   
                                                    
 SELECT id.SPECIES_CODE, 
 id.ANIM_ID_NUM, 
 id.BREED_CODE, 
 id.COUNTRY_CODE,
 id.SEX_CODE, 
 id.INT_ID,
 '' as ANIM_NAME
 FROM ID_XREF_TABLE id
 LEFT JOIN ANIM_NAME_TABLE aname 
 on id.INT_ID = aname.INT_ID   
 and id.SPECIES_CODE = aname.SPECIES_CODE
 and id.SEX_CODE = aname.SEX_CODE   
 where aname.INT_ID  is null
 and length(trim(id.INT_ID))=17;