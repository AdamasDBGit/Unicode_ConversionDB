CREATE PROCEDURE [dbo].[uspGetAllClassByClassGroup]
	-- Add the parameters for the stored procedure here
	@iclassGroupID INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select 
	TC.I_Class_ID ClassID
	,TC.S_Class_Name ClassName
from T_School_Group TSG inner join T_School_Group_Class TSGS 
ON TSG.I_School_Group_ID = TSGS.I_School_Group_ID
inner join T_Class TC ON TC.I_Class_ID = TSGS.I_Class_ID
where TSG.I_School_Group_ID = @iclassGroupID AND TC.I_Status=1

END