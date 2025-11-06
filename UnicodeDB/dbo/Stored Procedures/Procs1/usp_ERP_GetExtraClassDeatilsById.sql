-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec usp_ERP_GetExtraClassDeatilsById 1
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetExtraClassDeatilsById]
(
	@ClassRoutineExtraClassID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	I_ClassRoutine_ExtraClass_ID AS ClassRoutineExtraClassID,
	R_I_Faculty_Master_ID AS FacultyID,
	R_I_Subject_ID AS SubjectID,
	T_From_Slot AS StartTime,
	T_To_Slot AS EndTime,
	Dt_Period_Dt AS Date,
	I_Subject_Component_ID AS ClassTypeID
	FROM T_ERP_Student_Class_Routine_ExtraClass
	WHERE I_ClassRoutine_ExtraClass_ID = @ClassRoutineExtraClassID
END
