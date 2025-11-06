CREATE PROCEDURE [EOS].[uspActivateEmployee]
(
	@iEmployeeID INT,
	@eStatus INT,
	@dtStartDate DATETIME,
	@dtEndDate DATETIME,
	@dtActivationDate DATETIME,
	@sUpdatedBy VARCHAR(20),
	@DtUpdatedOn DATETIME
)
AS
BEGIN
	UPDATE dbo.T_Employee_Dtls
	SET	I_Status = @eStatus,
		Dt_Start_Date = @dtStartDate,
		Dt_End_Date = @dtEndDate,
		Dt_Activation_Date = @dtActivationDate,
		S_Upd_By = @sUpdatedBy,
		Dt_Upd_On = @DtUpdatedOn
	WHERE I_Employee_ID = @iEmployeeID
	

	UPDATE dbo.T_User_Master
	SET I_Status = 1
	WHERE I_Reference_ID = @iEmployeeID
	AND S_User_Type NOT IN ('ST','EM') 


	EXEC [LMS].[uspInsertTeacherDetailsForInterface] @iEmployeeID,'ADD'

END
