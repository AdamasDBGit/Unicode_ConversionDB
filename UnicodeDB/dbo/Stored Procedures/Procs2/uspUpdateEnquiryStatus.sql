CREATE PROCEDURE [dbo].[uspUpdateEnquiryStatus]
(
	@iEnquiryID INT,
	@iEnquiryStatus INT	
)
AS

BEGIN TRY
	SET NOCOUNT ON;
			
		UPDATE T_Enquiry_Regn_Detail SET I_Enquiry_Status_Code = @iEnquiryStatus 
		WHERE I_Enquiry_Regn_ID = @iEnquiryID	
		
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
