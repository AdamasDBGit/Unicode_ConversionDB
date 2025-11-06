/**************************************************************************************************************
Created by  : Swagata De
Date		: 09.05.2007
Description : This SP will add a new question pool in the master table and also 
			  create the bank pool mapping for the new question pool
Parameters  : 
Returns     : 
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspAddQuestionPool]
	(
		@iQuestionBankID INT,
		@iBrandID INT = NULL,
		@sQuestionPoolDesc VARCHAR(200) ,
		@sCreatedBy VARCHAR(20),
		@DtCreatedOn DATETIME ,
		@sUpdatedBy VARCHAR(20),
		@DtUpdatedOn DATETIME 
		
	)
AS

BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @iQPoolID INT
	INSERT INTO EXAMINATION.T_Pool_Master 
	(
		I_Brand_ID,
		S_Pool_Desc,
		I_Status,
		S_Crtd_By,
		S_Upd_By,
		Dt_Crtd_On,
		Dt_Upd_On
	)
	VALUES
	(
		@iBrandID,
		@sQuestionPoolDesc,
		1,
		@sCreatedBy,
		@sUpdatedBy,
		@DtCreatedOn,
		@DtUpdatedOn
	)	
	
	SET @iQPoolID= (SELECT SCOPE_IDENTITY())
	
	INSERT INTO EXAMINATION.T_Bank_Pool_Mapping 
	(
		I_Pool_ID,
		I_Question_Bank_ID,
		S_Crtd_By,
		S_Upd_By,
		Dt_Crtd_On,
		Dt_Upd_On
	)
	VALUES
	(
		@iQPoolID,
		@iQuestionBankID,
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
