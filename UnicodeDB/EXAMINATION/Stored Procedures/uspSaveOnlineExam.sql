/**************************************************************************************************************
Created by  : Sandeep
Date		: 05.05.2007
Description : This SP will save the user response of the online exam
Parameters  : iExamComponentID
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspSaveOnlineExam]
(
	@iExamComponentID INT,
	@iEmployeeID INT = NULL,
	@DtTestDate DATETIME,
	@N_Marks NUMERIC(8,2),
	@B_Has_Passed BIT,
	@sAnswer XML = NULL,
	@sCreatedBy VARCHAR(20) = NULL,
	@sUpdatedBy VARCHAR(20) = NULL,
	@dtCreatedOn DATETIME = NULL,
	@dtUpdatedOn DATETIME = NULL
)
AS
BEGIN
	--INSERT INTO dbo.T_Enquiry_Test VALUES (@iExamComponentID,@iEnquiryRegnID,@DtTestDate,@N_Marks,@sAnswer)
	IF EXISTS(SELECT * FROM EOS.T_Employee_Exam_Result 
				WHERE I_Employee_ID= @iEmployeeID AND I_Exam_Component_ID = @iExamComponentID
				AND DATEDIFF(ss, Dt_Crtd_On, @DtTestDate) = 0)
	BEGIN
		UPDATE EOS.T_Employee_Exam_Result
			SET	I_No_Of_Attempts = ISNULL(I_No_Of_Attempts,0) + 1,
				N_Marks = @N_Marks,
				B_Passed = @B_Has_Passed,
				S_Answer_XML = @sAnswer,
				S_Upd_By = @sUpdatedBy,
				Dt_Upd_On = @dtUpdatedOn
		WHERE	I_Employee_ID = @iEmployeeID
			AND	I_Exam_Component_ID = @iExamComponentID
			AND DATEDIFF(ss, Dt_Crtd_On, @DtTestDate) = 0
	END
	ELSE
	BEGIN
		INSERT INTO EOS.T_Employee_Exam_Result
		(I_Employee_ID, I_Exam_Component_ID, I_No_Of_Attempts, N_Marks, B_Passed, S_Answer_XML,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On) 
		VALUES(@iEmployeeID,@iExamComponentID,1,@N_Marks,@B_Has_Passed,@sAnswer,@sCreatedBy,@sUpdatedBy,@dtCreatedOn,@dtUpdatedOn)
	END
END
