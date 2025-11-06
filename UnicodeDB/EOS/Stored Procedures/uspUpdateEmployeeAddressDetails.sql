/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP updates all Employee Address Details
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspUpdateEmployeeAddressDetails]
(
		@iEmployeeID int,
	    @sAddress1 varchar(200),
		@sAddress2 varchar(200),
		@sArea varchar(50),
		@iCityID int,
		@iStateID int,
		@iCountryID int,
		@sPinCode varchar(20),
		@sAddressPhNo varchar(50),
		@iAddressType int,			
		@sUpdatedBy varchar(20),		
		@DtUpdatedOn datetime
)
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (SELECT * FROM EOS.T_Employee_Address WHERE I_Employee_ID=@iEmployeeID AND I_Address_Type=@iAddressType)
	BEGIN
		UPDATE EOS.T_Employee_Address
		SET I_Country_ID = @iCountryID,
		I_State_ID = @iStateID,
		I_City_ID = @iCityID,
		S_District_Name =@sArea ,
		S_Address_Line1=@sAddress1,
		S_Address_Line2=@sAddress2,
		S_Zip_Code =@sPinCode ,
		S_Address_Phone_No =@sAddressPhNo ,
		S_Upd_By =@sUpdatedBy ,
		Dt_Upd_On = @DtUpdatedOn
		WHERE I_Employee_ID = @iEmployeeID AND I_Status=1 --Active
	END
	ELSE
	BEGIN
	INSERT INTO EOS.T_Employee_Address
	(
		I_Employee_ID,
		I_Country_ID,
		I_State_ID,
		I_City_ID,
		S_District_Name,
		S_Address_Line1,
		S_Address_Line2,
		S_Zip_Code,
		S_Address_Phone_No,
		I_Address_Type,
		I_Status,
		S_Crtd_By,
		Dt_Crtd_On
	)
	
	VALUES
	(
		@iEmployeeID,
		@iCountryID,
		@iStateID,
		@iCityID,
		@sArea,
		@sAddress1,
		@sAddress2,
		@sPinCode,
		@sAddressPhNo,
		@iAddressType,
		1,--active status
		@sUpdatedBy,
		@DtUpdatedOn
	)
	END
	
END
