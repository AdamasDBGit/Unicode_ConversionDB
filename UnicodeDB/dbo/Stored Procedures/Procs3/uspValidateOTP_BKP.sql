/**************************************************************************************************************
Created by  : Swagata De
Date		: 13.05.2007
Description : This SP will validate the login for access to offline examination system
Parameters  : Login ID,Password
Returns     : Dataset
exec [dbo].[uspValidateOTP] '9609492010',6575
**************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspValidateOTP_BKP]
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
		IF EXISTS (select * from T_Parent_Master where S_Mobile_No = @sMobile and I_IsPrimary=1)
			BEGIN

				IF EXISTS (
				select * from T_Transaction_Device_Log as TDL
				inner join
				T_Transaction_OTP as TOTP on TOTP.I_Transaction_Device_Log_ID=TDL.I_Transaction_Device_Log_ID
				where TDL.S_Mobile_Number=@sMobile and TOTP.S_Mobile_Number=@sMobile and TOTP.I_OTP=@LastOTP
				and DATEDIFF(MINUTE,TOTP.Dt_CreatedAt,GETDATE()) < 1 
				)
				BEGIN

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

					select 0 as StatusFlag,'OTP Expired' as StatusMessage

					END

			END

		ELSE IF EXISTS(
		select * from 
		T_Employee_Dtls as ED 
		inner join
		T_User_Master as UM on ED.I_Employee_ID=UM.I_Reference_ID
		inner join
		T_User_Role_Details as URD on URD.I_User_ID=UM.I_User_ID
		inner join
		T_Role_Master as RM on RM.I_Role_ID=URD.I_Role_ID
		inner join
		T_User_Hierarchy_Details as UHD on UHD.I_User_ID=UM.I_User_ID
		where RM.S_Role_Code='GateGuard' 
		and ED.I_Status=3
		and UM.I_Status=1 and RM.I_Status=1
		and ED.S_Phone_No=@sMobile
		)
			BEGIN
				
				IF EXISTS (
				select * from T_Transaction_Device_Log as TDL
				inner join
				T_Transaction_OTP as TOTP on TOTP.I_Transaction_Device_Log_ID=TDL.I_Transaction_Device_Log_ID
				where TDL.S_Mobile_Number=@sMobile and TOTP.S_Mobile_Number=@sMobile and TOTP.I_OTP=@LastOTP
				and DATEDIFF(MINUTE,TOTP.Dt_CreatedAt,GETDATE()) < 5 
				)
				BEGIN
					update UM set UM.S_Token=@token from
					T_Employee_Dtls as ED 
					inner join
					T_User_Master as UM on ED.I_Employee_ID=UM.I_Reference_ID
					inner join
					T_User_Role_Details as URD on URD.I_User_ID=UM.I_User_ID
					inner join
					T_Role_Master as RM on RM.I_Role_ID=URD.I_Role_ID
					inner join
					T_User_Hierarchy_Details as UHD on UHD.I_User_ID=UM.I_User_ID
					where RM.S_Role_Code='GateGuard' 
					and ED.I_Status=3
					and UM.I_Status=1 and RM.I_Status=1
					and ED.S_Phone_No=@sMobile
				END

				ELSE
					BEGIN

					select 0 as StatusFlag,'OTP Expired' as StatusMessage

					END


			END

	END
	ELSE
	BEGIN


		DECLARE @iDeviceID nvarchar(max)

		select TOP 1 @iDeviceID=TDL.I_Transaction_Device_Log_ID  from T_Transaction_Device_Log as TDL
		inner join
		T_Transaction_OTP as TOTP on TOTP.I_Transaction_Device_Log_ID=TDL.I_Transaction_Device_Log_ID
		where TDL.S_Mobile_Number=@sMobile and TOTP.S_Mobile_Number=@sMobile 
		and CONVERT(DATE,TOTP.Dt_CreatedAt) = CONVERT(DATE,GETDATE())

		insert into T_Transaction_OTP_Fail_Log
		(
			I_Transaction_Device_Log_ID,
			S_Mobile_Number,
			I_OTP,
			I_Given_Wrong_OTP,
			Dt_CreatedAt
		)
		values
		(
		@iDeviceID,
		@sMobile,
		@LastOTP,
		@iOtp,
		getdate()
		)


		------ Phone number Block -------

	

		---------------------------------


		select 0 as StatusFlag,'Invalid OTP' as StatusMessage
	END


END
