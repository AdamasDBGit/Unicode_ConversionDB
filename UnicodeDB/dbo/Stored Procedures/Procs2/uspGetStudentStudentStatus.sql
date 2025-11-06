CREATE PROCEDURE [dbo].[uspGetStudentStudentStatus]
	-- Add the parameters for the stored procedure here
	@iStudentId INT,
	@iCenterId INT 
AS 
BEGIN TRY
  
  DECLARE @sStatus VARCHAR(100)
  
	SELECT @sStatus = dbo.ufnGetStudentStatus(@iCenterId,@iStudentId)
	
	SELECT @sStatus
	--PRINT (@sStatus)
	
END TRY
BEGIN CATCH
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
