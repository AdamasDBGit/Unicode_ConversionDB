/*
-- =================================================================
-- Author:Sanjay Mitra
-- Create date:06/21/2007 
-- Description:Insert Feedback record in T_Complaint_Feedback table 
-- =================================================================
*/
CREATE PROCEDURE [CUSTOMERCARE].[uspSaveFeedback]
(
		@iComplaintReqID	INT		,
		@iFeedbackID		INT,
		@sFeedbackBy		VARCHAR(50)	,
		@dtFeedbackDate		DATETIME	,
		@sRemarks			VARCHAR(2000),
		@sCrtdBy 			VARCHAR(20)	,
		@dtCrtdOn 			DATETIME,
		@iStatus	INT
)
AS
BEGIN TRY
DECLARE @iFeedback INT
SET @iFeedback = 0	

-- Insert record in  T_Complaint_Feedback Table
BEGIN TRANSACTION trnFeedBackAdd

INSERT INTO [CUSTOMERCARE].T_Complaint_Feedback
		(	
		I_Complaint_Req_ID	,
		I_Feedback_ID,
		S_Feedback_By	,
		Dt_Feedback_Date	,
		S_Remarks,
		S_Crtd_By		, 
		Dt_Crtd_On 
		)
	VALUES 
		(
		@iComplaintReqID	,
		@iFeedbackID,
		@sFeedbackBy		,
		@dtFeedbackDate		,
		@sRemarks,
		@sCrtdBy 		,
		@dtCrtdOn
		)
SET @iFeedback = SCOPE_IDENTITY()
SELECT @iFeedback 
IF(@iFeedback > 0)
   BEGIN 
		UPDATE CUSTOMERCARE.T_Complaint_Request_Detail
		SET I_Status_ID = @iStatus, 
			S_Upd_By = @sCrtdBy,
			Dt_Upd_On = @dtCrtdOn
		WHERE I_Complaint_Req_ID = @iComplaintReqID
		COMMIT TRANSACTION trnFeedBackAdd
	END
ELSE
  BEGIN
	ROLLBACK TRANSACTION trnFeedBackAdd
  END

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
