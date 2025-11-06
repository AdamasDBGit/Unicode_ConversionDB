-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>

--exec [dbo].[usp_ERP_GetFacultyBySubjectID] 26
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetFacultyBySubjectID]
	-- Add the parameters for the stored procedure here
	(
		@subjectID INT = NULL
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	TEFS.I_Subject_ID AS SubjectID,
	TEFS.I_Faculty_Master_ID AS FacultyID,
	TFM.S_Faculty_Name AS FacultyName

	FROM 
	T_ERP_Faculty_Subject TEFS 
	inner join T_Faculty_Master TFM ON TFM.I_Faculty_Master_ID = TEFS.I_Faculty_Master_ID

	WHERE
	TEFS.I_Subject_ID = @subjectID OR @subjectID IS NULL
END
