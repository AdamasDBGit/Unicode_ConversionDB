
/**************************************************************************************************************
Created by  : Swagata De
Date		: 13.05.2007
Description : This SP will validate the login for access to offline examination system
Parameters  : Login ID,Password
Returns     : Dataset
exec [dbo].[uspValidateOTP] '9609492010',6575
**************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspValidateOTP_BKP_June2023BeforeGaurd]
	(
		@sMobile NVARCHAR(200)	,
		@iOtp int
	)
AS
BEGIN
	DECLARE @LastOTP int;
	DECLARE @token nvarchar(50)
	SET @LastOTP = (select top 1 I_OTP from T_Transaction_OTP where S_Mobile_Number = @sMobile order by Dt_CreatedAt desc)
	if(@LastOTP=@iOtp)
	BEGIN
	SET  @token = (select substring(replace(newid(), '-', ''), 1, 50))
	UPDATE T_Parent_Master 
	SET 
	S_Token = @token
	where S_Mobile_No = @sMobile

	select 
	 I_Parent_Master_ID ID
	,S_Token Token
	,S_First_Name FirstName
	,S_Last_Name LastName 
	,S_Mobile_No MobileNo
	,S_Address Address
	,S_Pin_Code PinCode
	,1 StatusFlag
	from T_Parent_Master where S_Mobile_No = @sMobile
	END
	ELSE
	BEGIN
	select 0 as StatusFlag
	END


END
