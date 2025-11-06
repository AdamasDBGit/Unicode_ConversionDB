CREATE PROCEDURE [ECOMMERCE].[uspInsertStudentLoginDetails](@LoginID VARCHAR(MAX),@UserID INT=0)
AS
BEGIN TRY

DECLARE @iUserID int=0,
	@sLoginID varchar(200),
	@sPassword varchar(200)=NULL,
	@sTitle varchar(20)=NULL,
	@sFirstName varchar(100),
	@sMiddleName varchar(100)=NULL,
	@sLastName varchar(100)=NULL,
	@sEmailID varchar(200)=NULL,
	@sUserType varchar(20),
	@sForgotPasswordQuestion varchar(200)=NULL,
	@sForgotPasswordAnswer varchar(200)=NULL,	
	@iReferenceID int = null,
	@iHierarchyMasterID int=NULL,
	@iHierarchyDetailID int=NULL,
	@iOldHierarchyDetailID int=NULL,
	@sCreatedBy varchar(20),
	@dtDate DATETIME=GETDATE(),
	@DOB DATETIME,
	@iflag int

IF NOT EXISTS
(
	SELECT * FROM [dbo].[T_User_Master] AS TUM 
	WHERE [TUM].[S_Login_ID] = @LoginID
	AND [TUM].[I_User_ID] != @UserID
)
BEGIN


	select 
	@iReferenceID=A.I_Student_Detail_ID,
	@iHierarchyMasterID=D.I_Hierarchy_Master_ID,
	@iHierarchyDetailID=C.I_Hierarchy_Detail_ID,
	@sFirstName=A.S_First_Name,
	@sMiddleName=ISNULL(A.S_Middle_Name,''),
	@sLastName=A.S_Last_Name,
	@sEmailID=ISNULL(A.S_Email_ID,''),
	@sUserType='ST',
	@DOB=A.Dt_Birth_Date,
	@iflag=1
	from 
	T_Student_Detail A
	inner join T_Student_Center_Detail B on A.I_Student_Detail_ID=B.I_Student_Detail_ID
	inner join T_Center_Hierarchy_Name_Details C on B.I_Centre_Id=C.I_Center_ID
	inner join T_Hierarchy_Details D on C.I_Hierarchy_Detail_ID=D.I_Hierarchy_Detail_ID
	where A.S_Student_ID=@LoginID and B.I_Status=1

	exec uspModifyCompanyUserStudent @iUserID=0,@sLoginID=@LoginID,@sPassword='nEnKkpAzTK6P3avg1/PN/Q==',@sTitle=default,
	@sFirstName=@sFirstName,@sMiddleName=@sMiddleName,@sLastName=@sLastName,@sEmailID=@sEmailID,@sUserType='ST',@sForgotPasswordQuestion=default,
	@sForgotPasswordAnswer=default,@iReferenceID=@iReferenceID,@iOldHierarchyDetailID=0,@sCreatedBy=N'rice-group-admin',@iFlag=1,@DOB=@DOB

	select @iUserID=I_User_ID from T_User_Master where S_Login_ID=@LoginID

	if(@iUserID>0)
	begin

		exec dbo.uspAddRoleToUser @iUserID=@iUserID,@sRoleIDList='16,',@sCrtdBy='rice-group-admin',@dCrtdOn=@dtDate

	end


END





END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
