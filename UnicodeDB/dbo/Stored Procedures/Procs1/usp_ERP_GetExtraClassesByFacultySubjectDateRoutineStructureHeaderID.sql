-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec usp_ERP_GetExtraClassesByFacultySubjectDateRoutineStructureHeaderID 19, 2, '2024-01-05', 1
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetExtraClassesByFacultySubjectDateRoutineStructureHeaderID]
(
	@FacultyMasterID int = null,
	@SubjectID int = null,
	@Date date = null,
	@RoutineStructureHeaderID int = null
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	TESCRE.I_ClassRoutine_ExtraClass_ID AS ClassRoutineExtraClassID,
	CONCAT(TESCRE.T_From_Slot, ' - ', TESCRE.T_To_Slot) AS TimeRange,
	TFM.S_Faculty_Name AS FacultyName,
	TSM.S_Subject_Name AS SubjectName,
	TST.S_Subject_Type AS SubjectType,
	TESC.S_Subject_Component_Name AS SubjectComponentName
	FROM
	T_ERP_Student_Class_Routine_ExtraClass TESCRE
	INNER JOIN T_Faculty_Master TFM ON TFM.I_Faculty_Master_ID = TESCRE.R_I_Faculty_Master_ID
	INNER JOIN T_Subject_Master TSM ON TSM.I_Subject_ID = TESCRE.R_I_Subject_ID
	INNER JOIN T_ERP_Subject_Component TESC ON TESC.I_Subject_Component_ID = TESCRE.I_Subject_Component_ID
	INNER JOIN T_Subject_Type TST ON TST.I_Subject_Type_ID = TSM.I_Subject_Type
	WHERE 
	(TESCRE.R_I_Faculty_Master_ID = @FacultyMasterID OR @FacultyMasterID IS NULL) 
	AND (TESCRE.R_I_Subject_ID = @SubjectID OR @SubjectID IS NULL) 
	AND (TESCRE.Dt_Period_Dt = @Date OR @Date IS NULL) 
	AND (TESCRE.R_I_Routine_Structure_Header_ID = @RoutineStructureHeaderID OR @RoutineStructureHeaderID IS NULL) 
	AND TESCRE.Is_Active = 1
	GROUP BY
	TESCRE.I_ClassRoutine_ExtraClass_ID,
	TESCRE.T_From_Slot,
	TESCRE.T_To_Slot,
	TFM.S_Faculty_Name,
	TSM.S_Subject_Name,
	TST.S_Subject_Type,
	TESC.S_Subject_Component_Name
END
