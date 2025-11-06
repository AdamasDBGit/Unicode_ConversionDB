CREATE PROCEDURE [dbo].[uspGetEvalActivity] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

    -- Insert statements for procedure here
	select TAM.*,I_Evaluation_ID from T_Activity_Master as TAM
LEFT OUTER join T_ActivityEvalCriteria_Map as TAECM
on TAM.I_Activity_ID = TAECM.I_Activity_ID
where TAM.I_Status = 1
	
END
