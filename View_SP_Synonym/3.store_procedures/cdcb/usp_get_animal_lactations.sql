CREATE OR REPLACE PROCEDURE usp_Get_Animal_Lactations
--======================================================
--Author: Nghi Ta
--Created Date: 2020-05-12
--Description: Get lactation data for animal 
--Output: 
--        +Ds1: animal lactation data, test data
--======================================================
( 
    IN @INT_ID char(17), 
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE char(1),
	IN @SEX_CODE char(1) 
)
DYNAMIC RESULT SETS 10
    
BEGIN
   
	DECLARE DEFAULT_DATE date;
	
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpLactMaskCode
	(
	 Mask_Char char(1),
	 Mask_Value varchar(50)
	) with replace ON COMMIT PRESERVE ROWS;
	 
	 INSERT INTO SESSION.TmpLactMaskCode
	 (Mask_Char,Mask_Value)
	 
      SELECT  Mask_Char,Mask_Value 
	    FROM (
	    VALUES ('1', 'x1y'),
			   ('2', 'x2y'),
			   ('3', 'x2y,x1y'),
			   ('4', 'x4y'),
			   ('5', 'x4y,x1y'),
			   ('6', 'x4y,x2y'),
			   ('7', 'x4y,x2y,x1y'),
			   ('8', 'x8y'),
			   ('9', 'x8y,x1y'),
			   ('a', 'x8y,x2y'),
			   ('b', 'x8y,x2y,x1y'),
			   ('c', 'x8y,x4y'),
			   ('d', 'x8y,x4y,x1y'),
			   ('e', 'x8y,x4y,x2y'),
			   ('f', 'x8y,x4y,x2y,x1y') 
	    )t (Mask_Char,Mask_Value );
	    
	    
	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
	
	begin
  		declare cir cursor with return for
  		select  
  		    lact.ANIM_KEY,
  		    lact.SPECIES_CODE,
			lact.CALV_PDATE, 
			lact.HERD_CODE,
			ascii(lact.LACT_NUM) as LACT_NUM,
			varchar_format(DEFAULT_DATE + lact.calv_pdate,'YYYY-MM-DD') as FRESH_DATE,
			lact.DIM_QTY, 
			lact.CTRL_NUM,
			varchar_format(DEFAULT_DATE + lact.proc_pdate,'YYYY-MM-DD') as PROC_DATE,
			varchar_format(DEFAULT_DATE + lact.modify_pdate,'YYYY-MM-DD') as MODIFY_DATE,
			lact.LACT_TYPE_CODE,
			hex(lact_mask) as LACT_MASK, 
			lact.INIT_CODE,
			lact.TERM_CODE,
			lact.TERM_2ND_CODE, 
			ASCII(lact.OS_PCT) as OS_PCT,
			lact.DAYS_OPEN_VERIF_CODE as PREG_CONFIRM_CODE, 
			lact.DAYS_OPEN_QTY,  
			case when (coalesce((select replace(replace(Mask_Value,'y','0'),'x','') from SESSION.TmpLactMaskCode where Mask_Char = left(lower(hex(LACT_MASK)),1) ),'')
                      ||coalesce((select ','|| replace(replace(Mask_Value,'y',''),'x','0') from SESSION.TmpLactMaskCode where Mask_Char = right(lower(hex(LACT_MASK)),1)), '') 
                    ) like '%08%' 
					  or lact.me_mlk_qty = -1 
					  or uchar2schar(lact.dcr_mlk_qty) =  -1  
					  or lact.me_fat_qty= -1 
			        then 'No'  
			    else 'Yes' 
			end as USABLE,  
			PROGENY_QTY,
			ASCII(lact.TESTDAY_CNT) AS TESTDAY_CNT  
			from lacta90_table lact
			where lact.anim_key = @ANIM_KEY
			and lact.species_code =@SPECIES_CODE
			order by lact.calv_pdate desc
			with UR
			;
			
			-- Calculate DRPC
			
			/*
			select l.*, htd.CTR_CODE
 from
(
	select l.anim_key, 
			l.species_code, 
			l.calv_pdate,
			l.dim_qty,
			l.herd_code,
			min(htd.sampl_pdate) as htd_min_sampl_pdate 
	from 
	(
	select anim_key,species_code,herd_code,calv_pdate,dim_qty
	from lacta90_table l
	where anim_key = 16503034 and species_code ='0'
	) l
	inner join herd_td_table htd 
	on l.herd_code = htd.herd_code 
	and htd.sampl_pdate >= (l.calv_pdate+l.dim_qty)
	group by l.anim_key, 
			l.species_code, 
			l.calv_pdate,
			l.dim_qty,
			l.herd_code
		
)l
inner join herd_td_table htd
on l.herd_code = htd.herd_code
and l.htd_min_sampl_pdate = htd.sampl_pdate
			*/
			 
  	    open cir;
    end;
 	      
 
        
END