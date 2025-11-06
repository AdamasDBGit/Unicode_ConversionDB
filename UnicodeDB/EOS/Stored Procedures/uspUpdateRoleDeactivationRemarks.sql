/**************************************************************************************************************
Created by  : Sandeep Acharyya
Date		: 01.05.2007
Description : This SP save will update the Remarks for Deactivation of Role
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspUpdateRoleDeactivationRemarks]
(
	@iEmployeeID INT,
	@sRoleIDs VARCHAR(500) = NULL,
	@sRemarks VARCHAR(1000),
	@sUpdatedBy VARCHAR(20),
	@DtUpdatedOn DATETIME
)
AS
BEGIN
	UPDATE dbo.T_Employee_Dtls
	SET		S_Remarks = @sRemarks,
			S_Upd_By = @sUpdatedBy,
			Dt_Upd_On = @DtUpdatedOn
	WHERE	I_Employee_ID = @iEmployeeID
	
	IF (@sRoleIDs IS NOT NULL)
	BEGIN
		DECLARE @TempRoles TABLE
		(
			EmpID INT,
			RoleID INT,
			Status INT
		)
		
		INSERT INTO @TempRoles (RoleID)
		SELECT * FROM  dbo.fnString2Rows(@sRoleIDs,',')
		
		UPDATE @TempRoles
		SET EmpID=@iEmployeeID,Status=1
	
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
	
	END
END
