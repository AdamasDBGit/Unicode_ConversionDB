CREATE PROCEDURE [dbo].[uspUpdateCenterforInvoice]
(
	@iInvoiceID INT,
	@iCentreId INT,
	@CreatedOn Datetime,
	@CreatedBy varchar(20)	
)

AS

BEGIN TRY
	SET NOCOUNT ON;
	
		UPDATE T_INVOICE_PARENT SET 
		I_Centre_Id = @iCentreId,
		Dt_Upd_On = @CreatedOn,
		S_Upd_By = @CreatedBy
		WHERE I_Invoice_Header_ID = @iInvoiceID		
		
END TRY


BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
