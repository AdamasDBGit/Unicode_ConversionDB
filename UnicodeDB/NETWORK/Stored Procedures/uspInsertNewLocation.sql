-- ===============================================================
-- Author:		Santanu maity
-- Create date: 06/08/2007
-- Description:	insert/update/delete the Address Change table
-- ===============================================================

CREATE PROCEDURE [NETWORK].[uspInsertNewLocation] 

	@iCentreId int,
	@sCenterAddress1 VARCHAR(100),
	@sCenterAddress2 VARCHAR(100),
	@iCityID int,
	@iStateID int,
	@iCountryID int,
	@sPincode VARCHAR(10),
	@sTelephoneNo VARCHAR(20),
	@sEmailID VARCHAR(50),

	@sDeliveryAddress1 VARCHAR(100),
	@sDeliveryAddress2 VARCHAR(100),
	@iDeliveryCity INT,
	@iDeliveryState INT,
	@ideliveryCountry INT,
	@sDeliveryPin varchar(10),
	@sDeliveryTelephoneNo VARCHAR(20),
	@sDeliveryEmailID VARCHAR(50),
	@sReason VARCHAR(1000),
	@iStatus int,
	@sCreatedBy VARCHAR(20),
	@dCreatedOn DATETIME
		
AS
BEGIN TRY
	
	IF EXISTS(SELECT * FROM NETWORK.T_AddressChange_Request WHERE I_Centre_Id = @iCentreId)
		BEGIN
			UPDATE NETWORK.T_AddressChange_Request
				SET
						S_Center_Address1 = @sCenterAddress1,
						S_Center_Address2 = @sCenterAddress2,
						I_City_ID = @iCityID,
						I_State_ID = @iCityID,
						I_Country_ID = @iCountryID,
						S_Pin_Code = @sPincode,
						S_Telephone_No = @sTelephoneNo,
						S_Email_ID = @sEmailID,
						S_Delivery_Address1 = @sDeliveryAddress1,
						S_Delivery_Address2 = @sDeliveryAddress2,
						I_Delivery_City_ID = @iDeliveryCity,
						I_Delivery_State_ID = @iDeliveryState,
						I_Delivery_Country_ID = @ideliveryCountry,
						S_Delivery_Pin = @sDeliveryPin,
						S_Delivery_Telephone = @sDeliveryTelephoneNo,
						S_Delivery_Email = @sDeliveryEmailID,
						S_Reason = @sReason,
						I_Status = @iStatus,
						S_Upd_By = @sCreatedBy,
						Dt_Upd_On = @dCreatedOn
				WHERE 	
						I_Centre_Id = @iCentreId
		
		END
	ELSE
		BEGIN
			INSERT INTO NETWORK.T_AddressChange_Request
						(
						I_Centre_Id,
						S_Center_Address1,
						S_Center_Address2,
						I_City_ID,
						I_State_ID,
						I_Country_ID,
						S_Pin_Code,
						S_Telephone_No,
						S_Email_ID,
						S_Delivery_Address1,
						S_Delivery_Address2,
						I_Delivery_City_ID,
						I_Delivery_State_ID,
						I_Delivery_Country_ID,
						S_Delivery_Pin,
						S_Delivery_Telephone,
						S_Delivery_Email,
						S_Reason,
						I_Status,
						S_Crtd_By,
						Dt_Crtd_On
						)
			VALUES
						(
						@iCentreId,
						@sCenterAddress1,
						@sCenterAddress2,
						@iCityID,
						@iStateID,
						@iCountryID,
						@sPincode,
						@sTelephoneNo,
						@sEmailID,
						@sDeliveryAddress1,
						@sDeliveryAddress2,
						@iDeliveryCity,
						@iDeliveryState,
						@ideliveryCountry,
						@sDeliveryPin,
						@sDeliveryTelephoneNo,
						@sDeliveryEmailID,
						@sReason,
						@iStatus,
						@sCreatedBy,
						@dCreatedOn
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
