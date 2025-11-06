CREATE PROCEDURE [EOS].[uspDeactivateEmployeeBatch]
AS

BEGIN TRY
BEGIN TRAN T1

	SET NOCOUNT ON;

	Declare @iActualRowCount Int
	Declare @iCount Int
	Declare @I_Process_ID_Max Int
	Declare @Comments Varchar(2000)
	Declare @Center_Name Varchar(500)
	Declare @iCenterID Int
	Declare @Employee_Name Varchar(500)
	Declare @iEmpID Int
	Select @I_Process_ID_Max=ISNULL(Max(I_Process_ID),0)+1 From dbo.T_Batch_Log Where S_Batch_Process_Name='EMPLOYEE_DEACTIVATION'

	Declare _Cursor CURSOR FOR
	SELECT I_Employee_ID,I_CENTRE_ID,ISNULL(S_FIRST_NAME,'')+' '+ISNULL(S_MIDDLE_NAME,'')+' '+ISNULL(S_LAST_NAME,'') As Employee_Name FROM dbo.T_Employee_Dtls WHERE I_Status = 2 AND DATEDIFF(dd, Dt_End_Date, GETDATE()) > 0
	
	OPEN _Cursor
	FETCH NEXT FROM _Cursor INTO @iEmpID,@iCenterID,@Employee_Name
	WHILE @@Fetch_Status=0
	BEGIN
		SELECT @CENTER_NAME=S_CENTER_NAME FROM dbo.T_CENTRE_MASTER WHERE I_CENTRE_ID =@iCenterID

		Set @Comments=@Center_Name+'('+cast(@iCenterID as varchar)+')> '+@Employee_Name+'('+cast(@iEmpID as varchar)+') - Deactivated'
		EXEC uspWriteBatchProcessLog @I_Process_ID_Max,'EMPLOYEE_DEACTIVATION',@Comments,'Success'

		FETCH NEXT FROM _Cursor INTO @iEmpID,@iCenterID,@Employee_Name
	END
	CLOSE _Cursor
	DEALLOCATE _Cursor

	UPDATE dbo.T_User_Master
	SET I_Status = 0
	WHERE I_Reference_ID IN 
	(
		SELECT I_Employee_ID 
		FROM dbo.T_Employee_Dtls
		WHERE I_Status = 2 -- 2 for Registered Users
			AND DATEDIFF(dd, Dt_End_Date, GETDATE()) > 0
	)
	AND S_User_Type NOT IN ('ST','EM')

	UPDATE dbo.T_Employee_Dtls
	SET I_Status = 4,
	Dt_DeactivationDate = getdate()
	WHERE I_Status = 2
	AND DATEDIFF(dd, Dt_End_Date, GETDATE()) > 0

COMMIT TRAN T1
END TRY

BEGIN CATCH
--Error occurred:
	ROLLBACK  TRAN T1
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
	@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
