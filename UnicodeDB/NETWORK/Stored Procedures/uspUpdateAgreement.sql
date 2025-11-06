-- =============================================
-- Author:		Joydeep Chakraborty
-- Create date: 31/05/2007
-- Description:	insert/update/delete the agreement table
-- =============================================
CREATE PROCEDURE [NETWORK].[uspUpdateAgreement] 

	@iAgreementID int,
	@iBrandID int,
	@iCityID int = null,
	@iAgreementTemplateID int = null,
	@iStateID int = null,
	@iCountryID int = null,
	@iBPID int = null,
	@sCompanyName VARCHAR(100) = null,
	@sBPEmail	VARCHAR(50) = null,
	@sCompanyAddress1 VARCHAR(100) = null,
	@sCompanyAddress2 VARCHAR(100) = null,
	@sPinNo VARCHAR(10) = null,
	@sPhoneNo VARCHAR(50) = null,
	@sAgreementCode VARCHAR(50) = null,
	@dAgreementDate DATETIME = null,
	@dEffectiveAgreementDate DATETIME = null,
	@sTerritory	VARCHAR(50) = null,
	@iBPUserID	int = null,
	@iCurrencyID int = null,
	@dExpiryDate DATETIME = null,
	@sAuthorisedCourses VARCHAR(200) = null,
	@sReason VARCHAR(1000) = null,
	@sFirmRegistrationNumber VARCHAR(20) = null,
	@sBusinessJurisdiction VARCHAR(100) = null,
	@sAuthorisedSignatories VARCHAR(100) = null,
	@iSignatoriesAge INT = null,
	@sSigAddress1 VARCHAR(100) = null,
	@sSigAddress2 VARCHAR(100) = null,
	@iSigCity INT = null,
	@iSigState INT = null,
	@iSigCountry INT = null,
	@sSigPin varchar(10) = null,
	@sSigPhoneNo varchar(50)= null,
	@dtFranklingDate datetime= null,
	@nAmount numeric(18,2)= null,
	@nRenewalAmt numeric(18,2)= null,
	@sConstitution varchar(100)= null,
	@sPlace varchar(100)= null,
	@sPlan varchar(100)= null,
	@DocumentID	int = null,
	@sUpdatedBy VARCHAR(20),
	@dUpdatedOn DATETIME,
	@iStatus int,	
	@iFlag INT
AS
BEGIN TRY

	SET NOCOUNT OFF
--INSERT INTO AUDIT TABLE FIRST
IF @iAgreementID is not null
BEGIN
	INSERT INTO NETWORK.T_Agreement_Audit
	SELECT * FROM NETWORK.T_Agreement_Details WHERE 
				I_Agreement_ID	= @iAgreementID
END
--END OF AUDIT INSERT
	IF(@iFlag=1)--insert
		BEGIN
			INSERT INTO NETWORK.T_Agreement_Details
						(
						I_Brand_ID,
						I_City_ID,
						I_Agreement_Template_ID,
						I_State_ID,
						I_Country_ID,
						I_BP_ID,
						I_Currency_ID,
						S_Company_Name,
						S_BP_Email,
						S_Company_Address1,
						S_Company_Address2,
						S_Pin_No,
						S_Phone_Number,
						S_Agreement_Code,
						Dt_Agreement_date,
						Dt_Effective_Agreement_Date,
						S_Territory,
						I_BP_User_ID,
						Dt_Expiry_Date,
						S_Authorised_Courses,
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
						Dt_Frankling_Date,
						N_Amount,
						N_Renewal_Amount,
						S_Constitution,
						S_Place,
						S_Plan,
						I_Document_ID,
						S_Crtd_By,
						Dt_Crtd_On,
						I_Status
						)
			VALUES
						(
						@iBrandID,
						@iCityID,
						@iAgreementTemplateID,
						@iStateID,
						@iCountryID,
						@iBPID,
						@iCurrencyID,
						@sCompanyName,
						@sBPEmail,
						@sCompanyAddress1,
						@sCompanyAddress2,
						@sPinNo,
						@sPhoneNo,
						@sAgreementCode,
						@dAgreementDate,
						@dEffectiveAgreementDate,
						@sTerritory,
						@iBPUserID,
						@dExpiryDate,
						@sAuthorisedCourses,
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
						@dtFranklingDate,
						@nAmount,
						@nRenewalAmt,
						@sConstitution,
						@sPlace,
						@sPlan,
						@DocumentID,
						@sUpdatedBy,
						@dUpdatedOn,
						@iStatus
						)
			SELECT @iAgreementID=SCOPE_IDENTITY()--GET THE LAST INSERTED ID

		END
	IF(@iFlag=2)--update
		BEGIN
			UPDATE NETWORK.T_Agreement_Details
			SET I_Brand_ID=@iBrandID,
				I_City_ID=@iCityID,
				I_Agreement_Template_ID=@iAgreementTemplateID,
				I_State_ID=@iStateID,
				I_Country_ID=@iCountryID,
				I_BP_ID=@iBPID,
				I_Currency_ID=@iCurrencyID,
				S_Company_Name=@sCompanyName,
				S_BP_Email=@sBPEmail,
				S_Company_Address1=@sCompanyAddress1,
				S_Company_Address2=ISNULL(@sCompanyAddress2,S_Company_Address2),
				S_Pin_No=@sPinNo,
				S_Phone_Number=@sPhoneNo,
				S_Agreement_Code=@sAgreementCode,
				Dt_Agreement_date=@dAgreementDate,
				Dt_Effective_Agreement_Date=@dEffectiveAgreementDate,
				S_Territory=@sTerritory,
				--I_BP_User_ID=@iBPUserID,
				Dt_Expiry_Date=@dExpiryDate,
				S_Authorised_Courses=@sAuthorisedCourses,
				S_Reason=@sReason,
				S_Firm_Registration_No=@sFirmRegistrationNumber,
				S_Business_Jurisdiction=@sBusinessJurisdiction,
				S_Authorised_Signatories=@sAuthorisedSignatories,
				I_Signatories_Age = @iSignatoriesAge,
				S_Signatories_Address1 = @sSigAddress1,
				S_Signatories_Address2 = ISNULL(@sSigAddress2,S_Signatories_Address2),
				S_Signatories_City = @iSigCity,
				S_Signatories_State = @iSigState,
				S_Signatories_Country =	@iSigCountry,
				S_Signatories_Pin = @sSigPin,
				S_Signatories_Phone_Number = @sSigPhoneNo,
				Dt_Frankling_Date = @dtFranklingDate,
				N_Amount = @nAmount,
				N_Renewal_Amount = @nRenewalAmt,
				S_Constitution = @sConstitution,
				S_Place = @sPlace,
				S_Plan = @sPlan,
				I_Document_ID=@DocumentID,
				S_Upd_By=@sUpdatedBy,
				Dt_Upd_On=@dUpdatedOn,
				I_Status=@iStatus
			WHERE I_Agreement_ID=@iAgreementID
		END

	IF(@iFlag=3)--delete
		BEGIN
			UPDATE NETWORK.T_Agreement_Details
			SET S_Upd_By=@sUpdatedBy,
				Dt_Upd_On=@dUpdatedOn,
				I_Status=@iStatus
		END
	
	SELECT @iAgreementID AS AgreementID
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
