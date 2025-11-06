CREATE PROCEDURE [dbo].[uspGetStudentExtraViewCount]
	-- Add the parameters for the stored procedure here
	@iStudentId int,
	@BatchId INT 
AS 
BEGIN TRY
	SELECT I_Extra_View_Count FROM T_Student_Extra_View
	WHERE I_Student_Detail_ID = @iStudentId
	AND I_Batch_ID = @BatchId
	
END TRY
BEGIN CATCH
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
