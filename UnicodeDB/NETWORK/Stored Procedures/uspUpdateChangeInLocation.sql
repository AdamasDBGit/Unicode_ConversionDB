-- ===============================================================
-- Author:		Santanu Maity
-- Create date: 31/07/2007
-- Description:	update status change in location table
-- ===============================================================

CREATE PROCEDURE [NETWORK].[uspUpdateChangeInLocation] 
	(
		@iCentreId INT,
		@sUpdatedBy VARCHAR(20),
		@dUpdatedOn DATETIME,
		@iStatus INT,
		@iFlag INT
	)
AS


BEGIN TRY

--INSERT INTO AUDIT TABLE FIRST
	INSERT INTO NETWORK.T_AddressChange_Audit
	SELECT * FROM NETWORK.T_AddressChange_Request WHERE I_Centre_Id = @iCentreId

--END OF AUDIT INSERT
--Update status
	UPDATE NETWORK.T_AddressChange_Request
	SET I_Status = @iStatus,
	S_Upd_By = @sUpdatedBy,
	Dt_Upd_On = @dUpdatedOn
	WHERE I_Centre_Id = @iCentreId

	IF @iStatus = 7
	BEGIN
		
		
		--Update NETWORK.T_Center_Address

		UPDATE NETWORK.T_Center_Address
		SET 
		NETWORK.T_Center_Address.S_Center_Address1 = NETWORK.T_AddressChange_Request.S_Center_Address1,
		NETWORK.T_Center_Address.S_Center_Address2 = NETWORK.T_AddressChange_Request.S_Center_Address2,
		NETWORK.T_Center_Address.I_City_ID =  NETWORK.T_AddressChange_Request.I_City_ID,
		NETWORK.T_Center_Address.I_State_ID = NETWORK.T_AddressChange_Request.I_State_ID,
		NETWORK.T_Center_Address.S_Pin_Code = NETWORK.T_AddressChange_Request.S_Pin_Code,
		NETWORK.T_Center_Address.I_Country_ID = NETWORK.T_AddressChange_Request.I_Country_ID,
		NETWORK.T_Center_Address.S_Telephone_No = NETWORK.T_AddressChange_Request.S_Telephone_No,
		NETWORK.T_Center_Address.S_Email_ID = NETWORK.T_AddressChange_Request.S_Email_ID,
		NETWORK.T_Center_Address.S_Delivery_Address1 = NETWORK.T_AddressChange_Request.S_Delivery_Address1,
		NETWORK.T_Center_Address.S_Delivery_Address2 = NETWORK.T_AddressChange_Request.S_Delivery_Address2,
		NETWORK.T_Center_Address.I_Delivery_City_ID = NETWORK.T_AddressChange_Request.I_Delivery_City_ID,
		NETWORK.T_Center_Address.I_Delivery_State_ID = NETWORK.T_AddressChange_Request.I_Delivery_State_ID,
		NETWORK.T_Center_Address.S_Delivery_Pin_No = NETWORK.T_AddressChange_Request.S_Delivery_Pin,	
		NETWORK.T_Center_Address.I_Delivery_Country_ID = NETWORK.T_AddressChange_Request.I_Delivery_Country_ID,
		NETWORK.T_Center_Address.S_Delivery_Phone_No = NETWORK.T_AddressChange_Request.S_Delivery_Telephone,
		NETWORK.T_Center_Address.S_Delivery_Email_ID = NETWORK.T_AddressChange_Request.S_Delivery_Email
			
		from NETWORK.T_AddressChange_Request
			where NETWORK.T_AddressChange_Request.I_Centre_Id = @iCentreId
			AND NETWORK.T_Center_Address.I_Centre_Id = NETWORK.T_AddressChange_Request.I_Centre_Id
			

	END 
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
