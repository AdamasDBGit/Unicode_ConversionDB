/**************************************************************************************************************
Created by  : Swagata De
Date		: 09.05.2007
Description : This SP will save the new question bank pool mapping
Parameters  : 
Returns     : 
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspSaveBankPoolMapping]
	(
		@iQuestionBankID INT,
		@sQuestionPoolXML XML ,
		@sCreatedBy VARCHAR(20),
		@DtCreatedOn DATETIME ,
		@sUpdatedBy VARCHAR(20),
		@DtUpdatedOn DATETIME 
		
	)
AS

BEGIN TRY
	SET NOCOUNT ON;	
	DECLARE
	@AdjPosition SMALLINT, 
	@AdjCount SMALLINT,
	@KeyValueXml XML ,
	@iQPoolID INT, 
    @sQPoolDesc VARCHAR(200)
    
    DELETE FROM EXAMINATION.T_Bank_Pool_Mapping 
	WHERE I_Question_Bank_ID=@iQuestionBankID
	
	SET @AdjPosition = 1
	SET @AdjCount = @sQuestionPoolXML.value('count((QPoolList/QPool))','int')
	
	WHILE(@AdjPosition<=@AdjCount)
	BEGIN		
		--Get the Adjustment node for the Current Position
			SET @KeyValueXml = @sQuestionPoolXML.query('/QPoolList/QPool[position()=sql:variable("@AdjPosition")]')
			SELECT	@iQPoolID = T.a.value('@I_Pool_ID','int'),
					@sQPoolDesc = T.a.value('@S_Pool_Desc','varchar(200)')		
			FROM @KeyValueXml.nodes('/QPool') T(a)
			
			--Add the new mapping entries
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
		SET @AdjPosition = @AdjPosition + 1		
	
  END
	
	
	
	
		 
END TRY	
	
BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
