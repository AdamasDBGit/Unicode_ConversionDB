CREATE PROCEDURE [dbo].[uspValidateBookModification] 
(
	@iBookID int
)
AS
BEGIN TRY

	
	SELECT COUNT(A.I_Module_Book_ID) 
	FROM dbo.T_Module_Book_Map A
	INNER JOIN dbo.T_Book_Master B
	ON A.I_Book_ID = A.I_Book_ID
	INNER JOIN dbo.T_Module_Master C
	ON C.I_Module_ID = A.I_Module_ID
	WHERE A.I_Book_ID = @iBookID
	AND A.I_Status = 1
	AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To,GETDATE())
	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
