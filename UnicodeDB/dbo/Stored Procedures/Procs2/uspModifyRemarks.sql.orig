-- =============================================
-- Author:		Sudipta Das
-- Create date: 04/04/2006
-- Description:	Update Remarks
-- =============================================

CREATE PROCEDURE [dbo].[uspModifyRemarks]
	
	@sRemarks varchar(500),
	@sStudentID varchar(500)
				
AS
BEGIN TRY


UPDATE T_Student_Transfer_Request SET
S_Remarks = @sRemarks
WHERE I_Student_Detail_ID=(SELECT I_Student_Detail_ID from T_Student_Detail 
WHERE S_Student_ID=@sStudentID)

END TRY



BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
