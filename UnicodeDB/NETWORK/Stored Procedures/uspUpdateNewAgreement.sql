-- ===============================================================
-- Author:		Santanu Maity
-- Create date: 31/07/2007
-- Description:	update status ownership transfer table
-- ===============================================================
CREATE PROCEDURE [NETWORK].[uspUpdateNewAgreement]
	
	@iCentreId INT,
	@sUpdatedBy VARCHAR(20),
	@dUpdatedOn DATETIME,
	@iStatus INT,
	@sRemarks VARCHAR(1000)=NULL,	
	@iFlag INT
AS

DECLARE @iAgreementId INT


BEGIN TRY

--INSERT INTO AUDIT TABLE FIRST
	INSERT INTO NETWORK.T_Ownership_Transfer_Audit
	SELECT * FROM NETWORK.T_Ownership_Transfer_Request WHERE I_Centre_Id = @iCentreId

--END OF AUDIT INSERT
--Update status
	UPDATE NETWORK.T_Ownership_Transfer_Request 
	SET I_Status = @iStatus,
	S_Remarks = @sRemarks,
	S_Upd_By = @sUpdatedBy,
	Dt_Upd_On = @dUpdatedOn
	WHERE I_Centre_Id = @iCentreId

	IF @iFlag = 5
	BEGIN
		
		Select @iAgreementId = I_Agreement_ID FROM NETWORK.T_Agreement_Center  
								WHERE I_Centre_Id = @iCentreId

		--INSERT INTO NETWORK.T_Agreement_Audit TABLE
		INSERT INTO NETWORK.T_Agreement_Audit
		SELECT * FROM NETWORK.T_Agreement_Details 
		WHERE I_Agreement_ID = @iAgreementId 
		
		
		--Update NETWORK.T_Agreement_Details

		UPDATE NETWORK.T_Agreement_Details
		SET 
			NETWORK.T_Agreement_Details.I_City_ID = NETWORK.T_Ownership_Transfer_Request.I_City_ID,
			NETWORK.T_Agreement_Details.I_State_ID = NETWORK.T_Ownership_Transfer_Request.I_State_ID,
			NETWORK.T_Agreement_Details.I_Country_ID = NETWORK.T_Ownership_Transfer_Request.I_Country_ID,
			NETWORK.T_Agreement_Details.I_BP_ID = NETWORK.T_Ownership_Transfer_Request.I_BP_Type,
			NETWORK.T_Agreement_Details.S_Company_Name = NETWORK.T_Ownership_Transfer_Request.S_Company_Name,
			NETWORK.T_Agreement_Details.S_BP_Email = NETWORK.T_Ownership_Transfer_Request.S_BP_Email,
			NETWORK.T_Agreement_Details.S_Company_Address1 = NETWORK.T_Ownership_Transfer_Request.S_Company_Address1,
			NETWORK.T_Agreement_Details.S_Company_Address2 = NETWORK.T_Ownership_Transfer_Request.S_Company_Address2,
			NETWORK.T_Agreement_Details.S_Pin_No = NETWORK.T_Ownership_Transfer_Request.S_Pin_No,
			NETWORK.T_Agreement_Details.Dt_Agreement_date = NETWORK.T_Ownership_Transfer_Request.Dt_Agreement_Date,
			NETWORK.T_Agreement_Details.Dt_Effective_Agreement_Date = NETWORK.T_Ownership_Transfer_Request.Dt_Effective_Agreement_Date,
			NETWORK.T_Agreement_Details.S_Territory = NETWORK.T_Ownership_Transfer_Request.S_Territory,
			NETWORK.T_Agreement_Details.I_BP_User_ID = NETWORK.T_Ownership_Transfer_Request.I_BP_ID,
			NETWORK.T_Agreement_Details.Dt_Expiry_Date = NETWORK.T_Ownership_Transfer_Request.Dt_Expiry_Date,
			NETWORK.T_Agreement_Details.S_Firm_Registration_No = NETWORK.T_Ownership_Transfer_Request.S_Firm_Registration_No,
			NETWORK.T_Agreement_Details.S_Business_Jurisdiction = NETWORK.T_Ownership_Transfer_Request.S_Business_Jurisdiction,
			NETWORK.T_Agreement_Details.S_Authorised_Signatories = NETWORK.T_Ownership_Transfer_Request.S_Authorised_Signatories ,
			NETWORK.T_Agreement_Details.I_Signatories_Age = NETWORK.T_Ownership_Transfer_Request.I_Signatories_Age,
			NETWORK.T_Agreement_Details.S_Signatories_Address1 = NETWORK.T_Ownership_Transfer_Request.S_Signatories_Address1,
			NETWORK.T_Agreement_Details.S_Signatories_Address2 = NETWORK.T_Ownership_Transfer_Request.S_Signatories_Address2,
			NETWORK.T_Agreement_Details.S_Signatories_City = NETWORK.T_Ownership_Transfer_Request.S_Signatories_City,
			NETWORK.T_Agreement_Details.S_Signatories_State = NETWORK.T_Ownership_Transfer_Request.S_Signatories_State,
			NETWORK.T_Agreement_Details.S_Signatories_Country = NETWORK.T_Ownership_Transfer_Request.S_Signatories_Country,
			NETWORK.T_Agreement_Details.S_Signatories_Pin = NETWORK.T_Ownership_Transfer_Request.S_Signatories_Pin
		from NETWORK.T_Ownership_Transfer_Request
			where NETWORK.T_Ownership_Transfer_Request.I_Centre_Id = @iCentreId
			AND NETWORK.T_Agreement_Details.I_Agreement_ID = @iAgreementId

	END 
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
