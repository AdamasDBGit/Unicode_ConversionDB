/*******************************************************
Description : Save E-Project FAQ
Author	:     Arindam Roy
Date	:	  05/29/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspPushQueryToFAQ] 
(
	@iQueryPostingID int,	
	@iEProjectSpecID int,
	@sQuestion varchar(8000),
	@sAnswer varchar(8000),
	@sUser varchar(20),
	@dDate datetime
)
AS

BEGIN TRY 

IF NOT EXISTS(SELECT * FROM ACADEMICS.T_FAQ_Details WHERE I_Query_Posting_ID = @iQueryPostingID )
BEGIN	

		INSERT INTO ACADEMICS.T_FAQ_Details
		(
			I_E_Project_Spec_ID,
			I_Query_Posting_ID,
			S_Question_Description,
			S_Answer_Description,
			I_Status,
			S_Crtd_By,
			Dt_Crtd_On
		)	
		VALUES
		(
			@iEProjectSpecID,
			@iQueryPostingID,
			@sQuestion,
			@sAnswer,
			1,
			@sUser,
			@dDate
		)
END
ELSE
BEGIN
	UPDATE ACADEMICS.T_FAQ_Details
	SET S_Answer_Description = @sAnswer,S_Upd_By = @sUser,Dt_Upd_On = @dDate
	WHERE I_Query_Posting_ID = @iQueryPostingID AND I_Status = 1
END
	
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
