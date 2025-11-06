/*******************************************************
Description : Get E-Project Manual Master Details for a center
Author	:     Sudipta Das
Date	:	  05/21/2007
*********************************************************/

CREATE PROCEDURE [dbo].[uspGetPaymentGatewayInfo] 
(
	@BrandID int ,
	@Mode int
)
AS

BEGIN TRY 
IF (@BrandID >0)
BEGIN
SELECT * from T_PaymentGateway_Info where I_Brand_ID = @BrandID and I_Status = 1 and I_IsLive = @Mode
END

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
