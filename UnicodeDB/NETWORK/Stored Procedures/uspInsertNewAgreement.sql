-- ===============================================================
-- Author:		Swagatam Sarkar
-- Create date: 03/07/2007
-- Description:	insert/update/delete the ownership transfer table
-- ===============================================================
CREATE PROCEDURE [NETWORK].[uspInsertNewAgreement] 

	@iCentreId int,
	@iCityID int,
	@iStateID int,
	@iCountryID int,
	@iBPID int,
	@sCompanyName VARCHAR(100),
	@sBPEmail	VARCHAR(50),
	@sCompanyAddress1 VARCHAR(100),
	@sCompanyAddress2 VARCHAR(100),
	@sPinNo VARCHAR(10),
	@sPhoneNo VARCHAR(50),
	@dAgreementDate DATETIME,
	@dEffectiveAgreementDate DATETIME,
	@sTerritory	VARCHAR(50),
	@dExpiryDate DATETIME,
	@sReason VARCHAR(1000),
	@sFirmRegistrationNumber VARCHAR(20),
	@sBusinessJurisdiction VARCHAR(100),
	@sAuthorisedSignatories VARCHAR(100),
	@iSignatoriesAge INT,
	@sSigAddress1 VARCHAR(100),
	@sSigAddress2 VARCHAR(100),
	@iSigCity INT,
	@iSigState INT,
	@iSigCountry INT,
	@sSigPin varchar(10),
	@sSigPhoneNo VARCHAR(50),
	@sCreatedBy VARCHAR(20),
	@dCreatedOn DATETIME,
	@iStatus int	
AS
BEGIN TRY
	
	IF EXISTS(SELECT * FROM NETWORK.T_Ownership_Transfer_Request WHERE I_Centre_Id = @iCentreId)
		BEGIN
			UPDATE NETWORK.T_Ownership_Transfer_Request
				SET
						I_City_ID = @iCityID,
						I_State_ID = @iCityID,
						I_Country_ID = @iCountryID,
						I_BP_ID = @iBPID,
						S_Company_Name = @sCompanyName,
						S_BP_Email = @sBPEmail,
						S_Company_Address1 = @sCompanyAddress1,
						S_Company_Address2 = @sCompanyAddress2,
						S_Pin_No = @sPinNo,
						S_Phone_Number = @sPhoneNo,
						Dt_Agreement_date = @dAgreementDate,
						Dt_Effective_Agreement_Date = @dEffectiveAgreementDate,
						S_Territory = @sTerritory,
						Dt_Expiry_Date = @dExpiryDate,
						S_Reason = @sReason,
						S_Firm_Registration_No = @sFirmRegistrationNumber,
						S_Business_Jurisdiction = @sBusinessJurisdiction,
						S_Authorised_Signatories = @sAuthorisedSignatories,
						I_Signatories_Age = @iSignatoriesAge,
						S_Signatories_Address1 = @sSigAddress1,
						S_Signatories_Address2 = @sSigAddress2,
						S_Signatories_City = @iSigCity,
						S_Signatories_State = @iSigState,
						S_Signatories_Country = @iSigCountry,
						S_Signatories_Pin = @sSigPin,
						S_Signatories_Phone_Number = @sSigPhoneNo,
						S_Crtd_By = @sCreatedBy,
						Dt_Crtd_On = @dCreatedOn,
						I_Status = @iStatus
				WHERE 	
						I_Centre_Id = @iCentreId
		
		END
	ELSE
		BEGIN
			INSERT INTO NETWORK.T_Ownership_Transfer_Request
						(
						I_Centre_Id,
						I_City_ID,
						I_State_ID,
						I_Country_ID,
						I_BP_ID,
						S_Company_Name,
						S_BP_Email,
						S_Company_Address1,
						S_Company_Address2,
						S_Pin_No,
						S_Phone_Number,
						Dt_Agreement_date,
						Dt_Effective_Agreement_Date,
						S_Territory,
						Dt_Expiry_Date,
						S_Reason,
						S_Firm_Registration_No,
						S_Business_Jurisdiction,
						S_Authorised_Signatories,
						I_Signatories_Age,
						S_Signatories_Address1,
						S_Signatories_Address2,
						S_Signatories_City,
						S_Signatories_State,
						S_Signatories_Country,
						S_Signatories_Pin,
						S_Signatories_Phone_Number,
						S_Crtd_By,
						Dt_Crtd_On,
						I_Status
						)
			VALUES
						(
						@iCentreId,
						@iCityID,
						@iStateID,
						@iCountryID,
						@iBPID,
						@sCompanyName,
						@sBPEmail,
						@sCompanyAddress1,
						@sCompanyAddress2,
						@sPinNo,
						@sPhoneNo,
						@dAgreementDate,
						@dEffectiveAgreementDate,
						@sTerritory,
						@dExpiryDate,
						@sReason,
						@sFirmRegistrationNumber,
						@sBusinessJurisdiction,
						@sAuthorisedSignatories,
						@iSignatoriesAge,
						@sSigAddress1,
						@sSigAddress2,
						@iSigCity,
						@iSigState,
						@iSigCountry,
						@sSigPin,
						@sSigPhoneNo,
						@sCreatedBy,
						@dCreatedOn,
						@iStatus
						)

		END

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
