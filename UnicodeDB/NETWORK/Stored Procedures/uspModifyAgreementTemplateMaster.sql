-- =============================================
-- Author:		Debarshi Basu
-- Create date: 23/03/2007
-- Description:	Modifies the Agreement Template master table
-- =============================================
CREATE PROCEDURE [NETWORK].[uspModifyAgreementTemplateMaster] 

	@iTemplateID INT,
	@sTemplateCode VARCHAR(20),
	@iCountryID INT,
	@iDocumentID INT,
	@sCreatedBy VARCHAR(20),
	@dCreatedOn DATETIME,	
	@iFlag INT
AS
BEGIN TRY

	SET NOCOUNT OFF;

	IF(@iFlag=1)
		BEGIN
			INSERT INTO NETWORK.T_Agreement_Template_Master (
											S_Agreement_Template_Code,
											I_Country_ID,
											I_Document_ID,
											S_Crtd_By,
											Dt_Crtd_On,
											I_Status
											)
			VALUES (
					@sTemplateCode,
					@iCountryID,
					@iDocumentID,
					@sCreatedBy,	
					@dCreatedOn,
					1
					)

		END
	IF(@iFlag=2)
		BEGIN
			UPDATE NETWORK.T_Agreement_Template_Master SET
			S_Agreement_Template_Code = @sTemplateCode,
			I_Country_ID = @iCountryID,
			I_Document_ID = @iDocumentID,
			S_Upd_By = @sCreatedBy,
			Dt_Upd_On = @dCreatedOn
			WHERE I_Agreement_Template_ID = @iTemplateID
				AND I_Status = 1
		END

	IF(@iFlag=3)
		BEGIN
			UPDATE NETWORK.T_Agreement_Template_Master SET
			I_Status=0,
			S_Upd_By=@sCreatedBy,
			Dt_Upd_On=@dCreatedOn
			WHERE I_Agreement_Template_ID = @iTemplateID
				AND I_Status = 1
		END
	
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
