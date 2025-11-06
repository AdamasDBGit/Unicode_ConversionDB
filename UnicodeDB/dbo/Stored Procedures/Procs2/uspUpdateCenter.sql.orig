-- =============================================
-- Author:		Debarshi Basu
-- Create date: 22/03/2007
-- Description:	Creates, updates, deletes 
-- =============================================

CREATE PROCEDURE [dbo].[uspUpdateCenter]
	@iCenterID int,	
	@sCenterCode varchar(20) = null,
	@sCenterName varchar(100),
	@sShortName varchar(50),
	@iCategory int,
	@iRFFType int,
	@iIsOwnCenter int,
	@sServiceTaxRegdNo varchar(20),
	@sAddress1 varchar(100),
	@sAddress2 varchar(100),
	@iCityID int,
	@iStateID int,
	@iCountryID int,
	@sPinCode varchar(10),
	@sPhoneNumber varchar(20),
	@sEmail varchar(50),
	@sDelAddress1 varchar(100),
	@sDelAddress2 varchar(100),
	@iDelCityID int,
	@iDelStateID int,
	@iDelCountryID int,
	@sDelPinCode varchar(10),
	@sDelPhoneNumber varchar(20),
	@sDelEmail varchar(50),
	@iStartUpInPlace bit = null,
	@iLibraryInPlace bit = null,
	@sCreatedBy varchar(20),
	@dtCreatedDt Datetime,
	@iStatus int,
	@iFlag int
	
AS
BEGIN

--  for insert
	IF (@iFlag = 1)
		BEGIN
			INSERT INTO dbo.T_Centre_Master
			   (S_Center_Code,
				S_Center_Name,
				S_Center_Short_Name,
				I_Center_Category,
				I_RFF_Type,
				I_Is_OwnCenter,
				S_ServiceTax_Regd_Code,
				I_Country_ID,
				S_Crtd_By,
				Dt_Crtd_On,
				Dt_Valid_From,
				I_Status)
			VALUES
			(@sCenterCode,@sCenterName,@sShortName,@iCategory,
			@iRFFType,@iIsOwnCenter,@sServiceTaxRegdNo,
			@iCountryID,@sCreatedBy,@dtCreatedDt,@dtCreatedDt,@iStatus)

			SELECT @iCenterID=SCOPE_IDENTITY()

			INSERT INTO NETWORK.T_Center_Address
			   (I_Centre_Id,
				S_Center_Address1,
				S_Center_Address2,
				I_City_ID,
				I_State_ID,
				S_Pin_Code,
				I_Country_ID,
				S_Telephone_No,
				S_Email_ID,
				S_Delivery_Address1,
				S_Delivery_Address2,
				I_Delivery_City_ID,
				I_Delivery_State_ID,
				S_Delivery_Pin_No,
				I_Delivery_Country_ID,
				S_Delivery_Phone_No,
				S_Delivery_Email_ID)
			VALUES
			   (@iCenterID,@sAddress1,@sAddress2,@iCityID,
				@iStateID,@sPinCode,@iCountryID,@sPhoneNumber,@sEmail,
				@sDelAddress1,@sDelAddress2,@iDelCityID,
				@iDelStateID,@sDelPinCode,@iDelCountryID,@sDelPhoneNumber,	
				@sDelEmail)

		END
--  for update
	IF (@iFlag = 2)
		BEGIN
			INSERT INTO NETWORK.T_Center_Master_Audit		
			SELECT * FROM dbo.T_Centre_Master
				WHERE I_Centre_Id = @iCenterID

			UPDATE dbo.T_Centre_Master
			SET S_Center_Code = @sCenterCode,
				S_Center_Name = @sCenterName,
				S_Center_Short_Name = @sShortName,
				I_Center_Category = @iCategory,
				I_RFF_Type = @iRFFType,
				I_Is_OwnCenter = @iIsOwnCenter,
				S_ServiceTax_Regd_Code = @sServiceTaxRegdNo,
				I_Country_ID = @iCountryID,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedDt,
				I_Is_Startup_Material_In_Place = @iStartUpInPlace,
				I_Is_Library_In_Place = @iLibraryInPlace,
				I_Status = @iStatus
			WHERE I_Centre_Id = @iCenterID

			UPDATE NETWORK.T_Center_Address
			SET S_Center_Address1 = @sAddress1,
				S_Center_Address2 = @sAddress2,
				I_City_ID = @iCityID,
				I_State_ID = @iStateID,
				S_Pin_Code = @sPinCode,
				I_Country_ID = @iCountryID,
				S_Telephone_No = @sPhoneNumber,
				S_Email_ID = @sEmail,
				S_Delivery_Address1 = @sDelAddress1,
				S_Delivery_Address2 = @sDelAddress2,
				I_Delivery_City_ID = @iDelCityID,
				I_Delivery_State_ID = @iDelStateID,
				S_Delivery_Pin_No = @sDelPinCode,
				I_Delivery_Country_ID = @iDelCountryID,
				S_Delivery_Phone_No = @sDelPhoneNumber,
				S_Delivery_Email_ID = @sDelEmail
			WHERE I_Centre_Id = @iCenterID		

			UPDATE dbo.T_Hierarchy_Details
			SET S_Hierarchy_Name=@sCenterName
			WHERE I_Hierarchy_Detail_ID in 
			(SELECT I_Hierarchy_Detail_ID FROM dbo.T_Center_Hierarchy_Details WHERE i_center_id=@iCenterID)
		END

--  for delete
	IF (@iFlag = 3)
		BEGIN
			INSERT INTO NETWORK.T_Center_Master_Audit		
			SELECT * FROM dbo.T_Centre_Master
				WHERE I_Centre_Id = @iCenterID

			UPDATE dbo.T_Centre_Master
			SET I_Status = @iStatus,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedDt,
				Dt_Valid_To = @dtCreatedDt
			WHERE I_Centre_Id = @iCenterID	
		END
END
