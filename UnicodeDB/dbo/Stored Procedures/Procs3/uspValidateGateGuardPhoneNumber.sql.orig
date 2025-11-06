-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023June15>
-- Description:	<Get Validate Phone Number of Gate Guard>
-- =============================================
CREATE PROCEDURE [dbo].[uspValidateGateGuardPhoneNumber] 
	-- Add the parameters for the stored procedure here
	@MobileNumber varchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS
	(
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
	and ED.S_Phone_No=@MobileNumber
	)
	BEGIN
		select 1 As PhoneValidStatus
	END
	ELSE
		BEGIN
			select 0 As PhoneValidStatus
		END


   
END
