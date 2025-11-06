CREATE PROCEDURE [EOS].[uspActivateEmployeeBatch] 
(
	@iFacultyRoleID INT = NULL
)
AS

BEGIN TRY
BEGIN TRAN T1

	SET NOCOUNT ON;

	Declare @I_Process_ID_Max Int
	Declare @Comments Varchar(2000)
	Declare @Center_Name Varchar(500)
	Declare @Employee_Name Varchar(500)
	Declare @Role_Name Varchar(500)
	Declare @fnCheckEmployeeExamStatus Varchar(500)
	Declare @fnCheckEmployeeTrainingStatus Varchar(500)

	--Declare @I_Batch_Process_ID Int
	--Select @I_Batch_Process_ID=I_Batch_Process_ID From dbo.T_Batch_Master Where S_Batch_Process_Name='EMPLOYEE_ACTIVATION' And I_Status=1

	--Select @I_Process_ID_Max=ISNULL(Max(I_Process_ID),0)+1 From dbo.T_Batch_Log Where S_Batch_Process_Name='EMPLOYEE_ACTIVATION'
	
	DECLARE @iCount INT, @iRoleCounter INT, @sRoles VARCHAR(1000), @iEmpID INT, @iUserID INT,
			 @iActualRowCount INT, @iRoleRowCount INT, @iRoleID INT, @iCenterID INT, @iRolePassCount INT
	SET @iCount = 1
	SET @iRoleCounter = 1
	
	CREATE TABLE #tempEmployee
	(	
		ID INT IDENTITY(1,1),
		I_Emp_ID INT,
		I_User_ID INT,
		S_Employee_Roles VARCHAR(1000)		
	)
	
	CREATE TABLE #tempRoles
	(
		ID INT IDENTITY(1,1),
		I_Role_ID INT
	)
	
	INSERT INTO #tempEmployee
	SELECT	EMP.I_Employee_ID,
			U.I_User_ID,
			EOS.[fnEmployeeRoleDetails](EMP.I_Employee_ID)			
	FROM dbo.T_Employee_Dtls EMP WITH(NOLOCK)
	INNER JOIN dbo.T_User_Master U WITH(NOLOCK)
		ON U.I_Reference_ID = EMP.I_Employee_ID AND S_User_Type = 'CE'
	WHERE (EMP.I_Status = 2 OR EMP.I_Status = 6 OR EMP.I_Status = 3)--for Employees with status Active and Additional Roles Assigned
		AND EOS.[fnEmployeeRoleDetails](EMP.I_Employee_ID) <> [EOS].[fnUserRoleDetails](U.I_User_ID)
		AND LTRIM(RTRIM(EOS.[fnEmployeeRoleDetails](EMP.I_Employee_ID)))<>''
	
	SELECT @iActualRowCount = COUNT(ID) FROM #tempEmployee
	
	WHILE (@iCount <= @iActualRowCount)
	BEGIN
		SELECT	@sRoles = S_Employee_Roles,
				@iEmpID = I_Emp_ID,
				@iUserID = I_User_ID
		FROM #tempEmployee WHERE ID = @iCount
		
		SELECT @iCenterID = I_Centre_ID FROM dbo.T_Employee_Dtls WHERE I_Employee_ID = @iEmpID
		
		SET @sRoles = SUBSTRING(@sRoles,2,LEN(@sRoles) - 2)
		
		INSERT INTO #tempRoles
		SELECT * FROM dbo.fnString2Rows(@sRoles,',')
	
		SELECT @iRoleRowCount = COUNT(ID) FROM #tempRoles
		SET @iRolePassCount = 0
		
		WHILE (@iRoleCounter <= @iRoleRowCount)
		BEGIN
			SELECT @iRoleID = I_Role_ID FROM #tempRoles WHERE ID = @iRoleCounter
		
			SELECT @CENTER_NAME=S_CENTER_NAME FROM dbo.T_CENTRE_MASTER WHERE I_CENTRE_ID=@ICENTERID
			SELECT @Employee_Name=ISNULL(S_FIRST_NAME,'')+' '+ISNULL(S_MIDDLE_NAME,'')+' '+ISNULL(S_LAST_NAME,'') FROM dbo.T_EMPLOYEE_DTLS WHERE I_Employee_ID = @iEmpID
			SELECT @Role_Name=S_Role_Desc FROM dbo.T_Role_Master WHERE I_Role_ID=@iRoleID

			IF ((EOS.fnCheckEmployeeExamStatus(@iEmpID,@iRoleID,@iCenterID,@iFacultyRoleID) = 1) AND (EOS.fnCheckEmployeeTrainingStatus(@iEmpID,@iRoleID,@iFacultyRoleID) = 1))
				BEGIN
					UPDATE dbo.T_Employee_Dtls SET I_Status = 6, S_Upd_By = 'SYSTEM_BATCH', Dt_Upd_On = GETDATE() WHERE I_Employee_ID = @iEmpID
					UPDATE dbo.T_User_Master SET S_User_Type = 'CE', S_Upd_By = 'SYSTEM_BATCH', Dt_Upd_On = GETDATE() WHERE I_Reference_ID = @iEmpID AND S_User_Type NOT IN ('ST','EM')
	--				UPDATE dbo.T_User_Role_Details SET I_Status = 0 WHERE I_User_ID = @iUserID AND I_Role_ID = @iFacultyRoleID
				
					-------------------Update the User Role Table--------------------
					IF EXISTS(SELECT * FROM dbo.T_User_Role_Details	WHERE I_User_ID = @iUserID AND I_Role_ID = @iRoleID)
					BEGIN
						UPDATE	dbo.T_User_Role_Details
						SET		I_Status = 1, S_Upd_By = 'SYSTEM_BATCH', Dt_Upd_On = GETDATE()
						WHERE	I_User_ID = @iUserID
							AND	I_Role_ID = @iRoleID
					END
					ELSE
					BEGIN
						INSERT INTO dbo.T_User_Role_Details
							(	
								I_Role_ID, 
								I_User_ID,
								I_Status, 
								S_Crtd_By, 
								Dt_Crtd_On 
							)
						SELECT @iRoleID,@iUserID,1,'SYSTEM_BATCH',GETDATE()
					END
										
					Set @Comments=@Center_Name+'('+cast(@iCenterID as varchar)+')> '+@Employee_Name+'('+cast(@iUserID as varchar)+')> '+@Role_Name+'('+cast(@iRoleID as varchar)+') - Activated'
					--EXEC uspWriteBatchProcessLog_New @I_Process_ID_Max,'EMPLOYEE_ACTIVATION',@Comments,'Success',0
					
					SET @iRolePassCount = @iRolePassCount + 1
				END
			ELSE
				BEGIN
					IF(EOS.fnCheckEmployeeExamStatus(@iEmpID,@iRoleID,@iCenterID,@iFacultyRoleID) = 0)
					BEGIN
						SET @fnCheckEmployeeExamStatus='Exam Not Cleared'
					END

					IF(EOS.fnCheckEmployeeTrainingStatus(@iEmpID,@iRoleID,@iFacultyRoleID) = 0)
					BEGIN
						SET @fnCheckEmployeeTrainingStatus='Training nor Cleared'
					END
					
					Set @Comments=@Center_Name+'('+cast(@iCenterID as varchar)+')> '+@Employee_Name+'('+cast(@iUserID as varchar)+')> '+@Role_Name+'('+cast(@iRoleID as varchar)+') - Not Activated because '+@fnCheckEmployeeExamStatus+','+@fnCheckEmployeeTrainingStatus
					--EXEC uspWriteBatchProcessLog_New @I_Process_ID_Max,'EMPLOYEE_ACTIVATION',@Comments,'Faliure',0
				END
								
			SET @iRoleCounter = @iRoleCounter + 1
		END
		
		IF (@iRoleRowCount = @iRolePassCount)
		BEGIN
			UPDATE dbo.T_Employee_Dtls SET I_Status = 3, S_Upd_By = 'SYSTEM_BATCH', Dt_Upd_On = GETDATE() WHERE I_Employee_ID = @iEmpID
		END
		
		TRUNCATE TABLE #tempRoles
		SET @iRoleCounter = 1
		SET @iCount = @iCount + 1
	END
	
	TRUNCATE TABLE #tempEmployee
	
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
