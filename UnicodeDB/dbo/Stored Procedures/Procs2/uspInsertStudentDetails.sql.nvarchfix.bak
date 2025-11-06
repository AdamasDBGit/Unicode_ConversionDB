CREATE PROCEDURE [dbo].[uspInsertStudentDetails] 
(
	@Centre int,
	@OccupationID int,
	@PrefCareerID int,
	@InfoSourceID int,
	@EnquiryTypeID int,
	@EnquiryNo Nnvarchar(max),
	@IsCorporate Nnvarchar(max),
	@EnquiryDesc Nnvarchar(max),
	@Title Nnvarchar(max),
	@FirstName Nnvarchar(max),
	@MiddleName Nnvarchar(max),
	@LastName Nnvarchar(max),
	@DtBirthDate datetime,
	@Age Nnvarchar(max),
	@QualificationNameID int,
	@SkipTest char(1),
	@StreamID int,
	@EmailID Nnvarchar(max),
	@PhoneNo Nnvarchar(max),
	@MobileNo Nnvarchar(max),
	@CurrCityID int,
	@CurrStateID int,
	@CurrCountryID int,
	@GuardianName Nnvarchar(max),
	@GuardianOccupationID int,
	@GuardianEmailID Nnvarchar(max),
	@GuardianPhoneNo Nnvarchar(max),
	@GuardianMobileNo Nnvarchar(max),
	@IncomeGroupID int,
	@CurrAddress1 Nnvarchar(max),
	@CurrAddress2 Nnvarchar(max),
	@CurrPincode Nnvarchar(max),
	@CurrArea Nnvarchar(max),
	@PermAddress1 Nnvarchar(max),
	@PermAddress2 Nnvarchar(max),
	@PermPincode Nnvarchar(max),
	@PermCityID int,
	@PermStateID int,
	@PermCountryID int,
	@PermArea Nnvarchar(max),
	@CrtdBy Nnvarchar(max),
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
	DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

