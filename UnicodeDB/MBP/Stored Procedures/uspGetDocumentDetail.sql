-- =============================================
-- Author:		Shankha Roy
-- Create date: 19/07/2007
-- Description:	This sp return the detail of upload document
-- =============================================
CREATE PROCEDURE [MBP].[uspGetDocumentDetail]
(  
@iDocumentID INT = null		
)
AS
	BEGIN TRY  
	
	SELECT 
	ISNULL(I_Document_ID,0) AS I_Document_ID,
	ISNULL(S_Document_Name,'')AS S_Document_Name,
	ISNULL(S_Document_Type,'') AS S_Document_Type,
	ISNULL(S_Document_Path,'') AS S_Document_Path,
	ISNULL(S_Document_URL,'') AS S_Document_URL,
	Dt_Crtd_On
	FROM dbo.T_Upload_Document
	WHERE I_Document_ID= COALESCE(@iDocumentID,I_Document_ID)

	END TRY
			BEGIN CATCH
			--Error occurred:  
				DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
				SELECT	@ErrMsg = ERROR_MESSAGE(),
						@ErrSeverity = ERROR_SEVERITY()
				RAISERROR(@ErrMsg, @ErrSeverity, 1)
			END CATCH
