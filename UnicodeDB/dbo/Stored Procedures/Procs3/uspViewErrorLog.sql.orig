-- =============================================
-- Author:		<Swagatam>
-- Create date: <09-May-2008>
-- Description:	<View Error Log>
-- =============================================
CREATE PROCEDURE [dbo].[uspViewErrorLog] 
-- Add the parameters for the stored procedure here
	@sErrorCode varchar(50) = NULL
 
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	
		SELECT * FROM dbo.T_Error_Log
			WHERE S_Error_Number = @sErrorCode
	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
