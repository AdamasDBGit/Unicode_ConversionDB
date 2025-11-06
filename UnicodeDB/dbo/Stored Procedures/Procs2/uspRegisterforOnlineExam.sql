-- =============================================
-- Author:		Aritra Saha
-- Create date: 16/04/2007
-- Description:	Register a Student for Online Exam
-- =============================================
CREATE PROCEDURE [dbo].[uspRegisterforOnlineExam] 
	@iEnquiryID int,
	@dTestDate datetime,
	@iExamComponentID int

AS
BEGIN TRY

	SET NOCOUNT OFF
	
	IF EXISTS(SELECT * FROM T_Enquiry_Test WHERE I_Exam_Component_ID = @iExamComponentID AND I_Enquiry_Regn_ID = @iEnquiryID)
	 UPDATE T_Enquiry_Test SET Dt_Test_Date = @dTestDate WHERE I_Exam_Component_ID = @iExamComponentID AND I_Enquiry_Regn_ID = @iEnquiryID
    ELSE	
    BEGIN 
	INSERT INTO T_Enquiry_Test
	(
		I_Exam_Component_ID,
		I_Enquiry_Regn_ID,
		Dt_Test_Date	
	)
	VALUES 
	(
		@iExamComponentID,
		@iEnquiryID,
		@dTestDate
	)		
	END
 
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
