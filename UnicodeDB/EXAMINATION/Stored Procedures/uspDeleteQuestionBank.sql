/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP will delete an existing question bank
Parameters  : 
Returns     : 
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspDeleteQuestionBank]
	(
		@iQuestionBankID INT,
		@sUpdatedBy VARCHAR(20),
		@DtUpdatedOn DATETIME 
	) 
AS

BEGIN TRY
	SET NOCOUNT ON;
	UPDATE EXAMINATION.T_Question_Bank_Master
SET I_Status=0,S_Upd_By=@sUpdatedBy,Dt_Upd_On=@DtUpdatedOn
WHERE I_Question_Bank_ID =@iQuestionBankID
	
		 
END TRY	
	
BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
