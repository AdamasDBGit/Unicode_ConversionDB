/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP save all the Role Details corresponding to an Employee
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspSaveEmployeeRoleDetails]
(
	@iEmployeeID INT,
	@sRoleIDs VARCHAR(1000),
	@iStatus INT,
	@iEmpStatus INT = NULL
)

AS 
BEGIN TRY
	DECLARE @TempRoles TABLE
	(
		EmpID INT,
		RoleID INT,
		Status INT
	)
	
	INSERT INTO @TempRoles (RoleID)
	SELECT * FROM  dbo.fnString2Rows(@sRoleIDs,',')
	
	UPDATE @TempRoles
	SET EmpID=@iEmployeeID,Status=@iStatus
	
	DELETE FROM EOS.T_Employee_Role_Map
	WHERE I_Employee_ID = @iEmployeeID
	AND I_Role_ID NOT IN (SELECT RoleID FROM @TempRoles)
	
	UPDATE EOS.T_Employee_Role_Map
	SET EOS.T_Employee_Role_Map.I_Status_ID = Status
	FROM @TempRoles
	WHERE EOS.T_Employee_Role_Map.I_Employee_ID = EmpID
	
	INSERT INTO EOS.T_Employee_Role_Map
	(
		I_Employee_ID,
		I_Role_ID,
		I_Status_ID
	)
	SELECT * FROM @TempRoles 
		WHERE RoleID NOT IN 
		(SELECT I_Role_ID FROM EOS.T_Employee_Role_Map WHERE I_Employee_ID = @iEmployeeID)
		
	IF (@iEmpStatus IS NOT NULL)
	BEGIN
		UPDATE dbo.T_Employee_Dtls
		SET I_Status = @iEmpStatus
		WHERE I_Employee_ID = @iEmployeeID		
	END
	
END TRY

BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
