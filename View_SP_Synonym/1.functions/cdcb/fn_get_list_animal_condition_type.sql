CREATE OR REPLACE FUNCTION fn_Get_List_Animal_Condition_Type
--======================================================
--Author: Nghi Ta
--Created Date: 2020-06-15
--Description: Get list animal condition type
--list of value
--======================================================
(
  
) 
RETURNS TABLE (SUBSET_DESC varchar(200), SUBSET_CODE varchar(50))

LANGUAGE SQL

RETURN

   SELECT SUBSET_DESC, SUBSET_CODE
	FROM (
	VALUES ('Active AI Bulls','A'),
	       ('Active AI Bulls','A_F'),
           ('Genomic Young Bulls','G_young') ,
	       ('Genomic tested young bulls being marketed','G_young_marked')  ,
	       ('AI bulls born in last 8 years','AI_last_8yr'),
	       ('Non-AI bulls born in last 8 years','Non_AI_last_8yr'),
	       ('First-evaluation AI bulls','First_Eval_AI'),
	       ('First-evaluation non-AI bulls','First_Eval_Non_AI'),
	       ('AI Status (A,F,G)','A_F_G'),
           ('Available (A,F,G + Animals with NAAB Code)','NAAB Code'),
           ('Active AI Sire (A)','A'),
	       ('Foreign (F)','F'),
	       ('Genomically Tested (G)', 'G'),
           ('Natural Service Bulls (N)','N'),
	       ('Collected (C)', 'C'),
	       ('Progeny Test (P)', 'P'), 
	       ('Inactive (I)','I'),
	       ('Unproven Bulls','Unproven Bulls'),
	       ('Cows','Cow'),
		   ('Heifers','Heifer'),  
           ('Proven Bulls','Proven Bulls'),
           ('Young Available Bulls','Young Available Bulls'),
	       ('Young Bulls','Young Bulls') 
		)t (SUBSET_DESC, SUBSET_CODE)