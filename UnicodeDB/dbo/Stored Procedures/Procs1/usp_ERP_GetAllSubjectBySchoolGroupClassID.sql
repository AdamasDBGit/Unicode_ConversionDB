-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>

-- exec [dbo].[usp_ERP_GetAllSubjectBySchoolGroupClassID] 1, 13, null, 107
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetAllSubjectBySchoolGroupClassID] 
	-- Add the parameters for the stored procedure here
	(
		@SchoolGroupID INT = NULL,
		@ClassID int = null,
		@StreamID int = null,
		@BrandID int = null
	)
AS
BEGIN
	IF @StreamID IS NULL AND @BrandID IS NULL
	BEGIN
		select 
		I_Subject_ID AS SubjectID,
		ISNULL(S_Subject_Code,''),
		S_Subject_Name +' ('+ISNULL(S_Subject_Code,'')+')' AS SubjectName
		from [T_Subject_Master] TSM
		where TSM.I_School_Group_ID = @SchoolGroupID and TSM.I_Class_ID = @ClassID
	END
	ELSE
	BEGIN
		select 
		I_Subject_ID AS SubjectID,
		S_Subject_Name AS SubjectName,
		ISNULL(S_Subject_Code,''),
		S_Subject_Name +' ('+ISNULL(S_Subject_Code,'')+')' AS SubjectName
		from [T_Subject_Master] TSM
		where TSM.I_School_Group_ID = @SchoolGroupID and TSM.I_Class_ID = @ClassID and (TSM.I_Stream_ID = @StreamID OR @StreamID IS NULL) and (I_Brand_ID = @BrandID OR @BrandID IS NULL)
	END
END
