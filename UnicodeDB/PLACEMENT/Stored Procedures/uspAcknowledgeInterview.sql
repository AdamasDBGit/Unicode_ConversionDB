/*
-- =================================================================
-- Author:Ujjwal Sinha
-- Create date:17/05/2007 
-- Description:Update Employer Details record in T_Employer_Detail table 
-- =================================================================
*/
CREATE PROCEDURE [PLACEMENT].[uspAcknowledgeInterview]
   (
	@iShortlistedStudentID        INT    ,
        @cStudentAcknowledgement      CHAR(1) 
   )
AS
BEGIN TRY 
   DECLARE @iStudentID INT -- for trap student id   
   DECLARE @iCount INT -- For Currrent Acknowledge counter
--Update T_Shortlisted_Student
   UPDATE [PLACEMENT].T_Shortlisted_Students
      SET	C_Student_Acknowledgement = @cStudentAcknowledgement
      WHERE	  I_Shortlisted_Student_ID = @iShortlistedStudentID

-- Select student id
SET @iStudentID = (SELECT I_Student_Detail_ID FROM [PLACEMENT].T_Shortlisted_Students WHERE  I_Shortlisted_Student_ID = @iShortlistedStudentID)

--Get the current counter value
SET @iCount =(SELECT I_Acknowledgement_Count FROM [PLACEMENT].T_Placement_Registration WHERE I_Student_Detail_ID = @iStudentID )
 
-- Now update the T_Placement_Registration table for increase the counter 1 of I_Acknowledgement_Count
IF @cStudentAcknowledgement = 'R'
 BEGIN
	UPDATE [PLACEMENT].T_Placement_Registration
	SET I_Acknowledgement_Count= (@iCount + 1)
	WHERE I_Student_Detail_ID = @iStudentID    
 END     
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
