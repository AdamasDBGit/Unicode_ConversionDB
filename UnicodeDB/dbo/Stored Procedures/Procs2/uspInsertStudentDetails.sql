CREATE PROCEDURE [dbo].[uspInsertStudentDetails] 
(
	@Centre int,
	@OccupationID int,
	@PrefCareerID int,
	@InfoSourceID int,
	@EnquiryTypeID int,
	@EnquiryNo NVARCHAR(max),
	@IsCorporate NVARCHAR(max),
	@EnquiryDesc NVARCHAR(max),
	@Title NVARCHAR(max),
	@FirstName NVARCHAR(max),
	@MiddleName NVARCHAR(max),
	@LastName NVARCHAR(max),
	@DtBirthDate datetime,
	@Age NVARCHAR(max),
	@QualificationNameID int,
	@SkipTest char(1),
	@StreamID int,
	@EmailID NVARCHAR(max),
	@PhoneNo NVARCHAR(max),
	@MobileNo NVARCHAR(max),
	@CurrCityID int,
	@CurrStateID int,
	@CurrCountryID int,
	@GuardianName NVARCHAR(max),
	@GuardianOccupationID int,
	@GuardianEmailID NVARCHAR(max),
	@GuardianPhoneNo NVARCHAR(max),
	@GuardianMobileNo NVARCHAR(max),
	@IncomeGroupID int,
	@CurrAddress1 NVARCHAR(max),
	@CurrAddress2 NVARCHAR(max),
	@CurrPincode NVARCHAR(max),
	@CurrArea NVARCHAR(max),
	@PermAddress1 NVARCHAR(max),
	@PermAddress2 NVARCHAR(max),
	@PermPincode NVARCHAR(max),
	@PermCityID int,
	@PermStateID int,
	@PermCountryID int,
	@PermArea NVARCHAR(max),
	@CrtdBy NVARCHAR(max),
	@DtCrtdOn datetime
)

AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @iGetCourseIndex int
	DECLARE @iCourseListLength int
	DECLARE @iCourseID int
	DECLARE @sSelectedCourseIDs nvarchar(max)
	DECLARE @iEnquiryID int
	DECLARE @iCenterID int
	DECLARE @sLoginID nvarchar(max)
	DECLARE @iUserID int
	DECLARE @iStudentDetailId int
	
	/*SELECT @iCenterID = I_Center_Id FROM 
	dbo.T_Center_Hierarchy_Details WHERE
	I_Hierarchy_Detail_ID = @Centre*/
	BEGIN TRANSACTION
	
	SELECT @sLoginID = [dbo].fnGetStudentNo(@Centre)
	
    INSERT INTO dbo.T_Student_Detail
	(
	S_Student_ID,
	I_Occupation_ID,
	I_Pref_Career_ID,
	S_Title,
	S_First_Name,
	S_Middle_Name,
	S_Last_Name,
	Dt_Birth_Date,
	S_Age,
	I_Qualification_Name_ID,
	I_Stream_ID,
	S_Email_ID,
	S_Phone_No,
	S_Mobile_No,
	I_Curr_City_ID,
	I_Curr_State_ID,
	I_Curr_Country_ID,
	S_Guardian_Name,
	I_Guardian_Occupation_ID,
	S_Guardian_Email_ID,
	S_Guardian_Phone_No,
	S_Guardian_Mobile_No,
	I_Income_Group_ID,
	S_Curr_Address1,
	S_Curr_Address2,
	S_Curr_Pincode,
	S_Curr_Area,
	S_Perm_Address1,
	S_Perm_Address2,
	S_Perm_Pincode,
	I_Perm_City_ID,
	I_Perm_State_ID,
	I_Perm_Country_ID,
	S_Perm_Area,
	S_Crtd_By,
	Dt_Crtd_On,
	I_Status
	)
	VALUES
	(
	@sLoginID,
	@OccupationID,
	@PrefCareerID,
	@Title,
	@FirstName,
	@MiddleName,
	@LastName,
	@DtBirthDate,
	@Age,
	@QualificationNameID,
	@StreamID,
	@EmailID,
	@PhoneNo,
	@MobileNo,
	@CurrCityID,
	@CurrStateID,
	@CurrCountryID,
	@GuardianName,
	@GuardianOccupationID,
	@GuardianEmailID,
	@GuardianPhoneNo,
	@GuardianMobileNo,
	@IncomeGroupID,
	@CurrAddress1,
	@CurrAddress2,
	@CurrPincode,
	@CurrArea,
	@PermAddress1,
	@PermAddress2,
	@PermPincode,
	@PermCityID,
	@PermStateID,
	@PermCountryID,
	@PermArea,
	@CrtdBy,
	@DtCrtdOn,
	1)

	SET @iStudentDetailId=@@IDENTITY

	INSERT INTO T_Student_Center_Detail
		(
		I_Student_Detail_ID,
		I_Centre_ID,
		I_Status,
		Dt_Valid_From
		)
		SELECT 
			@iStudentDetailId,
			@Centre,
			--@iCenterID,
			1,
			Getdate()
	
SELECT @iStudentDetailId AS StudentID, @sLoginID AS StudentCode	
COMMIT TRANSACTION					
END TRY

BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRANSACTION 
	DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH


