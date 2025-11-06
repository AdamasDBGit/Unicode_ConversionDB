CREATE PROCEDURE [EOS].[uspDeactivateEmployee]
(
	@iEmployeeID INT,
	@eStatus INT,
	@sRemarks VARCHAR(1000),
	@dtDeactivationDate DATETIME,
	@sUpdatedBy VARCHAR(20),
	@DtUpdatedOn DATETIME
)
AS
BEGIN
	UPDATE dbo.T_Employee_Dtls
	SET	I_Status = @eStatus,
		S_Remarks = @sRemarks,
		Dt_Resignation_Date = @dtDeactivationDate,
		S_Upd_By = @sUpdatedBy,
		Dt_Upd_On = @DtUpdatedOn
	WHERE I_Employee_ID = @iEmployeeID
	
		UPDATE dbo.T_User_Master
	SET I_Status = 0
	WHERE I_Reference_ID = @iEmployeeID
	AND S_User_Type NOT IN ('ST','EM')

END
