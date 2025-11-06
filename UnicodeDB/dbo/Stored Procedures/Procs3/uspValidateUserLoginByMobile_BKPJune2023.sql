
/**************************************************************************************************************
Created by  : Swagata De
Date		: 13.05.2007
Description : This SP will validate the login for access to offline examination system
Parameters  : Login ID,Password
Returns     : Dataset
exec [dbo].[uspValidateUserLoginByMobile] '9609492010','234f34t34rji34tj'
**************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspValidateUserLoginByMobile_BKPJune2023]
	(
		@sMobile NVARCHAR(200)	,
		@sDevice NVARCHAR(200)
	)
AS
BEGIN

	DECLARE @OTP int;
	DECLARE @ID int;
	DECLARE @otpCreated int;
	DECLARE @otpFailedMobileDeviceBlock int;
	DECLARE @otpFailedSameDevice int;
	DECLARE @otpFailedDIffDeviceSameNum int;
	DECLARE @DeviceLogID int;
	DECLARE @LockingTime int;
	set @LockingTime =30;
	DECLARE @phonelocked int=0;
	DECLARE @devicelocked int=0;
	DECLARE @statusCode nvarchar(200)

	set @otpCreated = 
	(
	select count(TDL.S_Mobile_Number) from T_Transaction_Device_Log TDL
	inner join T_Transaction_OTP TOT ON TOT.I_Transaction_Device_Log_ID = TDL.I_Transaction_Device_Log_ID
	where TDL.S_Mobile_Number=@sMobile 
	and TDL.S_Device = @sDevice 
	and @LockingTime > DATEDIFF(MINUTE, TOT.Dt_CreatedAt,GETDATE())
	)

	set @otpFailedMobileDeviceBlock = 
	(
	select count(TDL.S_Mobile_Number) from T_Transaction_Device_Log TDL
	inner join T_Transaction_OTP TOT ON TOT.I_Transaction_Device_Log_ID = TDL.I_Transaction_Device_Log_ID
	where (TDL.S_Mobile_Number=@sMobile OR TDL.S_Device = @sDevice )
	and (TDL.I_IsDeviceBlock = 1 OR TDL.I_IsPhoneBlock = 1)
	and @LockingTime > DATEDIFF(MINUTE, TOT.Dt_CreatedAt,GETDATE())
	)
	
	set @otpFailedSameDevice = 
	(
	select count(TOFL.S_Mobile_Number) from T_Transaction_OTP_Fail_Log TOFL
	inner join T_Transaction_OTP TOT ON TOT.I_Transaction_Device_Log_ID = TOFL.I_Transaction_Device_Log_ID
	inner join T_Transaction_Device_Log TDL ON TDL.I_Transaction_Device_Log_ID = TOFL.I_Transaction_Device_Log_ID
	where TDL.S_Device=@sDevice 
	and @LockingTime > DATEDIFF(MINUTE, TOFL.Dt_CreatedAt,GETDATE())
	)
	
	
	select @otpFailedDIffDeviceSameNum =count(distinct TDL.S_Device) from T_Transaction_OTP_Fail_Log TOFL
	inner join T_Transaction_OTP TOT ON TOT.I_Transaction_Device_Log_ID = TOFL.I_Transaction_Device_Log_ID
	inner join T_Transaction_Device_Log TDL ON TDL.I_Transaction_Device_Log_ID = TOFL.I_Transaction_Device_Log_ID
	where TDL.S_Mobile_Number=@sMobile 
	 and @LockingTime > DATEDIFF(MINUTE, TOFL.Dt_CreatedAt,GETDATE())
	
	/*IF(@otpFailedDIffDeviceSameNum>3 )
	BEGIN
	print '@otpFailedDIffDeviceSameNum'
	update TDL 
	set TDL.I_IsDeviceBlock = 1
	,TDL.I_IsPhoneBlock = 1
	from T_Transaction_OTP_Fail_Log TOFL
	inner join T_Transaction_OTP TOT ON TOT.I_Transaction_Device_Log_ID = TOFL.I_Transaction_Device_Log_ID
	inner join T_Transaction_Device_Log TDL ON TDL.I_Transaction_Device_Log_ID = TOFL.I_Transaction_Device_Log_ID
	where TDL.S_Mobile_Number=@sMobile 
	and @LockingTime > DATEDIFF(MINUTE, TOFL.Dt_CreatedAt,GETDATE())
	END
	ELSE
	BEGIN
	IF( @otpFailedSameDevice < 3 AND @otpCreated<3)
	update TDL
	set TDL.I_IsDeviceBlock = 0
	,TDL.I_IsPhoneBlock = 0
	from T_Transaction_OTP_Fail_Log TOFL
	inner join T_Transaction_OTP TOT ON TOT.I_Transaction_Device_Log_ID = TOFL.I_Transaction_Device_Log_ID
	inner join T_Transaction_Device_Log TDL ON TDL.I_Transaction_Device_Log_ID = TOFL.I_Transaction_Device_Log_ID
	where TDL.S_Mobile_Number=@sMobile 
	and @LockingTime > DATEDIFF(MINUTE, TOFL.Dt_CreatedAt,GETDATE())
	END
	*/

	if(@otpCreated>=3) -- 3 times otp - block device and mobile
		BEGIN
		print '@otpCreated'
		UPDATE T_Transaction_Device_Log
		SET I_IsDeviceBlock =1
		,I_IsPhoneBlock = 1
		where S_Mobile_Number = @sMobile and S_Device = @sDevice
		END
	ELSE IF(@otpFailedSameDevice>=3) -- 3 times otp - block device and mobile
		BEGIN
		print '@otpFailedSameDevice'
		UPDATE T_Transaction_Device_Log
		SET I_IsDeviceBlock = 1
		where S_Device = @sDevice
		END
	ELSE IF(@otpFailedDIffDeviceSameNum>3 )
		BEGIN
		print '@otpFailedDIffDeviceSameNum'
		update TDL 
		set TDL.I_IsDeviceBlock = 1
		,TDL.I_IsPhoneBlock = 1
		from T_Transaction_OTP_Fail_Log TOFL
		inner join T_Transaction_OTP TOT ON TOT.I_Transaction_Device_Log_ID = TOFL.I_Transaction_Device_Log_ID
		inner join T_Transaction_Device_Log TDL ON TDL.I_Transaction_Device_Log_ID = TOFL.I_Transaction_Device_Log_ID
		where TDL.S_Mobile_Number=@sMobile 
		and @LockingTime > DATEDIFF(MINUTE, TOFL.Dt_CreatedAt,GETDATE())
	END
	ELSE
		BEGIN
		if(coalesce(@otpFailedMobileDeviceBlock,0) = 0)
		BEGIN
		
		print '@release'
		print @otpFailedMobileDeviceBlock
		UPDATE T_Transaction_Device_Log
		SET I_IsDeviceBlock =0
		,I_IsPhoneBlock = 0
		where S_Mobile_Number = @sMobile OR S_Device = @sDevice
		--select null as otp,0 as StatusFlag,'Phone or Device is bolcked for 30 min for too many attempts .' Message,@otpCreated totalOtpSent
		END
	END



	set  @phonelocked =(
	select count(I_IsPhoneBlock) from T_Transaction_Device_Log where (
	S_Mobile_Number = @sMobile OR S_Device = @sDevice) AND (I_IsPhoneBlock = 1)
	)
	set @devicelocked = (select count(I_IsDeviceBlock) from T_Transaction_Device_Log where (
	S_Mobile_Number = @sMobile OR S_Device = @sDevice) AND (I_IsDeviceBlock=1)
	)


	print 'test'+CAST(@phonelocked as nvarchar)
	if(coalesce(@phonelocked,0) = 0 AND  coalesce(@devicelocked,0) = 0  and coalesce(@otpFailedMobileDeviceBlock,0) = 0 )
	BEGIN
	IF EXISTS(select S_Mobile_No  MobileNo from [dbo].T_Parent_Master where S_Mobile_No = @sMobile and I_IsPrimary=1)
	BEGIN

		--SET @OTP = (SELECT LEFT(CAST(RAND()*1000000000+999999 AS INT),4) as OTP)
		SET @OTP = 1234
		IF NOT EXISTS(SELECT * from T_Transaction_Device_Log where S_Mobile_Number=@sMobile and S_Device = @sDevice)
		BEGIN
			INSERT INTO T_Transaction_Device_Log
			(
			S_Mobile_Number
			,I_IsPhoneBlock
			,S_Device
			,I_IsDeviceBlock
			,S_CreatedAt
			)
			values
			(
			@sMobile,
			0,
			@sDevice,
			0,
			getdate()
			)
        END
		set @DeviceLogID=(SELECT I_Transaction_Device_Log_ID  from T_Transaction_Device_Log where S_Mobile_Number=@sMobile and S_Device = @sDevice)


		INSERT INTO T_Transaction_OTP
		(
		 S_Mobile_Number
		,I_OTP
		,S_Device
		,Dt_CreatedAt
		,I_Status
		,I_Transaction_Device_Log_ID
		)
		VALUES
		(
		@sMobile
		,@OTP
		,@DeviceLogID
		,GETDATE()
		,1
		,@DeviceLogID
		)
		
		SET @ID = SCOPE_IDENTITY()
		
		set @otpCreated = (select count(TDL.S_Mobile_Number) from T_Transaction_Device_Log TDL
	inner join T_Transaction_OTP TOT ON TOT.I_Transaction_Device_Log_ID = TDL.I_Transaction_Device_Log_ID
	where TDL.S_Mobile_Number=@sMobile 
	and TDL.S_Device = @sDevice 
	and @LockingTime > DATEDIFF(MINUTE, TOT.Dt_CreatedAt,GETDATE()))
		
		select @OTP as otp,1 as StatusFlag,'Otp generated' Message,@otpCreated totalOtpSent




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

		SET @OTP = (SELECT LEFT(CAST(RAND()*1000000000+999999 AS INT),4) as OTP)

		INSERT INTO T_Transaction_Device_Log
		(
		S_Mobile_Number
		,I_IsPhoneBlock
		,S_Device
		,I_IsDeviceBlock
		,S_CreatedAt
		)
		values
		(
		@sMobile,
		0,
		@sDevice,
		0,
		getdate()
		)

	
	set @DeviceLogID=SCOPE_IDENTITY()

	INSERT INTO T_Transaction_OTP
	(
	 S_Mobile_Number
	,I_OTP
	,S_Device
	,I_Transaction_Device_Log_ID
	,Dt_CreatedAt
	,I_Status
	)
	VALUES
	(
	 @sMobile
	,@OTP
	,@sDevice
	,@DeviceLogID
	,GETDATE()
	,1
	)
	SET @ID = SCOPE_IDENTITY()

	set @otpCreated = (select count(I_OTP) from T_Transaction_OTP where S_Mobile_Number=@sMobile and S_Device = @sDevice and @LockingTime > DATEDIFF(MINUTE, GETDATE() , Dt_CreatedAt))
	select @OTP as otp,1 as StatusFlag,'Otp generated' Message,@otpCreated totalOtpSent


	END
	ELSE
	BEGIN
		select null as otp,0 as StatusFlag,'Invalid username and password.' Message,@otpCreated totalOtpSent
	END
	END
	ELSE
	BEGIN
	
	IF(@phonelocked!=0 and @devicelocked=0)
		SET @statusCode = '203'
	ELSE IF(@phonelocked=0 and @devicelocked!=0)
		SET @statusCode = '204'
	ELSE IF(@phonelocked!=0 and @devicelocked!=0)
		SET @statusCode = '202'
	ELSE 
		SET @statusCode = ''
	select null as otp,0 as StatusFlag,'Phone or Device is bolcked for 30 min for too many attempts .' Message,@otpCreated totalOtpSent,@statusCode  statusCode
	END
	END
