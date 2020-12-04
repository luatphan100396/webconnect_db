
create table TMP_PTA_SAS7BDAT_1908
( 
rip varchar(10),
ripp varchar(10),
brdevl varchar(2),
bull17 varchar(17),
sire17 varchar(17),
dam17 varchar(17),
mgs17 varchar(17),
alias17 varchar(10),
birth varchar(8),
regstat varchar(10),
name varchar(30),
short varchar(10),
yrmoai varchar(10),
sample varchar(10),
smplctrl varchar(10),
status varchar(1),
cntrler varchar(10),
naabcdes varchar(10),
naab varchar(10),
herd varchar(10),
daumost varchar(10),
stmost varchar(10),
dauage varchar(10),
osdaupc varchar(10),
inbrd varchar(10),
dauinbrd varchar(10),
futdau varchar(10),
relyld varchar(10),
relDPR varchar(10),
ptam varchar(10),
relm varchar(10),
ptaf varchar(10),
ptafpc varchar(10),
relp varchar(10),
ptap varchar(10),
ptappc varchar(10),
relpl varchar(10),
ptapl varchar(10),
rels varchar(10),
ptas varchar(10),
relnm varchar(10),
FMerit varchar(10),
netmerit varchar(10),
CMerit varchar(10),
pctl varchar(10),
ptaDPR varchar(10),
DPRitb varchar(10),
dim varchar(10),
dimp varchar(10),
agewtpl varchar(10),
pedcomp varchar(10),
herdsDPR varchar(10),
herds varchar(10),
herdsp varchar(10),
herdspl varchar(10),
herdss varchar(10),
dausDPR varchar(10),
daus varchar(10),
dausp varchar(10),
dauspl varchar(10),
dauss varchar(10),
SCS_code varchar(10),
prefid varchar(10),
plitb varchar(10),
daurec varchar(10),
daurecp varchar(10),
Heterosis varchar(10),
mgtnum varchar(10),
mgtnump varchar(10),
predxbrd varchar(10),
DPR varchar(10),
milk varchar(10),
fat varchar(10),
fatpct varchar(10),
milkp varchar(10),
protein varchar(10),
protpc varchar(10),
plife varchar(10),
scs varchar(10),
cineval varchar(10),
cmosdau varchar(10),
dydm varchar(10),
dydf varchar(10),
dydfpc varchar(10),
dydmp varchar(10),
dydp varchar(10),
dydppc varchar(10),
devpl varchar(10),
devs varchar(10),
xbrdpc varchar(10),
pam varchar(10),
relpam varchar(10),
paf varchar(10),
relpap varchar(10),
pap varchar(10),
relpapl varchar(10),
papl varchar(10),
relpas varchar(10),
pas varchar(10),
pcus varchar(10),
ibuse varchar(10),
hbid varchar(10),
recess varchar(10),
devDPR varchar(10),
paDPR varchar(10),
relpaDPR varchar(10),
panm varchar(10),
relpanm varchar(10),
scr varchar(10),
relscr varchar(10),
brdnqty varchar(10),
WW17 varchar(10),
gind varchar(10),
naabcdes2 varchar(10),
ptahcr varchar(10),
relhcr varchar(10),
herdshcr varchar(10),
daushcr varchar(10),
itbhcr varchar(10),
ptaccr varchar(10),
relccr varchar(10),
herdsccr varchar(10),
dausccr varchar(10),
itbccr varchar(10),
pahcr varchar(10),
parelhcr varchar(10),
paccr varchar(10),
parelccr varchar(10),
chip varchar(10),
gen_inb varchar(10),
fut_gen_inb varchar(10),
GMerit varchar(10),
ptaliv varchar(10),
relliv varchar(10),
herdsliv varchar(10),
dausliv varchar(10),
paliv varchar(10),
relpaliv varchar(10),
ptagl varchar(10),
relgl varchar(10),
herdsgl varchar(10),
dausgl varchar(10),
pagl varchar(10),
relpagl varchar(10),
ptamfv varchar(10),
relmfv varchar(10),
herdsmfv varchar(10),
dausmfv varchar(10),
pamfv varchar(10),
relpamfv varchar(10),
ptadab varchar(10),
reldab varchar(10),
herdsdab varchar(10),
dausdab varchar(10),
padab varchar(10),
relpadab varchar(10),
ptaket varchar(10),
relket varchar(10),
herdsket varchar(10),
dausket varchar(10),
paket varchar(10),
relpaket varchar(10),
ptamas varchar(10),
relmas varchar(10),
herdsmas varchar(10),
dausmas varchar(10),
pamas varchar(10),
relpamas varchar(10),
ptamet varchar(10),
relmet varchar(10),
herdsmet varchar(10),
dausmet varchar(10),
pamet varchar(10),
relpamet varchar(10),
ptarpl varchar(10),
relrpl varchar(10),
herdsrpl varchar(10),
dausrpl varchar(10),
parpl varchar(10),
relparpl varchar(10),
ptaefc varchar(10),
relefc varchar(10),
herdsefc varchar(10),
dausefc varchar(10),
paefc varchar(10),
relpaefc varchar(10),
ANIM_KEY int 

)
;

