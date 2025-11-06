CREATE PROCEDURE [dbo].[uspSaveStudentExtraView]
(
		@sStudentIDs			VARCHAR(MAX),
		@iBatchID 		        INT,
		@iExtraView			        INT			
)

AS
BEGIN TRY
	UPDATE T_Student_Extra_View SET I_Extra_View_Count = @iExtraView
	WHERE I_Batch_ID = @iBatchID AND I_Student_Detail_ID IN (SELECT [Val] FROM fnString2Rows(@sStudentIDs,','))
	
	INSERT INTO T_Student_Extra_View
	SELECT [Val], @iBatchID, @iExtraView FROM fnString2Rows(@sStudentIDs,',')
	WHERE [Val] NOT IN (SELECT I_Student_Detail_ID FROM T_Student_Extra_View WHERE I_Batch_ID = @iBatchID)
	
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
