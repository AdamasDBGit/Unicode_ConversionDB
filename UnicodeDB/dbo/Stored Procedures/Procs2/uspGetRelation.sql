--exec [dbo].[uspGetRelation] 
CREATE PROCEDURE [dbo].[uspGetRelation]

AS
BEGIN
select
I_Relation_Master_ID id,
S_Relation_Type relation_type
from T_Relation_Master where I_Relation_Master_ID not in (1,2)
END
