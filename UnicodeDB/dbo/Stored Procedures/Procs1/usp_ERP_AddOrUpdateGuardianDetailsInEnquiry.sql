-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_AddOrUpdateGuardianDetailsInEnquiry]
(
	@iEnquiryRegnID int = NULL,

	@sFatherFirstName nvarchar(100) = NULL,
	@sFatherMiddleName nvarchar(100) = NULL,
	@sFatherLastName nvarchar(100) = NULL,
	@sFatherMobileNo nvarchar(50) = NULL,
	@sFatherEmailID nvarchar(100) = NULL,
	@iFatherQualification int = NULL,
	@iFatherOccupation int = NULL,
	@sFatherNameOfCompany nvarchar(200) = NULL,
	@sFatherDesignation nvarchar(200) = NULL,
	@iFatherIncome int = NULL,
	@sFatherPhotoFilePath nvarchar(200) = NULL,

	@sMotherFirstName nvarchar(100) = NULL,
	@sMotherMiddleName nvarchar(100) = NULL,
	@sMotherLastName nvarchar(100) = NULL,
	@sMotherMobileNo nvarchar(50) = NULL,
	@sMotherEmailID nvarchar(100) = NULL,
	@iMotherQualification int = NULL,
	@iMotherOccupation int = NULL,
	@sMotherNameOfCompany nvarchar(200) = NULL,
	@sMotherDesignation nvarchar(200) = NULL,
	@iMotherIncome int = NULL,
	@sMotherPhotoFilePath nvarchar(200) = NULL,

	@sAddressType nvarchar(20) = NULL,
	@sAddressLine1 nvarchar(max) = NULL,
	@sAddressLine2 nvarchar(max) = NULL,
	@iCountry int = NULL,
	@iState int = NULL,
	@iCity int = NULL,
	@sPincode nvarchar(10) = NULL,

	@iUpdatedBy int = NULL
)
AS
begin transaction
BEGIN
	BEGIN TRY		
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		IF @sFatherPhotoFilePath IS NULL
		BEGIN
			SET @sFatherPhotoFilePath = (SELECT S_Profile_Picture FROM T_ERP_Enquiry_Regn_Guardian_Master WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID and I_Relation_ID = 1)
		END
		IF @sMotherPhotoFilePath IS NULL
		BEGIN
			SET @sMotherPhotoFilePath = (SELECT S_Profile_Picture FROM T_ERP_Enquiry_Regn_Guardian_Master WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID and I_Relation_ID = 2)
		END		

		-- Insert statements for procedure here

		IF EXISTS (SELECT 1 FROM T_ERP_Enquiry_Regn_Guardian_Master where I_Enquiry_Regn_ID = @iEnquiryRegnID and I_Relation_ID = 1)
		BEGIN
			UPDATE [dbo].[T_ERP_Enquiry_Regn_Guardian_Master]
			SET	
				I_Relation_ID = 1,
				S_Mobile_No = @sFatherMobileNo,
				S_First_Name = @sFatherFirstName,
				S_Middile_Name = @sFatherMiddleName,
				S_Last_Name = @sFatherLastName,
				S_Guardian_Email = @sFatherEmailID,
				I_Qualification_ID = @iFatherQualification,
				I_Occupation_ID = @iFatherOccupation,
				S_Company_Name = @sFatherNameOfCompany,
				S_Designation = @sFatherDesignation,
				I_Income_Group_ID = @iFatherIncome,
				S_Profile_Picture = @sFatherPhotoFilePath,
				Dt_UpdatedAt = GETDATE()

			WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID and I_Relation_ID = 1			
		END
		ELSE 
		BEGIN			
			INSERT INTO [dbo].[T_ERP_Enquiry_Regn_Guardian_Master]	
			(
				I_Enquiry_Regn_ID,
				I_Relation_ID,
				S_Mobile_No,
				S_First_Name,
				S_Middile_Name,
				S_Last_Name,
				S_Guardian_Email,
				I_Qualification_ID,
				I_Occupation_ID,
				S_Company_Name,
				S_Designation,
				I_Income_Group_ID,
				S_Profile_Picture,
				Dt_CreatedAt,
				S_CreatedBy,
				I_Status
			)
			VALUES
			(
				@iEnquiryRegnID,
				1,
				@sFatherMobileNo,
				@sFatherFirstName,
				@sFatherMiddleName,
				@sFatherLastName,
				@sFatherEmailID,
				@iFatherQualification,
				@iFatherOccupation,
				@sFatherNameOfCompany,
				@sFatherDesignation,
				@iFatherIncome,
				@sFatherPhotoFilePath,
				GETDATE(),
				@iUpdatedBy,
				1
			)			
		END

		IF EXISTS (SELECT 1 FROM T_ERP_Enquiry_Regn_Guardian_Master where I_Enquiry_Regn_ID = @iEnquiryRegnID and I_Relation_ID = 2)
		BEGIN
			UPDATE [dbo].[T_ERP_Enquiry_Regn_Guardian_Master]
			SET	
				I_Relation_ID = 2,
				S_Mobile_No = @sMotherMobileNo,
				S_First_Name = @sMotherFirstName,
				S_Middile_Name = @sMotherMiddleName,
				S_Last_Name = @sMotherLastName,
				S_Guardian_Email = @sMotherEmailID,
				I_Qualification_ID = @iMotherQualification,
				I_Occupation_ID = @iMotherOccupation,
				S_Company_Name = @sMotherNameOfCompany,
				S_Designation = @sMotherDesignation,
				I_Income_Group_ID = @iMotherIncome,
				S_Profile_Picture = @sMotherPhotoFilePath,
				Dt_UpdatedAt = GETDATE()

			WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID and I_Relation_ID = 2		
		END
		ELSE 
		BEGIN			
			INSERT INTO [dbo].[T_ERP_Enquiry_Regn_Guardian_Master]
			(	
				I_Enquiry_Regn_ID,
				I_Relation_ID,
				S_Mobile_No,
				S_First_Name,
				S_Middile_Name,
				S_Last_Name,
				S_Guardian_Email,
				I_Qualification_ID,
				I_Occupation_ID,
				S_Company_Name,
				S_Designation,
				I_Income_Group_ID,
				S_Profile_Picture,
				Dt_CreatedAt,
				S_CreatedBy,
				I_Status
			)
			VALUES
			(
				@iEnquiryRegnID,
				2,
				@sMotherMobileNo,
				@sMotherFirstName,
				@sMotherMiddleName,
				@sMotherLastName,
				@sMotherEmailID,
				@iMotherQualification,
				@iMotherOccupation,
				@sMotherNameOfCompany,
				@sMotherDesignation,
				@iMotherIncome,
				@sMotherPhotoFilePath,
				GETDATE(),
				@iUpdatedBy,
				1
			)
		END

		IF EXISTS (SELECT 1 FROM T_ERP_Enquiry_Regn_Address where I_Enquiry_Regn_ID = @iEnquiryRegnID)
		BEGIN
			UPDATE [dbo].[T_ERP_Enquiry_Regn_Address]
			SET
				S_Address_Type = @sAddressType,
				S_Address1 = @sAddressLine1,
				S_Address2 = @sAddressLine2,
				S_Country_ID = @iCountry,
				S_State_ID = @iState,
				S_City_ID = @iCity,
				S_Pincode = @sPincode

			WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID 
		END
		ELSE
		BEGIN
			INSERT INTO [dbo].[T_ERP_Enquiry_Regn_Address]
			(
				I_Enquiry_Regn_ID,
				S_Address_Type,
				S_Address1,
				S_Address2,
				S_Country_ID,
				S_State_ID,
				S_City_ID,
				S_Pincode,
				I_Status
			)
			VALUES
			(
				@iEnquiryRegnID,
				@sAddressType,
				@sAddressLine1,
				@sAddressLine2,
				@iCountry,
				@iState,
				@iCity,
				@sPincode,
				1
			)
		END

		select 1 StatusFlag,'Guardian Details saved successfully' Message
		
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
