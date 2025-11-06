-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_Get_PaymentGateWay_Info] 
	-- Add the parameters for the stored procedure here
	@iBrandID INT,
	@Mode INT=NULL
AS
BEGIN TRY 
IF (@iBrandID >0)
BEGIN
SELECT 
EBPM.I_ERP_Brand_PaymentGateway_Map_id as PaymentGatewayBrandID,
ETPI.S_PaymentGateway_Name as PaymentGatewayName,
EBPM.I_Brand_ID BrandId,
EBPM.S_TransactionUrl TransactionUrl
,EBPM.S_MerchantId MerchantId
,CASE WHEN ISNULL(EBPM.I_IsLive,'false') ='true' THEN EBPM.S_Live_salt
WHEN ISNULL(EBPM.I_IsLive,'false') ='false' THEN EBPM.S_Test_Salt
ELSE 'NA' END Salt,
CASE WHEN ISNULL(EBPM.I_IsLive,'false') ='true' THEN EBPM.S_Live_keySecret
WHEN ISNULL(EBPM.I_IsLive,'false') ='false' THEN EBPM.S_Test_KeySecret
ELSE 'NA' END keySecret,
EBPM.I_Payment_Mode as SMSPaymentMode
,ISNULL(EBPM.I_IsLive,'false') IsLive
,BM.S_Client_Name as ClientName
from 
T_ERP_PaymentGateway_Info as ETPI 
inner join
T_ERP_Brand_PaymentGateway_Map as EBPM on ETPI.I_PaymentGateway_Id=EBPM.I_PaymentGateway_Id
inner join
T_Brand_Master as BM on BM.I_Brand_ID=EBPM.I_Brand_ID
where ETPI.I_Status = 1 
and EBPM.I_Brand_ID=@iBrandID and EBPM.Is_Active=1 and ETPI.I_Status=1 and BM.I_Status=1

END

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
