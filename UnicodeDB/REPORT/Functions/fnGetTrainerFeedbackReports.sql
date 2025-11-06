-- =============================================
-- Author:		Arindam Roy
-- Create date: '07/20/2007'
-- Description:	This Function return a Numeric Value of Trainer Feedback with respect to Feedback Group
-- =============================================
CREATE FUNCTION [REPORT].[fnGetTrainerFeedbackReports]
(
	@iTrainingID INT,
	@iParticipantID INT,
	@iFeedbackGroupID INT
)

RETURNS  NUMERIC(8,2)

AS 

BEGIN

	DECLARE @TempTrainingFeedback TABLE
	(
		I_Feedback_Group_ID INT,
		Feedback NUMERIC(18,2)
	)

	DECLARE @TrainingFeedbackID INT
	DECLARE @AvgFeedbackTrainer NUMERIC(8,2)


	 SELECT @TrainingFeedbackID=I_Training_Feedback_ID
	   FROM	ACADEMICS.T_Training_Feedback
	  WHERE I_Training_ID=@iTrainingID
		AND Feedback_Provided_UserId=@iParticipantID
		AND I_Feedback_Type_ID=2


	INSERT INTO @TempTrainingFeedback
	 SELECT FM.I_Feedback_Group_ID,
			CASE FOM.S_Feedback_Option_Name
				WHEN 'Excellent' then 4.0
				WHEN 'Good' then 3.0
				WHEN 'Average' then 2.0
				ELSE 1.0
			END AS Feedback
	   FROM ACADEMICS.T_Training_Feedback_Details TFD
			INNER JOIN ACADEMICS.T_Feedback_Option_Master FOM
				ON TFD.I_Feedback_Option_Master_ID=FOM.I_Feedback_Option_Master_ID
			INNER JOIN ACADEMICS.T_Feedback_Master FM
				ON FOM.I_Feedback_Master_ID=FM.I_Feedback_Master_ID
	  WHERE I_Training_Feedback_ID=@TrainingFeedbackID
		AND I_Feedback_Group_ID=@iFeedbackGroupID


	 SELECT @AvgFeedbackTrainer=AVG(Feedback)
	   FROM @TempTrainingFeedback

	RETURN @AvgFeedbackTrainer;

END