--**********************************
-- Created By: Debarshi Basu
-- Created Date : 20/7/2007
-- Gets all centers for the brands
--**********************************


CREATE PROCEDURE [dbo].[uspUpdateCenterFundTransferStatus] 
	@iCenterID INT,
	@dtStartDate DATETIME,
	@dtEndDate DATETIME,
	@bCenterFundTransfer BIT,
	@sCrtdBy varchar(20),
	@dtCrtdOn datetime,
	@iFlag INT
AS
BEGIN

	IF @iFlag = 1
		BEGIN
			INSERT INTO dbo.T_Center_Fund_Transfer
			(I_Center_ID,Dt_Period_Start,Dt_Period_End,B_Stop_Center_Fund_Transfer,I_Status,S_Crtd_By,Dt_Crtd_On)
			VALUES
			(@iCenterID,@dtStartDate,@dtEndDate,@bCenterFundTransfer,1,@sCrtdBy,@dtCrtdOn)
		END
	ELSE IF @iFlag = 2
		BEGIN
			UPDATE dbo.T_Center_Fund_Transfer
			SET B_Stop_Center_Fund_Transfer = @bCenterFundTransfer,
				Dt_Period_Start = @dtStartDate,
				Dt_Period_End = @dtEndDate,
				S_Upd_By = @sCrtdBy,
				Dt_Upd_On = @dtCrtdOn
			WHERE I_Center_ID = @iCenterID
				AND I_Status = 1
		END
	ELSE IF @iFlag = 3
		BEGIN
			UPDATE dbo.T_Center_Fund_Transfer
			SET I_Status = 0,
				S_Upd_By = @sCrtdBy,
				Dt_Upd_On = @dtCrtdOn
			WHERE I_Center_ID = @iCenterID
				AND I_Status = 1
		END

END
