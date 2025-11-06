CREATE PROCEDURE [ACADEMICS].[uspValidateStudentForEProjectSpec] 
(
	@iStudentDetailID int,
	@iEProjectGroupID int
)
AS
BEGIN TRY

	DECLARE @iFlag INT

	SET @iFlag = 0

	IF EXISTS (	SELECT I_Center_E_Proj_ID
			FROM ACADEMICS.T_Center_E_Project_Manual
			WHERE I_Student_Detail_ID = @iStudentDetailID
			AND I_E_Project_Group_ID = @iEProjectGroupID
			AND I_Status NOT IN (2,3))
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
