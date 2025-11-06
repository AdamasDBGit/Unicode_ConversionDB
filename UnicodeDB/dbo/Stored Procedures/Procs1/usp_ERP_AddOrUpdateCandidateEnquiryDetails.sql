-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_AddOrUpdateCandidateEnquiryDetails]
(
	@iEnquiryRegnID int = NULL,
	@sFirstName NVARCHAR(MAX) = NULL,
	@sMiddleName NVARCHAR(MAX) = NULL,
	@sLastName NVARCHAR(MAX) = NULL,
	@iGender int = NULL,
	@DtBirthDate date = NULL,
	@sMobileNo NVARCHAR(MAX) = NULL,
	@iBloodGroup int = NULL,
	@iNativeLanguage int = NULL,
	@iNationality int = NULL,
	@iReligion int = NULL,
	@iCaste int = NULL,
	@sEmail NVARCHAR(MAX) = NULL,
	@sCandidatePhotoPath NVARCHAR(MAX) = NULL,
	@iUpdatedBy int = NULL
)
AS
begin transaction
BEGIN
	BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		IF @sCandidatePhotoPath IS NULL
		BEGIN
			SET @sCandidatePhotoPath = (SELECT S_Student_Photo FROM T_ERP_Enquiry_Regn_Detail WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID)
		END
    -- Insert statements for procedure here
		UPDATE [dbo].[T_ERP_Enquiry_Regn_Detail]
		SET		
			S_First_Name = @sFirstName,
			S_Middle_Name = @sMiddleName,
			S_Last_Name = @sLastName,
			I_Gender_ID = @iGender,
			Dt_Birth_Date = @DtBirthDate,
			S_Mobile_No = @sMobileNo,
			I_Blood_Group_ID = @iBloodGroup,
			I_Native_Language_ID = @iNativeLanguage,
			I_Nationality_ID = @iNationality,
			I_Religion_ID = @iReligion,
			I_Caste_ID = @iCaste,
			S_Email_ID = @sEmail,
			S_Student_Photo = @sCandidatePhotoPath,
			S_Upd_By = @iUpdatedBy,
			Dt_Upd_On = GETDATE(),
			Enquiry_Crtd_By = @iUpdatedBy,
			Enquiry_Date = GETDATE()

		WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID


		IF @@ROWCOUNT > 0
		BEGIN
			select 1 StatusFlag,'Candidate details saved successfully' Message
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

