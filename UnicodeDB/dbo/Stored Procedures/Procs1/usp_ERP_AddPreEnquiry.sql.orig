-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_AddPreEnquiry]
(
	@sFirstName varchar(50) = NULL,
	@sMiddleName varchar(50) = NULL,
	@sLastName varchar(50) = NULL,
	@DtBirthDate date = NULL,
	@sMobileNo varchar(20) = NULL,
	@iEnquiryStatusCode int = NULL,
	@CreatedBy int = NULL,

	@iRelationId int = NULL,                  --------
	@GuardianFirstName nvarchar(100) = NULL,  --------
	@GuardianMiddleName nvarchar(100) = NULL, --------
	@GuardianLastName nvarchar(100) = NULL,   --------
	@GuardianEmailId nvarchar(100) = NULL,    --------
	@GuardianMobileNo nvarchar(50) = NULL,    --------

	@sAddressType nvarchar(10) = NULL,        --------
	@sAddressLine1 nvarchar(MAX) = NULL,
	@sAddressLine2 nvarchar(MAX) = NULL,
	@iCountryId int = NULL,
	@iStateId int = NULL,
	@iCityId int = NULL,
	@sPinCode nvarchar(10) = NULL,

	@iEnquiryType int = NULL,                --------
	@iCourseAppliedFor int NULL,
	@iBrandID int = NULL                     --------
)
AS
begin transaction
BEGIN
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		BEGIN
		-- Insert statements for procedure here
		DECLARE @EnquiryRegnID INT

		INSERT INTO [dbo].[T_ERP_Enquiry_Regn_Detail] 
		(
			I_Enquiry_Status_Code,
			I_Enquiry_Type_ID,
			I_Course_Applied_For,
			S_First_Name,
			S_Middle_Name,
			S_Last_Name,
			Dt_Birth_Date,
			S_Mobile_No,
			S_Crtd_By,
			Dt_Crtd_On,
			PreEnquiry_Crtd_By,
			PreEnquiryDate,
			I_Brand_ID
		)
		VALUES 
		(
			@iEnquiryStatusCode, 
			@iEnquiryType,
			@iCourseAppliedFor,
			@sFirstName,
			@sMiddleName,
			@sLastName,
			@DtBirthDate,
			@sMobileNo,
			@CreatedBy,
			GETDATE(),
			@CreatedBy,
			GETDATE(),
			@iBrandID
		);
		SET @EnquiryRegnID = SCOPE_IDENTITY()
		DECLARE @sEnquiryNo nvarchar(50)
		set @sEnquiryNo = 'ERP'+CAST(@EnquiryRegnID AS NVARCHAR(50))
		update [T_ERP_Enquiry_Regn_Detail] set S_Enquiry_No = @sEnquiryNo where I_Enquiry_Regn_ID = @EnquiryRegnID

		INSERT INTO [dbo].[T_ERP_Enquiry_Regn_Guardian_Master] 
		(
			I_Enquiry_Regn_ID,
			I_Relation_ID,
			S_First_Name,
			S_Middile_Name,
			S_Last_Name,			
			S_Mobile_No,
			S_Guardian_Email,
			S_CreatedBy,
			Dt_CreatedAt,
			I_Status
		)
		VALUES 
		(
			@EnquiryRegnID,
			@iRelationId,
			@GuardianFirstName,
			@GuardianMiddleName,
			@GuardianLastName,
			@GuardianMobileNo,
			@GuardianEmailId,
			@CreatedBy,
			GETDATE(),
			1
		);

		INSERT INTO [dbo].[T_ERP_Enquiry_Regn_Address] 
		(
			I_Enquiry_Regn_ID,
			S_Address_Type,
			S_Country_ID,
			S_State_ID,
			S_City_ID,			
			S_Address1,
			S_Address2,
			S_Pincode,			
			I_Status
		)
		VALUES 
		(
			@EnquiryRegnID,
			@sAddressType,
			@iCountryId,
			@iStateId,
			@iCityId,
			@sAddressLine1,
			@sAddressLine2,
			@sPinCode,
			1
		);
		select 1 StatusFlag,'Pre Enquiry Created succesfully' Message,@EnquiryRegnID EnquiryRegnID, @sEnquiryNo EnquiryNo;
	END
END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
	select 0 StatusFlag,@ErrMsg Message
END CATCH
commit transaction
END
