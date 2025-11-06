/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/

CREATE PROCEDURE [dbo].[uspInsertUpdateDeleteFaculty] 
(
	@iMode int = 0,
	@iFacultyMasterID int = null,
	@sFacultyCode nvarchar(50) = null,
	@sFacultyName	 nvarchar(50) = null,
	@sFacultyType	 nvarchar(50) = null,
	@sMobileNo	 nvarchar(50) = null,
	@dtDOB datetime = null,
	@dtDOJ datetime = null,
	@sGender nvarchar(10) = null,
	@iReligionID int = null,
	@iMaritialID int = null,
	@sPhoto				nvarchar(MAX) = null,
	@sSignature			nvarchar(MAX) = null,
	@sPAN				nvarchar(50) = null,
	@sAadhar			nvarchar(50) = null,
	@sEMail				nvarchar(50)=null,
	@sPresentAddress	nvarchar(MAX) = null,
	@sPermanentAddress	nvarchar(MAX) = null,
	@iStatus			int = 1,
	@iBrandID			int = null,
	@iCreatedBy int = null,
	@ProvideUserAceess int=1,
	@UserID nvarchar(100) = null,
	@Password nvarchar(200) = null
	--@UtRecipient UT_Recipient readonly
)
AS
begin transaction
BEGIN TRY 
DECLARE @FacultyID int
DECLARE @LastUserID int

IF (@iMode >= 1 AND @iFacultyMasterID > 0)
    BEGIN
        UPDATE T_Faculty_Master set I_Status = 0 WHERE I_Faculty_Master_ID = @iFacultyMasterID
        SELECT 1 AS StatusFlag, 'Faculty Deactivated successfully' AS Message
    END

ELSE IF(@iMode <= 0 AND @iFacultyMasterID > 0 )
BEGIN
IF EXISTS(select * from T_Faculty_Master where S_Mobile_No = @sMobileNo and I_Faculty_Master_ID !=@iFacultyMasterID)
BEGIN
SELECT 0 StatusFlag,'Duplicate mobile no ' Message
END
ELSE IF EXISTS(select * from T_Faculty_Master where S_PAN=@sPAN and I_Faculty_Master_ID !=@iFacultyMasterID)
BEGIN
SELECT 0 StatusFlag,'Duplicate PAN' Message
END
ELSE IF EXISTS(select * from T_Faculty_Master where S_Aadhaar=@sAadhar and I_Faculty_Master_ID !=@iFacultyMasterID)
BEGIN
SELECT 0 StatusFlag,'Duplicate Aadhar' Message
END
ELSE IF EXISTS(select * from T_Faculty_Master where [S_Email]=@sEMail and I_Faculty_Master_ID !=@iFacultyMasterID)
BEGIN
SELECT 0 StatusFlag,'Duplicate Email' Message
END
ELSE IF EXISTS(select * from T_Faculty_Master where S_Faculty_Code=@sFacultyCode and I_Faculty_Master_ID !=@iFacultyMasterID)
BEGIN
SELECT 0 StatusFlag, 'Duplicate Faculty Code' Message
END
ELSE
BEGIN
UPDATE T_Faculty_Master
SET
 [S_Faculty_Code]				=@sFacultyCode
,[S_Faculty_Name]				=@sFacultyName
,[S_Faculty_Type]				=@sFacultyType
,[Dt_DOJ]						=@dtDOJ
,[I_CreatedBy]					=@iCreatedBy
,[Dt_DOB]						=@dtDOB
,[S_Gender]						=@sGender
,[I_Religion_ID]				=@iReligionID
,[I_Maritial_ID]				=@iMaritialID
,[S_Mobile_No]					=@sMobileNo
,[S_Photo]						=@sPhoto				
,[S_Signature]					=@sSignature			
,[S_PAN]						=@sPAN				
,[S_Aadhaar]					=@sAadhar			
,[S_Email]						=@sEMail				
,[S_Present_Address]			=@sPresentAddress	
,[S_Permanent_Address]			=@sPermanentAddress	
,[Dt_CreatedAt]					=GETDATE()--
,[I_Status]						=@iStatus			
,[I_Brand_ID]					=@iBrandID		
where I_Faculty_Master_ID = @iFacultyMasterID
IF EXISTS(select * from T_ERP_User where S_Mobile = @sMobileNo)
BEGIN
DECLARE @updateduserID int 
set @updateduserID = (select I_User_ID  from T_ERP_User where S_Mobile=@sMobileNo)
UPDATE T_ERP_User SET S_Username = ISNULL(@UserID,@sFacultyCode), S_Password = ISNULL(@Password,'welcome'), S_Email=@sEMail,
	S_First_Name=@sFacultyName,
	S_Mobile=@sMobileNo,  I_Created_By=@iCreatedBy,
	I_Status=@iStatus where S_Mobile=@sMobileNo
	update T_Faculty_Master set I_User_ID = @updateduserID where I_Faculty_Master_ID = @iFacultyMasterID