/*
db2 connect to cdcbdb
db2 IMPORT FROM "/home/db2inst1/Data/1912/pta1908.csv" OF DEL skipcount 1 INSERT INTO TMP_PTA_SAS7BDAT_1908

*/

create table TMP_PTA_SAS7BDAT_1912
( 
rip varchar(10),
ripp varchar(10),
brdevl varchar(2),
bull17 varchar(17),
sire17 varchar(17),
dam17 varchar(17),
mgs17 varchar(17),
alias17 varchar(10),
birth varchar(8),
regstat varchar(10),
name varchar(30),
short varchar(10),
yrmoai varchar(10),
sample varchar(10),
smplctrl varchar(10),
status varchar(1),
cntrler varchar(10),
naabcdes varchar(10),
naab varchar(10),
herd varchar(10),
daumost varchar(10),
stmost varchar(10),
dauage varchar(10),
osdaupc varchar(10),
inbrd varchar(10),
dauinbrd varchar(10),
futdau varchar(10),
relyld varchar(10),
relDPR varchar(10),
ptam varchar(10),
relm varchar(10),
ptaf varchar(10),
ptafpc varchar(10),
relp varchar(10),
ptap varchar(10),
ptappc varchar(10),
relpl varchar(10),
ptapl varchar(10),
rels varchar(10),
ptas varchar(10),
relnm varchar(10),
FMerit varchar(10),
netmerit varchar(10),
CMerit varchar(10),
pctl varchar(10),
ptaDPR varchar(10),
DPRitb varchar(10),
dim varchar(10),
dimp varchar(10),
agewtpl varchar(10),
pedcomp varchar(10),
herdsDPR varchar(10),
herds varchar(10),
herdsp varchar(10),
herdspl varchar(10),
herdss varchar(10),
dausDPR varchar(10),
daus varchar(10),
dausp varchar(10),
dauspl varchar(10),
dauss varchar(10),
SCS_code varchar(10),
prefid varchar(10),
plitb varchar(10),
daurec varchar(10),
daurecp varchar(10),
Heterosis varchar(10),
mgtnum varchar(10),
mgtnump varchar(10),
predxbrd varchar(10),
DPR varchar(10),
milk varchar(10),
fat varchar(10),
fatpct varchar(10),
milkp varchar(10),
protein varchar(10),
protpc varchar(10),
plife varchar(10),
scs varchar(10),
cineval varchar(10),
cmosdau varchar(10),
dydm varchar(10),
dydf varchar(10),
dydfpc varchar(10),
dydmp varchar(10),
dydp varchar(10),
dydppc varchar(10),
devpl varchar(10),
devs varchar(10),
xbrdpc varchar(10),
pam varchar(10),
relpam varchar(10),
paf varchar(10),
relpap varchar(10),
pap varchar(10),
relpapl varchar(10),
papl varchar(10),
relpas varchar(10),
pas varchar(10),
pcus varchar(10),
ibuse varchar(10),
hbid varchar(10),
recess varchar(10),
devDPR varchar(10),
paDPR varchar(10),
relpaDPR varchar(10),
panm varchar(10),
relpanm varchar(10),
scr varchar(10),
relscr varchar(10),
brdnqty varchar(10),
WW17 varchar(10),
gind varchar(10),
naabcdes2 varchar(10),
ptahcr varchar(10),
relhcr varchar(10),
herdshcr varchar(10),
daushcr varchar(10),
itbhcr varchar(10),
ptaccr varchar(10),
relccr varchar(10),
herdsccr varchar(10),
dausccr varchar(10),
itbccr varchar(10),
pahcr varchar(10),
parelhcr varchar(10),
paccr varchar(10),
parelccr varchar(10),
chip varchar(10),
gen_inb varchar(10),
fut_gen_inb varchar(10),
GMerit varchar(10),
ptaliv varchar(10),
relliv varchar(10),
herdsliv varchar(10),
dausliv varchar(10),
paliv varchar(10),
relpaliv varchar(10),
ptagl varchar(10),
relgl varchar(10),
herdsgl varchar(10),
dausgl varchar(10),
pagl varchar(10),
relpagl varchar(10),
ptamfv varchar(10),
relmfv varchar(10),
herdsmfv varchar(10),
dausmfv varchar(10),
pamfv varchar(10),
relpamfv varchar(10),
ptadab varchar(10),
reldab varchar(10),
herdsdab varchar(10),
dausdab varchar(10),
padab varchar(10),
relpadab varchar(10),
ptaket varchar(10),
relket varchar(10),
herdsket varchar(10),
dausket varchar(10),
paket varchar(10),
relpaket varchar(10),
ptamas varchar(10),
relmas varchar(10),
herdsmas varchar(10),
dausmas varchar(10),
pamas varchar(10),
relpamas varchar(10),
ptamet varchar(10),
relmet varchar(10),
herdsmet varchar(10),
dausmet varchar(10),
pamet varchar(10),
relpamet varchar(10),
ptarpl varchar(10),
relrpl varchar(10),
herdsrpl varchar(10),
dausrpl varchar(10),
parpl varchar(10),
relparpl varchar(10),
ptaefc varchar(10),
relefc varchar(10),
herdsefc varchar(10),
dausefc varchar(10),
paefc varchar(10),
relpaefc varchar(10),
ANIM_KEY int 

)
;



