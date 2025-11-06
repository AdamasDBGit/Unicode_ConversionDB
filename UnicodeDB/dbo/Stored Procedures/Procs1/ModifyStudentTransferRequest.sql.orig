-- =============================================
-- Author:		Sudipta Das
-- Create date: 04/04/2006
-- Description:	Update Remarks and status
-- =============================================

CREATE PROCEDURE [dbo].[ModifyStudentTransferRequest]
	
	@sRemarks varchar(500),
	@iStudentID int,
	@iFlag int
				
 
AS
BEGIN TRY 

IF @iFlag=0
BEGIN
	UPDATE T_Student_Transfer_Request SET
	S_Remarks = @sRemarks
	WHERE I_Student_Detail_ID=@iStudentID
END

IF @iFlag=3
BEGIN
	UPDATE T_Student_Transfer_Request SET
	I_Status = @iFlag
	WHERE I_Student_Detail_ID=@iStudentID
END

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
