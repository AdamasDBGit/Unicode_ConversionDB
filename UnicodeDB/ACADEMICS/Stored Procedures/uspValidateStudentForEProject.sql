CREATE PROCEDURE [ACADEMICS].[uspValidateStudentForEProject] 
(
	@iStudentDetailID int,
	@iCourseID int,
	@iTermID int,
	@iModuleID int,
	@dDate datetime
)
AS
BEGIN TRY

	DECLARE @iFlag INT

	SET @iFlag = 0

	IF [ACADEMICS].[fnGetStudentEligibilityForEProject](@iStudentDetailID, @iCourseID, @iTermID, @iModuleID, @dDate) = 'Y'
	BEGIN
		SET @iFlag = 1
	END	

	SELECT @iFlag Flag
	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