END
ELSE
BEGIN
INSERT INTO T_ERP_User
		( 
		  S_Username, 
		  S_Password, 
		  S_Email,
	      S_First_Name,
	      S_Mobile, 
		  Dt_CreatedAt, 
		  I_Created_By,
	      Dt_Last_Login, 
		  I_Status,
		  I_User_Type
         )
        
		VALUES
		( 
		  ISNULL(@UserID,@sFacultyCode), 
		  ISNULL(@Password,'welcome'),  
		  @sEMail,
	      @sFacultyName,
	      @sMobileNo, 
		  SYSDATETIME(), 
		  @iCreatedBy,
	      SYSDATETIME(), 
		  1,
		  2
        )
		set @LastUserID = SCOPE_IDENTITY()
		--print @LastUserID
		UPDATE T_Faculty_Master set I_User_ID = @LastUserID where I_Faculty_Master_ID = @FacultyID
END

SELECT 1 StatusFlag,'Faculty updated succesfully' Message
END
END
ELSE
BEGIN
IF EXISTS(select * from T_Faculty_Master where S_Mobile_No = @sMobileNo )
BEGIN
SELECT 0 StatusFlag,'Duplicate mobile no ' Message
END
ELSE IF EXISTS(select * from T_Faculty_Master where S_PAN=@sPAN )
BEGIN
SELECT 0 StatusFlag,'Duplicate PAN' Message
END
ELSE IF EXISTS(select * from T_Faculty_Master where S_Aadhaar=@sAadhar )
BEGIN
SELECT 0 StatusFlag,'Duplicate Aadhar' Message
END
ELSE IF EXISTS(select * from T_Faculty_Master where [S_Email]=@sEMail )
BEGIN
SELECT 0 StatusFlag,'Duplicate Email' Message
END
ELSE IF EXISTS(select * from T_Faculty_Master where S_Faculty_Code=@sFacultyCode )
BEGIN
SELECT 0 StatusFlag, 'Duplicate Faculty Code' Message
END
ELSE
BEGIN
INSERT INTO [T_Faculty_Master]
(
 [S_Faculty_Code]
,[S_Faculty_Name]
,[S_Faculty_Type]
,[Dt_DOJ]
,[I_CreatedBy]
,[Dt_DOB]
,[S_Gender]
,[I_Religion_ID]
,[I_Maritial_ID]
,[S_Photo]
,[S_Mobile_No]
,[S_Signature]
,[S_PAN]
,[S_Aadhaar]
,[S_Email]
,[S_Present_Address]
,[S_Permanent_Address]
,[Dt_CreatedAt]
,[I_Status]
,[I_Brand_ID]
)
VALUES
(
 @sFacultyCode--
,@sFacultyName--
,@sFacultyType--
,@dtDOJ--
,@iCreatedBy--
,@dtDOB--
,@sGender--
,@iReligionID--
,@iMaritialID--
,@sPhoto				--
,@sMobileNo
,@sSignature			--
,@sPAN				--
,@sAadhar			--
,@sEMail				--
,@sPresentAddress	--
,@sPermanentAddress	--
,GETDATE()--
,@iStatus			--
,@iBrandID			--
)
set @FacultyID = SCOPE_IDENTITY()
print @FacultyID
--IF(@ProvideUserAceess=1)
--BEGIN
INSERT INTO T_ERP_User
		( 
		  S_Username, 
		  S_Password, 
		  S_Email,
	      S_First_Name,
	      S_Mobile, 
		  Dt_CreatedAt, 
		  I_Created_By,
	      Dt_Last_Login, 
		  I_Status,
		  I_User_Type
         )
        
		VALUES
		( 
		  ISNULL(@UserID,@sFacultyCode),  
		  ISNULL(@Password,'welcome'), 
		  @sEMail,
	      @sFacultyName,
	      @sMobileNo, 
		  SYSDATETIME(), 
		  @iCreatedBy,
	      SYSDATETIME(), 
		  1,
		  2
        )
		set @LastUserID = SCOPE_IDENTITY()
		print @LastUserID
		UPDATE T_Faculty_Master set I_User_ID = @LastUserID where I_Faculty_Master_ID = @FacultyID
--END

SELECT 1 StatusFlag,'Faculty added succesfully' Message
END

END



END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
select 0 StatusFlag,@ErrMsg Message
	--RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction
