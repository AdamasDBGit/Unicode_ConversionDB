/*****************************************************************************************************************
Created by: Soumya Sikder
Date: 12/05/2007
Description:Saves the Feedback details for a Training Program and also for reactivating the student
Parameters: TrainingID,FeedbackTypeID, ProvidedUserID, ReceivedUserID, FeedbackOptionID, PreviousScore, NextScore,CreatedBy , CreatedOn
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [ACADEMICS].[uspSaveTrainingFeedback]
(
	@iTrainingID int,
	@iFeedbackTypeID int,
	@iProviderUserID int,
	@iReceiverUserID int = null,
	@dFeedbackDate datetime,
	@nPreTestScore numeric(8,2) = null,
	@nPostTestScore numeric(8,2) = null,
	@sComments varchar(2000) = null,
	@xFeedbackDetails xml,
	@sUser varchar(20),
	@dDate datetime
)
AS

BEGIN TRY 
	
	DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT
	DECLARE @iFeedbackID INT, @iFeedbackOptionID INT
	DECLARE @FeedbackOptionXML XML
	DECLARE @iEmployeeID INT, @iCenterID INT
	
	BEGIN TRAN T1
	
	---Inserting the Training Feedback Table
	INSERT INTO ACADEMICS.T_Training_Feedback
	(
		I_Training_ID,
		I_Feedback_Type_ID,
		Feedback_Provided_UserId,
		Feedback_Received_UserId,
		Dt_Feedback_Date,
		N_Previous_Score,
		N_Next_Score,
		S_Crtd_By,
		Dt_Crtd_On
	)
	VALUES
	(
		@iTrainingID,
		@iFeedbackTypeID,
		@iProviderUserID,
		@iReceiverUserID,
		@dFeedbackDate,
		@nPreTestScore,
		@nPostTestScore,
		@sUser,
		@dDate
	)

	SET @iFeedbackID = SCOPE_IDENTITY()
	
	COMMIT TRAN T1

	SET @AdjPosition = 1
	SET @AdjCount = @xFeedbackDetails.value('count((FeedbackType/FeedbackOption))','int')
	WHILE(@AdjPosition<=@AdjCount)	
	BEGIN
		SET @FeedbackOptionXML = @xFeedbackDetails.query('FeedbackType/FeedbackOption[position()=sql:variable("@AdjPosition")]')
		SELECT	@iFeedbackOptionID = T.a.value('@I_Feedback_Option_Master_ID','int')
		FROM @FeedbackOptionXML.nodes('/FeedbackOption') T(a)

		---Inserting into Training Feedback Option Deatails
		INSERT INTO ACADEMICS.T_Training_Feedback_Details
		(
			I_Training_Feedback_ID,
			I_Feedback_Option_Master_ID,
			S_Crtd_By,
			Dt_Crtd_On
		)
		VALUES
		(
			@iFeedbackID,
			@iFeedbackOptionID,
			@sUser,
			@dDate
		)
	
		SET @AdjPosition=@AdjPosition+1
	END	
	
	IF @iFeedbackTypeID = 2
	BEGIN
		SELECT @iCenterID = ED.I_Centre_Id, @iEmployeeID = UM.I_Reference_ID
		FROM dbo.T_User_Master UM
		INNER JOIN dbo.T_Employee_Dtls ED
		ON UM.I_Reference_ID = ED.I_Employee_ID
		AND UM.S_User_Type = 'CE'
		WHERE UM.I_User_ID = @iProviderUserID
		
		UPDATE Academics.T_Faculty_Nomination
		SET C_Feedback_Provided = 'Y',
		S_Upd_By = @sUser,
		Dt_Upd_On = @dDate
		WHERE I_Training_ID = @iTrainingID
		AND I_Centre_Id = @iCenterID
		AND I_Employee_ID = @iEmployeeID
	END
	ELSE IF @iFeedbackTypeID = 3
	BEGIN
		SELECT @iCenterID = ED.I_Centre_Id, @iEmployeeID = UM.I_Reference_ID
		FROM dbo.T_User_Master UM
		INNER JOIN dbo.T_Employee_Dtls ED
		ON UM.I_Reference_ID = ED.I_Employee_ID
		AND UM.S_User_Type = 'CE'
		WHERE UM.I_User_ID = @iReceiverUserID
		
		UPDATE Academics.T_Faculty_Nomination
		SET C_Feedback_Received = 'Y',
		S_Upd_By = @sUser,
		Dt_Upd_On = @dDate
		WHERE I_Training_ID = @iTrainingID
		AND I_Centre_Id = @iCenterID
		AND I_Employee_ID = @iEmployeeID
	END


END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
