-- ====================================================
-- Author:		Sandeep Acharyya
-- Create date: <03-05-2007	>
-- Description:	To Save the Training Feedback Form
-- ====================================================
CREATE PROCEDURE [EXAMINATION].[uspSaveTrainingFeedback]
	@iEmployeeID INT,
	@iTrainingID INT,
	@iDocumentID INT = NULL,
	@iFeedbackGiven INT = NULL
AS
BEGIN	
	IF EXISTS (SELECT 1 FROM EOS.T_Employee_Training_Details WHERE I_Employee_ID = @iEmployeeID
					AND I_Training_ID = @iTrainingID)
	BEGIN
		UPDATE EOS.T_Employee_Training_Details
		SET I_Document_ID = @iDocumentID,
			I_Feedback_Given = @iFeedbackGiven
		WHERE	I_Employee_ID = @iEmployeeID
			AND	I_Training_ID = @iTrainingID
	END
	ELSE
	BEGIN
		INSERT INTO EOS.T_Employee_Training_Details 
		(
			I_Employee_ID,I_Training_ID,I_Document_ID,I_Feedback_Given
		)
		VALUES
		(
			@iEmployeeID,@iTrainingID,@iDocumentID,@iFeedbackGiven
		)		
	END
END
