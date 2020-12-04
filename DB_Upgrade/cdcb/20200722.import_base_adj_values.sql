
 create table base_adj_values
 (
  eval_pdate smallint not null,
  eval_breed_code char(2) not null,
  yield_mean float,
  ebv_mean float,
  efi_mean float,
  eval_trait smallint not null,
  SD_ratio float,
  inbrd_reg float,
  heterosis_value float,
  constraint base_adj_values_pk primary key (eval_pdate,eval_breed_code,eval_trait)
 );
 
 
  
 create table tmp_base_adj_values
 ( 
  eval_breed_code char(2) ,
  yield_mean float,
  ebv_mean float,
  efi_mean float,
  eval_trait smallint ,
  SD_ratio float,
  inbrd_reg float,
  heterosis_value float 
 );
 
  /*
 db2 connect to cdcbdb
 db2 IMPORT FROM "/home/db2inst1/Data/1912/base_adj_values.1912.csv" OF DEL skipcount 1 INSERT INTO tmp_base_adj_values
 */
 
 insert into base_adj_values
 (
  eval_pdate,
  eval_breed_code,
  yield_mean,
  ebv_mean,
  efi_mean,
  eval_trait,
  SD_ratio,
  inbrd_reg,
  heterosis_value
 )
 select 21884 as  eval_pdate,
		  eval_breed_code,
		  yield_mean,
		  ebv_mean,
		  efi_mean,
		  eval_trait,
		  SD_ratio,
		  inbrd_reg,
		  heterosis_value
 from tmp_base_adj_values;
 drop table tmp_base_adj_values;
 
 