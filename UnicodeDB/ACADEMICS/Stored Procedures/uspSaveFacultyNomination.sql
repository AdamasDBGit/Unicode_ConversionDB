/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 08/05/2007
Description:Saves the Faculties that have been nominated for a particular training at a center
Parameters: sNominationXML
******************************************************************************************************************/
CREATE PROCEDURE [ACADEMICS].[uspSaveFacultyNomination]
(
	@sNominationXML XML
)
AS

BEGIN TRY 

	DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT 
	DECLARE @sNominationDetailsXML XML, @EmployeesXML XML
	DECLARE @iCentreId INT, @iTrainingId INT, @iEmployeeId INT
	DECLARE @sCreatedBy VARCHAR(20)
	DECLARE @dtCreatedOn DATETIME
	DECLARE @cAttended CHAR(1),@cApproved CHAR(1),@cFeedbackProvided CHAR(1),@cFeedbackReceived CHAR(1)
	
	SET @AdjPosition = 1
	SET @sNominationDetailsXML= @sNominationXML.query('/Nomination[position()=sql:variable("@AdjPosition")]')
	SELECT  @iTrainingId = T.b.value('@I_Training_ID','int'),
			@sCreatedBy = T.b.value('@S_Created_By','varchar(20)'),
			@dtCreatedOn = T.b.value('@Dt_Created_On','datetime')
	FROM @sNominationDetailsXML.nodes('/Nomination') T(b)
	
	SET @AdjCount = @sNominationXML.value('count((Nomination/Employee))','int')
	WHILE(@AdjPosition<=@AdjCount)	
		BEGIN
			SET @EmployeesXML = @sNominationXML.query('/Nomination/Employee[position()=sql:variable("@AdjPosition")]')
			SELECT	@iEmployeeId = T.a.value('@I_Employee_ID','int'),
					@iCentreId = T.a.value('@I_Centre_ID','int'),
					@cAttended = T.a.value('@C_Attended','char(1)'),
					@cApproved = T.a.value('@C_Approved','char(1)'),
					@cFeedbackProvided = T.a.value('@C_Feedback_Provided','char(1)'),
					@cFeedbackReceived = T.a.value('@C_Feedback_Received','char(1)')
			FROM @EmployeesXML.nodes('/Employee') T(a)
			
			IF NOT EXISTS(SELECT I_Faculty_Nomination_ID FROM ACADEMICS.T_Faculty_Nomination
				WHERE I_Centre_Id = @iCentreId
				AND I_Training_ID = @iTrainingId
				AND I_Employee_ID = @iEmployeeId)
			BEGIN	 
				INSERT INTO 
					ACADEMICS.T_Faculty_Nomination
					(
						I_Centre_Id,
						I_Training_ID,
						I_Employee_ID,
						C_Attended,
						C_Approved,
						S_Crtd_By,
						Dt_Crtd_On,
						C_Feedback_Provided,
						C_Feedback_Received
					)
				VALUES
					(
						@iCentreId,
						@iTrainingId,
						@iEmployeeId,
						@cAttended,
						@cApproved,
						@sCreatedBy,
						@dtCreatedOn,
						@cFeedbackProvided,
						@cFeedbackReceived
					)
			END		
			SET @AdjPosition=@AdjPosition+1
		END		
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
