--**********************************
-- Created By: Debarshi Basu
-- Created Date : 20/7/2007
-- UPDATES THE FEE SHARING For Receipt Types
--**********************************


CREATE PROCEDURE [dbo].[uspUpdateFeeSharingReceipts] 
	@iIndex Int = NULL,
	@iBrandID INT = NULL,
	@iCountryID INT = NULL,
	@iCenterID INT = NULL,
	@iReceiptType INT = NULL,
	@nCompanyShare NUMERIC(8,4),
	@dtStartDate DATETIME,
	@dtEndDate DATETIME,
	@sCrtdBy varchar(20),
	@dtCrtdOn datetime,
	@iFlag INT
AS
BEGIN

	IF @iFlag = 1
		BEGIN
			INSERT INTO dbo.T_Fee_Sharing_OnAccount_Audit
			SELECT I_Fee_Sharing_OnAccount_ID,I_Brand_ID,I_Country_ID,I_Center_ID,I_Receipt_Type,
				N_Company_Share,Dt_Period_Start,Dt_Period_End,
				I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On
			FROM dbo.T_Fee_Sharing_OnAccount
			WHERE ISNULL(I_Country_ID,0) = ISNULL(@iCountryID,0)
				AND	  ISNULL(I_Center_ID,0) = ISNULL(@iCenterID,0)
				AND   ISNULL(I_Receipt_Type,0) = ISNULL(@iReceiptType,0)
				AND   ISNULL(I_Brand_ID,0) = ISNULL(@iBrandID,0)


			INSERT INTO dbo.T_Fee_Sharing_OnAccount
			(I_Country_ID,I_Brand_ID,I_Center_ID,I_Receipt_Type,
				N_Company_Share,Dt_Period_Start,Dt_Period_End,I_Status,S_Crtd_By,Dt_Crtd_On)
			VALUES
			(@iCountryID,@iBrandID,@iCenterID,@iReceiptType,@nCompanyShare,
				@dtStartDate,@dtEndDate,1,@sCrtdBy,@dtCrtdOn)
		END
	ELSE IF @iFlag = 2
		BEGIN
			INSERT INTO dbo.T_Fee_Sharing_OnAccount_Audit
			SELECT I_Fee_Sharing_OnAccount_ID,I_Brand_ID,I_Country_ID,I_Center_ID,I_Receipt_Type,
				N_Company_Share,Dt_Period_Start,Dt_Period_End,
				I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On
			FROM dbo.T_Fee_Sharing_OnAccount
			WHERE ISNULL(I_Country_ID,0) = ISNULL(@iCountryID,0)
				AND	  ISNULL(I_Center_ID,0) = ISNULL(@iCenterID,0)
				AND   ISNULL(I_Receipt_Type,0) = ISNULL(@iReceiptType,0)
				AND   ISNULL(I_Brand_ID,0) = ISNULL(@iBrandID,0)


			UPDATE dbo.T_Fee_Sharing_OnAccount
				SET N_Company_Share = @nCompanyShare,
					Dt_Period_Start = @dtStartDate,
					Dt_Period_End = @dtEndDate,
					S_Upd_By = @sCrtdBy,
					Dt_Upd_On = @dtCrtdOn
			WHERE ISNULL(I_Country_ID,0) = ISNULL(@iCountryID,0)
				AND	  ISNULL(I_Center_ID,0) = ISNULL(@iCenterID,0)
				AND   ISNULL(I_Receipt_Type,0) = ISNULL(@iReceiptType,0)
				AND   Dt_Period_End > GETDATE()
				AND I_Fee_Sharing_OnAccount_ID = ISNULL(@iIndex,I_Fee_Sharing_OnAccount_ID)
				AND   ISNULL(I_Brand_ID,0) = ISNULL(@iBrandID,0)
		END
	ELSE IF @iFlag = 3
		BEGIN
			INSERT INTO dbo.T_Fee_Sharing_OnAccount_Audit
			SELECT I_Fee_Sharing_OnAccount_ID,I_Brand_ID,I_Country_ID,I_Center_ID,I_Receipt_Type,
				N_Company_Share,Dt_Period_Start,Dt_Period_End,
				I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On
			FROM dbo.T_Fee_Sharing_OnAccount
			WHERE ISNULL(I_Country_ID,0) = ISNULL(@iCountryID,0)
				AND	  ISNULL(I_Center_ID,0) = ISNULL(@iCenterID,0)
				AND   ISNULL(I_Receipt_Type,0) = ISNULL(@iReceiptType,0)
				AND   ISNULL(I_Brand_ID,0) = ISNULL(@iBrandID,0)

			DELETE FROM dbo.T_Fee_Sharing_OnAccount
			WHERE ISNULL(I_Country_ID,0) = ISNULL(@iCountryID,0)
				AND	  ISNULL(I_Center_ID,0) = ISNULL(@iCenterID,0)
				AND   ISNULL(I_Receipt_Type,0) = ISNULL(@iReceiptType,0)
				AND   ISNULL(I_Brand_ID,0) = ISNULL(@iBrandID,0)

		END

END
