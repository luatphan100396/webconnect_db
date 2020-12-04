
create table LACTA90_TABLE_LAST_LACT_COMPACT(
   ANIM_KEY                     integer       not null,
    CALV_PDATE                   smallint      not null,
    HERD_CODE                    integer       not null,
    TERM_CODE                    char(1)       not null,
    DIM_QTY                      smallint      not null,
    CONSTRAINT LACTA90_TABLE_LAST_LACT_COMPACT_PK primary key ( ANIM_KEY, CALV_PDATE, HERD_CODE)
  );
  
  
insert into LACTA90_TABLE_LAST_LACT_COMPACT( ANIM_KEY, HERD_CODE,CALV_PDATE,TERM_CODE,DIM_QTY)
select  ANIM_KEY, HERD_CODE,CALV_PDATE,TERM_CODE,DIM_QTY
from 
(select ANIM_KEY, HERD_CODE,CALV_PDATE,TERM_CODE,DIM_QTY, 
   ROW_NUMBER()OVER(PARTITION BY ANIM_KEY ORDER BY COALESCE(CALV_PDATE,-999999) DESC) as rn
from lacta90_table
where species_code =0  
)a
where rn =1;