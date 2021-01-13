INSERT INTO GROUP_RESTRICTED_FIELD_TABLE
(
    GROUP_KEY,
	FIELD_KEY,
	CREATED_TIME,
	MODIFIED_TIME
)
SELECT  GROUP_KEY,
	field.FIELD_KEY,
	current timestamp as CREATED_TIME,
	current timestamp as MODIFIED_TIME 
FROM   FEATURE_COMPONENT_TABLE fc 
INNER JOIN FEATURE_TABLE f
    ON f.FEATURE_KEY = fc.FEATURE_KEY
    and f.FEATURE_NAME ='Queries >> Cattle - Lactations'
INNER JOIN FIELD_TABLE field
    on field.COMPONENT_KEY = fc.COMPONENT_KEY
  , 
  (
	  select GROUP_KEY
	  from GROUP_TABLE
	  where GROUP_SHORT_NAME = 'PUBLIC'
  )g
where
  fc.COMPONENT_NAME ='Lactation Information Records'
  and field.FIELD_NAME NOT IN 
  ( 'Lact',
    'Fresh Date',
    'DIM',
    'Herd',
    'Proc Date',
    'LT',
    'LI',
    'TC',
    'OS%',
    'Opn',
    'Usable'
);