-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023July02>
-- Description:	<Guard Details Pull from Parent App>
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertUpdateGuardDetails] 
	-- Add the parameters for the stored procedure here
	@sToken nvarchar(max),
	@sGuardFullName NVARCHAR(MAX),
	@iGaurdEmpNo INT= NULL,
	@iPhoneNo NVARCHAR(MAX),
	@SCreatedBy NVARCHAR(MAX)='AIS-Admin',
	@Type nvarchar(20) =null,
	@fireBaseToken nvarchar(20)= null
AS



BEGIN TRY

	SET NOCOUNT ON;
	BEGIN TRANSACTION
	IF(@Type='Teacher')
	BEGIN
	update T_ERP_User set S_Token = @sToken,S_FireBase_Token=@fireBaseToken where S_Mobile = @iPhoneNo
	Select I_User_ID as GatePassGuardID from T_ERP_User where S_Mobile = @iPhoneNo
	END
	ELSE
	BEGIN
	IF EXISTS(select * from dbo.T_Gate_Pass_Guard where S_Phone_No=@iPhoneNo)
		BEGIN

			update dbo.T_Gate_Pass_Guard set S_Token=@sToken,S_UpdateBy='AIS-Admin',Dt_UpdatedOn=GETDATE() where S_Phone_No=@iPhoneNo
			Select I_Gate_Pass_Guard_ID as GatePassGuardID from T_Gate_Pass_Guard where S_Phone_No=@iPhoneNo
		END
	ELSE
		BEGIN
				DECLARE @FirstName nvarchar(max),@MiddleName nvarchar(max),@LastName nvarchar(max)
				DECLARE @GatePassGuardID INT
				SELECT 
				@FirstName=Ltrim(SubString(@sGuardFullName, 1, Isnull(Nullif(CHARINDEX(' ', @sGuardFullName), 0), 1000))) 
				,@MiddleName=Ltrim(SUBSTRING(@sGuardFullName, CharIndex(' ', @sGuardFullName), 
				CASE 
				WHEN (CHARINDEX(' ', @sGuardFullName, CHARINDEX(' ', @sGuardFullName) + 1) - CHARINDEX(' ', @sGuardFullName)) <= 0
                    THEN 0
                ELSE
					CHARINDEX(' ', @sGuardFullName, CHARINDEX(' ', @sGuardFullName) + 1) - CHARINDEX(' ', @sGuardFullName)
                END)) 
				,@LastName=Ltrim(SUBSTRING(@sGuardFullName, Isnull(Nullif(CHARINDEX(' ', @sGuardFullName, Charindex(' ', @sGuardFullName) + 1), 0), CHARINDEX(' ', @sGuardFullName)), CASE 
                WHEN Charindex(' ', @sGuardFullName) = 0
                    THEN 0
                ELSE
				LEN(@sGuardFullName)
                END))

				insert into T_Gate_Pass_Guard
				(
				S_First_Name,
				S_Middle_Name,
				S_Last_Name,
				I_EMP_No,
				S_Phone_No,
				S_Token,
				S_CreatedBy,
				Dt_CreatedOn
				)
				values
				(
				@FirstName,
				@MiddleName,
				@LastName,
				@iGaurdEmpNo,
				@iPhoneNo,
				@sToken,
				'AIS-Admin',
				GETDATE()
				)

				SET @GatePassGuardID = SCOPE_IDENTITY()

				Select @GatePassGuardID as GatePassGuardID 

		END
	
	END
	


		COMMIT transaction
  
END TRY

BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH




