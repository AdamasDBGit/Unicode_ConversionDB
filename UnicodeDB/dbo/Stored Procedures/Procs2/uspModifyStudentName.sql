/*****************************************************************************************************************
Created by: Debarshi Basu
Date: 25/27/2007
Description: Updates the student Name

******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspModifyStudentName]
(
	@iEnquiryID int,
	@sFirstName NVARCHAR(MAX),
	@sMiddleName NVARCHAR(MAX),
	@sLastName NVARCHAR(MAX)
)
AS
BEGIN TRY 

	UPDATE dbo.T_Enquiry_Regn_Detail
	SET S_First_Name = UPPER(@sFirstName),
		S_Middle_Name = UPPER(@sMiddleName),
		S_Last_Name = UPPER(@sLastName)
	WHERE I_Enquiry_Regn_ID = @iEnquiryID

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

