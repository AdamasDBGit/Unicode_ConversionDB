-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>

-- exec [dbo].[usp_ERP_RoutineSubjectTeacherAllocationAddEdit] 250, 1, 1, 1
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_RoutineSubjectTeacherAllocationAddEdit]
	-- Add the parameters for the stored procedure here
	(
		@selectedClassStructureDetailID INT = NULL,
		@FacultyMasterID INT = NULL,
		@SubjectID INT = NULL,
		@ClassType NVARCHAR(MAX) = NULL,
		@CreatedBy INT = NULL
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @subjectGroup int = null
	DECLARE @StudentRoutineClass INT = null

	select @subjectGroup=SubjectGroupID from T_Subject_Master where I_Subject_ID= @SubjectID

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM T_ERP_Student_Class_Routine WHERE I_Routine_Structure_Detail_ID = @selectedClassStructureDetailID
	and I_Subject_ID=@SubjectID)
	BEGIN

	select @StudentRoutineClass=I_Student_Class_Routine_ID from T_ERP_Student_Class_Routine WHERE I_Routine_Structure_Detail_ID = @selectedClassStructureDetailID
	and I_Subject_ID=@SubjectID 

		IF EXISTS(select * from T_ERP_Teacher_Time_Plan where I_Student_Class_Routine_ID=@StudentRoutineClass)
		BEGIN
			SELECT 0 AS statusFlag, 'Invalid! The logbook has already been registered for this routine operations.' AS Message
		END
		ELSE
		BEGIN
			UPDATE T_ERP_Student_Class_Routine
			SET I_Faculty_Master_ID = @FacultyMasterID,
				I_Subject_ID = @SubjectID,
				S_Class_Type = @ClassType,
				I_CreatedBy = @CreatedBy,
				SubjectGroupID=@subjectGroup
			WHERE I_Routine_Structure_Detail_ID = @selectedClassStructureDetailID and  I_Subject_ID=@SubjectID;
			SELECT 1 AS statusFlag, 'Subject & Faculty updated successfully' AS Message
		END
	END
	ELSE
	BEGIN
		INSERT INTO T_ERP_Student_Class_Routine(I_Routine_Structure_Detail_ID, I_Faculty_Master_ID, I_Subject_ID, I_CreatedBy, Dt_CreatedAt, S_Class_Type,SubjectGroupID)
		VALUES(@selectedClassStructureDetailID, @FacultyMasterID, @SubjectID, @CreatedBy, GETDATE(), @ClassType,@subjectGroup);
		SELECT 1 AS statusFlag, 'Subject & Faculty added successfully' AS Message
	END
END

