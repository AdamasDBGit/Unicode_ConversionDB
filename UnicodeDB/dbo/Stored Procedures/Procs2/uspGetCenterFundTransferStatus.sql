--**********************************
-- Created By: Debarshi Basu
-- Created Date : 20/7/2007
-- Gets all centers for the brands
--**********************************


CREATE PROCEDURE [dbo].[uspGetCenterFundTransferStatus] 
	@iCenterID INT

AS
BEGIN
	SELECT I_Center_ID,Dt_Period_Start,Dt_Period_End,B_Stop_Center_Fund_Transfer
	FROM dbo.T_Center_Fund_Transfer WITH(NOLOCK)
	WHERE I_Center_ID = @iCenterID
		AND I_Status = 1

END
