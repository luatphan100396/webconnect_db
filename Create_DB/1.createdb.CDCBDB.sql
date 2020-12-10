-- parted /dev/CDCBDB unit B print
--
-- Number  Start           End             Size in Bytes

--  1      1048576B        8421113855B     8420065280B       /32768 = 256960    CDCBDB1 catalog
--  2      8421113856B     151999479807B   143578365952B     /32768 = 4381664   CDCBDB2 tempspace
--  3      151999479808B   219000340479B   67000860672B      /32768 = 2044704   CDCBDB3 userspace1
--  4      219000340480B   286000152575B   66999812096B      /32768 = 2044672   CDCBDB4 index1
--  5      286000152576B   403999555583B   117999403008B     /32768 = 3601056   CDCBDB5 index2
--  6      403999555584B   658000314367B   254000758784B     /32768 = 7751488   CDCBDB6 evaluation
--  7      658000314368B   759000203263B   100999888896B     /32768 = 3082272   CDCBDB7 pedigree
--  8      759000203264B   928000245759B   169000042496B     /32768 = 5157472   CDCBDB8 lactation
--  9      928000245760B   1180999614463B  252999368704B     /32768 = 7720928   CDCBDB9 userspace3
-- 10      1180999614464B  1933999865855B  753000251392B     /32768 = 22979744  CDCBDB10 genomic
-- 11      1933999865856B  1951000428543B  17000562688B      /32768 = 518816    CDCBDB11 usr_temp
-- 12      1951000428544B  2200095948799B  249095520256B     /32768 = 7601792   CDCBDB12 cdcbonly

--
-- Before executing:
--    db2set DB2_ENABLE_AUTOCONFIG_DEFAULT=YES
--
-- After executing:
--    db2 set event monitor  db2detaildeadlock state=0
--    db2 DROP EVENT MONITOR db2detaildeadlock
--    auto_runstats database configuration parameter should be OFF
--    self_tuning_mem database configuration parameter should be ON

CREATE DATABASE CDCBDB
   AUTOMATIC STORAGE YES
   ON /home/db2inst2/cdcbdb2
   ALIAS cdcbdb
   USING CODESET ISO8859-1
   TERRITORY US
   PAGESIZE 32 K
   RESTRICTIVE
    ;

TERMINATE;