/*
db2 connect to cdcbdb
db2 IMPORT FROM "/home/db2inst1/Data/1912/pta1912.csv" OF DEL skipcount 1 INSERT INTO TMP_PTA_SAS7BDAT_1912

*/
 
create table PTA_BULL_SAS7BDAT
( 
eval_pdate smallint not null,
anim_key int not null ,
rip varchar(10),
ripp varchar(10),
brdevl varchar(2),
bull17 varchar(17),
sire17 varchar(17),
dam17 varchar(17),
mgs17 varchar(17),
alias17 varchar(10),
birth varchar(8),
regstat varchar(10),
name varchar(30),
short varchar(10),
yrmoai varchar(10),
sample varchar(10),
smplctrl varchar(10),
status varchar(1),
cntrler varchar(10),
naabcdes varchar(10),
naab varchar(10),
herd varchar(10),
daumost varchar(10),
stmost varchar(10),
dauage varchar(10),
osdaupc varchar(10),
inbrd varchar(10),
dauinbrd varchar(10),
futdau varchar(10),
relyld varchar(10),
relDPR varchar(10),
ptam varchar(10),
relm varchar(10),
ptaf varchar(10),
ptafpc varchar(10),
relp varchar(10),
ptap varchar(10),
ptappc varchar(10),
relpl varchar(10),
ptapl varchar(10),
rels varchar(10),
ptas varchar(10),
relnm varchar(10),
FMerit varchar(10),
netmerit varchar(10),
CMerit varchar(10),
pctl varchar(10),
ptaDPR varchar(10),
DPRitb varchar(10),
dim varchar(10),
dimp varchar(10),
agewtpl varchar(10),
pedcomp varchar(10),
herdsDPR varchar(10),
herds varchar(10),
herdsp varchar(10),
herdspl varchar(10),
herdss varchar(10),
dausDPR varchar(10),
daus varchar(10),
dausp varchar(10),
dauspl varchar(10),
dauss varchar(10),
SCS_code varchar(10),
prefid varchar(10),
plitb varchar(10),
daurec varchar(10),
daurecp varchar(10),
Heterosis varchar(10),
mgtnum varchar(10),
mgtnump varchar(10),
predxbrd varchar(10),
DPR varchar(10),
milk varchar(10),
fat varchar(10),
fatpct varchar(10),
milkp varchar(10),
protein varchar(10),
protpc varchar(10),
plife varchar(10),
scs varchar(10),
cineval varchar(10),
cmosdau varchar(10),
dydm varchar(10),
dydf varchar(10),
dydfpc varchar(10),
dydmp varchar(10),
dydp varchar(10),
dydppc varchar(10),
devpl varchar(10),
devs varchar(10),
xbrdpc varchar(10),
pam varchar(10),
relpam varchar(10),
paf varchar(10),
relpap varchar(10),
pap varchar(10),
relpapl varchar(10),
papl varchar(10),
relpas varchar(10),
pas varchar(10),
pcus varchar(10),
ibuse varchar(10),
hbid varchar(10),
recess varchar(10),
devDPR varchar(10),
paDPR varchar(10),
relpaDPR varchar(10),
panm varchar(10),
relpanm varchar(10),
scr varchar(10),
relscr varchar(10),
brdnqty varchar(10),
WW17 varchar(10),
gind varchar(10),
naabcdes2 varchar(10),
ptahcr varchar(10),
relhcr varchar(10),
herdshcr varchar(10),
daushcr varchar(10),
itbhcr varchar(10),
ptaccr varchar(10),
relccr varchar(10),
herdsccr varchar(10),
dausccr varchar(10),
itbccr varchar(10),
pahcr varchar(10),
parelhcr varchar(10),
paccr varchar(10),
parelccr varchar(10),
chip varchar(10),
gen_inb varchar(10),
fut_gen_inb varchar(10),
GMerit varchar(10),
ptaliv varchar(10),
relliv varchar(10),
herdsliv varchar(10),
dausliv varchar(10),
paliv varchar(10),
relpaliv varchar(10),
ptagl varchar(10),
relgl varchar(10),
herdsgl varchar(10),
dausgl varchar(10),
pagl varchar(10),
relpagl varchar(10),
ptamfv varchar(10),
relmfv varchar(10),
herdsmfv varchar(10),
dausmfv varchar(10),
pamfv varchar(10),
relpamfv varchar(10),
ptadab varchar(10),
reldab varchar(10),
herdsdab varchar(10),
dausdab varchar(10),
padab varchar(10),
relpadab varchar(10),
ptaket varchar(10),
relket varchar(10),
herdsket varchar(10),
dausket varchar(10),
paket varchar(10),
relpaket varchar(10),
ptamas varchar(10),
relmas varchar(10),
herdsmas varchar(10),
dausmas varchar(10),
pamas varchar(10),
relpamas varchar(10),
ptamet varchar(10),
relmet varchar(10),
herdsmet varchar(10),
dausmet varchar(10),
pamet varchar(10),
relpamet varchar(10),
ptarpl varchar(10),
relrpl varchar(10),
herdsrpl varchar(10),
dausrpl varchar(10),
parpl varchar(10),
relparpl varchar(10),
ptaefc varchar(10),
relefc varchar(10),
herdsefc varchar(10),
dausefc varchar(10),
paefc varchar(10),
relpaefc varchar(10),
constraint PTA_BULL_SAS7BDAT_PK primary key (eval_pdate, anim_key)

)
;


