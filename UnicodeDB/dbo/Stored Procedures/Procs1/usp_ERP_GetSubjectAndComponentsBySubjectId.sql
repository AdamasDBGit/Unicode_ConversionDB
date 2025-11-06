-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec usp_ERP_GetSubjectAndComponentsBySubjectId 1
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetSubjectAndComponentsBySubjectId]
(
	@iSubjectID INT = NULL
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	I_Subject_ID AS SubjectID,
	I_School_Group_ID AS SchoolGroupID,
	I_Class_ID AS ClassID,
	I_Stream_ID AS StreamID,
	S_Subject_Code AS SubjectCode,
	S_Subject_Name AS SubjectName,
	I_Subject_Type AS SubjectTypeID,
	I_TotalNoOfClasses AS TotalNumberOfLecturesRequired,
	I_Status AS Status
	FROM T_Subject_Master WHERE I_Subject_ID = @iSubjectID;

	SELECT 
	I_Subject_Component_Mapping,
	I_Subject_Component_ID,
	Is_Active AS IsSelected

	FROM T_ERP_Subject_Component_Mapping WHERE I_Subject_ID = @iSubjectID AND Is_Active = 1;
END
