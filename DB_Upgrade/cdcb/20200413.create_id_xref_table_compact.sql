--DROP TABLE ID_XREF_TABLE_COMPACT_BULL;
--DROP TABLE ID_XREF_TABLE_COMPACT_COW;

CREATE TABLE ID_XREF_TABLE_COMPACT_BULL
(
 ANIM_KEY int not null,
 INT_ID varchar(17) not null,
 constraint ID_XREF_TABLE_COMPACT_BULL_PK PRIMARY KEY (ANIM_KEY,INT_ID)
);

INSERT INTO ID_XREF_TABLE_COMPACT_BULL(ANIM_KEY,INT_ID)
SELECT id.ANIM_KEY, id.INT_ID
from
(
		SELECT ANIM_KEY
		FROM ID_XREF_TABLE
		WHERE SPECIES_CODE =0 AND SEX_CODE ='M'  
		GROUP BY ANIM_KEY
		HAVING COUNT(1)>1
)xref
		INNER JOIN ID_XREF_TABLE id 
		on id.ANIM_KEY = xref.ANIM_KEY
		and id.SPECIES_CODE =0 
		and id.SEX_CODE ='M'
		and length(id.INT_ID)=17 
		;
		
		

CREATE TABLE ID_XREF_TABLE_COMPACT_COW
(
 ANIM_KEY int not null,
 INT_ID varchar(17) not null,
 constraint ID_XREF_TABLE_COMPACT_COW_PK PRIMARY KEY (ANIM_KEY,INT_ID)
);

INSERT INTO ID_XREF_TABLE_COMPACT_COW(ANIM_KEY,INT_ID)
SELECT id.ANIM_KEY, id.INT_ID
 
from
(
		SELECT ANIM_KEY
		FROM ID_XREF_TABLE
		WHERE SPECIES_CODE =0 AND SEX_CODE ='F'
		GROUP BY ANIM_KEY
		HAVING COUNT(1)>1
)xref
		INNER JOIN ID_XREF_TABLE id 
		on id.ANIM_KEY = xref.ANIM_KEY
		and id.SPECIES_CODE =0 
		and id.SEX_CODE ='F'
		and length(id.INT_ID)=17;
		