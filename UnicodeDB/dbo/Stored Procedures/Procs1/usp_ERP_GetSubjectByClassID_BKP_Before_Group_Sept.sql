
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>

--exec [dbo].[usp_ERP_GetSubjectByClassID] 14
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetSubjectByClassID_BKP_Before_Group_Sept]
	-- Add the parameters for the stored procedure here
	(
		@classID INT = NULL
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	TSM.I_Class_ID AS ClassID,
	TSM.I_Subject_ID AS SubjectID,
	TSM.S_Subject_Name AS SubjectName

	FROM 
	T_Subject_Master TSM

	WHERE 
	TSM.I_Class_ID = @classID OR @classID IS NULL

END
