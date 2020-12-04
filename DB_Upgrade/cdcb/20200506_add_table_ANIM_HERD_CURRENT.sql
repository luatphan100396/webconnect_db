CREATE TABLE ANIM_HERD_CURRENT
(

ANIM_KEY INT not null,
SPECIES_CODE char(1) not null,
HERD_CODE int not null,
CTRL_NUM int null, 
LAST_TRANSFER_DATE smallint,
constraint ANIM_HERD_CURRENT_PK PRIMARY KEY ( ANIM_KEY)
);
create index ANIM_HERD_CURRENT_HERD_INDEX               on ANIM_HERD_CURRENT                 (HERD_CODE asc ) allow reverse scans; 
 
insert into ANIM_HERD_CURRENT
(ANIM_KEY,
SPECIES_CODE,
HERD_CODE,
CTRL_NUM,
LAST_TRANSFER_DATE
)
select 
ANIM_KEY,
SPECIES_CODE,
HERD_CODE,
CTRL_NUM,
CALV_PDATE as LAST_TRANSFER_DATE
from
(
select 
ANIM_KEY, 
SPECIES_CODE, 
CTRL_NUM, 
HERD_CODE,
CALV_PDATE,
row_number()over(partition by anim_key order by calv_pdate desc) as RN
from lacta90_table
)lact
where rn =1;
