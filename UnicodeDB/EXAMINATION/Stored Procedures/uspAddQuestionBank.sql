/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP will add a new question bank in the question bank master table
Parameters  : 
Returns     : 
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspAddQuestionBank]
	(
		@iBrandID INT,
		@sQuestionBankDesc VARCHAR(200),
		@sCreatedBy VARCHAR(20) ,
		@DtCreatedOn DATETIME ,
		@sUpdatedBy VARCHAR(20),
		@DtUpdatedOn DATETIME 
		
	)
AS

BEGIN TRY
	SET NOCOUNT ON;
	INSERT INTO EXAMINATION.T_Question_Bank_Master 
	(
		I_Brand_ID,
		S_Bank_Desc,
		I_Status,
		S_Crtd_By,
		S_Upd_By,
		Dt_Crtd_On,
		Dt_Upd_On
	)
	VALUES
	(
		@iBrandID,
		@sQuestionBankDesc,
		1,
		@sCreatedBy,
		@sUpdatedBy,
		@DtCreatedOn,
		@DtUpdatedOn
	)	
	
		 
END TRY	
	
BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
