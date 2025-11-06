-- =============================================
-- Author:		Santanu maity
-- Create date: 01/08/2007
-- Description:	update the agreement table
-- =============================================

CREATE PROCEDURE [NETWORK].[uspUpdateOwnershipTransferAgreement] 
(
	@iAgreementID int,
	@iBrandID int,
	@iCityID int,
	@iAgreementTemplateID int,
	@iStateID int,
	@iCountryID int,
	@iBPID int,
	@sCompanyName VARCHAR(100),
	@sBPEmail	VARCHAR(50),
	@sCompanyAddress1 VARCHAR(100),
	@sCompanyAddress2 VARCHAR(100)=null,
	@sPinNo VARCHAR(10),
	@sPhoneNo VARCHAR(50),
	@sAgreementCode VARCHAR(50),
	@dAgreementDate DATETIME,
	@dEffectiveAgreementDate DATETIME,
	@sTerritory	VARCHAR(50),
	@iBPUserID	int,
	@dExpiryDate DATETIME,
	@sAuthorisedCourses VARCHAR(200),
	@sReason VARCHAR(1000) = null,
	@sFirmRegistrationNumber VARCHAR(20),
	@sBusinessJurisdiction VARCHAR(100),
	@sAuthorisedSignatories VARCHAR(100),
	@iSignatoriesAge INT,
	@sSigAddress1 VARCHAR(100),
	@sSigAddress2 VARCHAR(100)=null,
	@iSigCity INT,
	@iSigState INT,
	@iSigCountry INT,
	@sSigPin varchar(10),
	@sSigPhoneNo VARCHAR(50),
	@dtFranklingDate datetime,
	@nAmount numeric(18,2),
	@nRenewalAmt numeric(18,2),
	@sConstitution varchar(100),
	@sPlace varchar(100),
	@sPlan varchar(100),
	@DocumentID	int = null,
	@sUpdatedBy VARCHAR(20),
	@dUpdatedOn DATETIME,
	@iStatus int,	
	@iFlag INT
)
AS
BEGIN TRY
SET NOCOUNT OFF

--INSERT INTO AUDIT TABLE FIRST
IF @iAgreementID is not null
BEGIN
	INSERT INTO NETWORK.T_Agreement_Audit
	SELECT * FROM NETWORK.T_Agreement_Details WHERE 
				I_Agreement_ID	= @iAgreementID

--END OF AUDIT INSERT
			UPDATE NETWORK.T_Agreement_Details
			SET I_Brand_ID=@iBrandID,
				I_City_ID=@iCityID,
				I_Agreement_Template_ID=@iAgreementTemplateID,
				I_State_ID=@iStateID,
				I_Country_ID=@iCountryID,
				I_BP_ID=@iBPID,
				S_Company_Name=@sCompanyName,
				S_BP_Email=@sBPEmail,
				S_Company_Address1=@sCompanyAddress1,
				S_Company_Address2=@sCompanyAddress2,
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
				S_Signatories_Address2 = @sSigAddress2,
				S_Signatories_City = @iSigCity,
				S_Signatories_State = @iSigState,
				S_Signatories_Country =	@iSigCountry,
				S_Signatories_Pin = @sSigPin,
				S_Signatories_Phone_Number=@sSigPhoneNo,
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
	SELECT @iAgreementID AS AgreementID
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