insert into PTA_BULL_SAS7BDAT
select t.EVAL_PDATE
 ,id.anim_key
 ,t.RIP
 ,t.RIPP
 ,t.BRDEVL
 ,t.BULL17
 ,t.SIRE17
 ,t.DAM17
 ,t.MGS17
 ,t.ALIAS17
 ,t.BIRTH
 ,t.REGSTAT
 ,t.NAME
 ,t.SHORT
 ,t.YRMOAI
 ,t.SAMPLE
 ,t.SMPLCTRL
 ,t.STATUS
 ,t.CNTRLER
 ,t.NAABCDES
 ,t.NAAB
 ,t.HERD
 ,t.DAUMOST
 ,t.STMOST
 ,t.DAUAGE
 ,t.OSDAUPC
 ,t.INBRD
 ,t.DAUINBRD
 ,t.FUTDAU
 ,t.RELYLD
 ,t.RELDPR
 ,t.PTAM
 ,t.RELM
 ,t.PTAF
 ,t.PTAFPC
 ,t.RELP
 ,t.PTAP
 ,t.PTAPPC
 ,t.RELPL
 ,t.PTAPL
 ,t.RELS
 ,t.PTAS
 ,t.RELNM
 ,t.FMERIT
 ,t.NETMERIT
 ,t.CMERIT
 ,t.PCTL
 ,t.PTADPR
 ,t.DPRITB
 ,t.DIM
 ,t.DIMP
 ,t.AGEWTPL
 ,t.PEDCOMP
 ,t.HERDSDPR
 ,t.HERDS
 ,t.HERDSP
 ,t.HERDSPL
 ,t.HERDSS
 ,t.DAUSDPR
 ,t.DAUS
 ,t.DAUSP
 ,t.DAUSPL
 ,t.DAUSS
 ,t.SCS_CODE
 ,t.PREFID
 ,t.PLITB
 ,t.DAUREC
 ,t.DAURECP
 ,t.HETEROSIS
 ,t.MGTNUM
 ,t.MGTNUMP
 ,t.PREDXBRD
 ,t.DPR
 ,t.MILK
 ,t.FAT
 ,t.FATPCT
 ,t.MILKP
 ,t.PROTEIN
 ,t.PROTPC
 ,t.PLIFE
 ,t.SCS
 ,t.CINEVAL
 ,t.CMOSDAU
 ,t.DYDM
 ,t.DYDF
 ,t.DYDFPC
 ,t.DYDMP
 ,t.DYDP
 ,t.DYDPPC
 ,t.DEVPL
 ,t.DEVS
 ,t.XBRDPC
 ,t.PAM
 ,t.RELPAM
 ,t.PAF
 ,t.RELPAP
 ,t.PAP
 ,t.RELPAPL
 ,t.PAPL
 ,t.RELPAS
 ,t.PAS
 ,t.PCUS
 ,t.IBUSE
 ,t.HBID
 ,t.RECESS
 ,t.DEVDPR
 ,t.PADPR
 ,t.RELPADPR
 ,t.PANM
 ,t.RELPANM
 ,t.SCR
 ,t.RELSCR
 ,t.BRDNQTY
 ,t.WW17
 ,t.GIND
 ,t.NAABCDES2
 ,t.PTAHCR
 ,t.RELHCR
 ,t.HERDSHCR
 ,t.DAUSHCR
 ,t.ITBHCR
 ,t.PTACCR
 ,t.RELCCR
 ,t.HERDSCCR
 ,t.DAUSCCR
 ,t.ITBCCR
 ,t.PAHCR
 ,t.PARELHCR
 ,t.PACCR
 ,t.PARELCCR
 ,t.CHIP
 ,t.GEN_INB
 ,t.FUT_GEN_INB
 ,t.GMERIT
 ,t.PTALIV
 ,t.RELLIV
 ,t.HERDSLIV
 ,t.DAUSLIV
 ,t.PALIV
 ,t.RELPALIV
 ,t.PTAGL
 ,t.RELGL
 ,t.HERDSGL
 ,t.DAUSGL
 ,t.PAGL
 ,t.RELPAGL
 ,t.PTAMFV
 ,t.RELMFV
 ,t.HERDSMFV
 ,t.DAUSMFV
 ,t.PAMFV
 ,t.RELPAMFV
 ,t.PTADAB
 ,t.RELDAB
 ,t.HERDSDAB
 ,t.DAUSDAB
 ,t.PADAB
 ,t.RELPADAB
 ,t.PTAKET
 ,t.RELKET
 ,t.HERDSKET
 ,t.DAUSKET
 ,t.PAKET
 ,t.RELPAKET
 ,t.PTAMAS
 ,t.RELMAS
 ,t.HERDSMAS
 ,t.DAUSMAS
 ,t.PAMAS
 ,t.RELPAMAS
 ,t.PTAMET
 ,t.RELMET
 ,t.HERDSMET
 ,t.DAUSMET
 ,t.PAMET
 ,t.RELPAMET
 ,t.PTARPL
 ,t.RELRPL
 ,t.HERDSRPL
 ,t.DAUSRPL
 ,t.PARPL
 ,t.RELPARPL
 ,t.PTAEFC
 ,t.RELEFC
 ,t.HERDSEFC
 ,t.DAUSEFC
 ,t.PAEFC
 ,t.RELPAEFC
 
from 
( 
select *, 
21762 as eval_pdate,
row_number()over(partition by bull17 order by bull17)  as rn
from TMP_PTA_SAS7BDAT_1908



union

select *, 
21884 as eval_pdate,
row_number()over(partition by bull17 order by bull17)  as rn
from TMP_PTA_SAS7BDAT_1912

)
 t
inner join ID_XREF_TABLE id
on t.bull17 = id.int_id
and id.species_code ='0'
and id.sex_code ='M'
and id.PREFERRED_CODE =1
and t.rn=1
;
