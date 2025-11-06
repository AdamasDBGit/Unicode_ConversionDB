

CREATE PROCEDURE [dbo].[uspUpdateEnquiryLanguageDetails] 
	-- Add the parameters for the stored procedure here
	@iEnquiryID INT,
	@iEnquiryStatus INT = NULL 

AS
 BEGIN TRY
	
	DECLARE @LanguageID INT,@LanguageName VARCHAR(200)
	select Top 1 @LanguageID=I_Language_ID,@LanguageName=I_Language_Name from T_course_Master
	where I_Course_ID in (select TOP 1 I_Course_ID from T_Enquiry_Course where I_Enquiry_Regn_ID=@iEnquiryID)

	if exists (select * from T_Student_Tags where I_Enquiry_Regn_ID=@iEnquiryID)

	BEGIN

		update T_Student_Tags set I_Language_ID=@LanguageID,I_Language_Name=@LanguageName,I_Enquiry_Status_Code=@iEnquiryStatus
		where I_Enquiry_Regn_ID=@iEnquiryID
	
	END

	if exists (select * from ECOMMERCE.T_Registration_Enquiry_Map where EnquiryID=@iEnquiryID)

	BEGIN

		update ECOMMERCE.T_Registration_Language_Map set I_Language_ID=@LanguageID,I_Language_Name=@LanguageName 
		where RegID in (select RegID from ECOMMERCE.T_Registration_Enquiry_Map where EnquiryID=@iEnquiryID)

	END


END TRY

BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRANSACTION 
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
