CREATE PROCEDURE [EXAMINATION].[uspSaveFacultyMarks]
(
	@iExamComponentID INT,
	@iEmployeeID INT,
	@N_Marks INT,
	@B_Has_Passed BIT,
	@sCreatedBy VARCHAR(20),
	@dtCreatedOn DATETIME
)
AS

BEGIN TRY 
	
	INSERT INTO EOS.T_Employee_Exam_Result
	(I_Employee_ID,I_Exam_Component_ID,I_No_Of_Attempts,N_Marks,B_Passed,S_Crtd_By,Dt_Crtd_On)	
	values
	(@iEmployeeID,@iExamComponentID,1,@N_Marks,@B_Has_Passed,@sCreatedBy,@dtCreatedOn)

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
