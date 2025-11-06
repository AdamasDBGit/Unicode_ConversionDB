/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP will retrieve all the Role Details corresponding to an Employee
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspGetEmployeeRoleDetails]
(
	@iEmployeeID INT,
	@iUserID INT = NULL
)
AS
BEGIN

	IF (@iUserID IS NULL)
	BEGIN
	 	SELECT TERM.I_Role_ID,
			   TERM.I_Status_ID,
			   TRM.S_Role_Code,
			   TRM.S_Role_Desc,
			   TRM.S_Role_Type
		FROM EOS.T_Employee_Role_Map TERM WITH(NOLOCK)
		INNER JOIN dbo.T_Role_Master TRM WITH(NOLOCK)
		ON TERM.I_Role_ID = TRM.I_Role_ID
		WHERE TERM.I_Employee_ID= @iEmployeeID
	END
	ELSE
	BEGIN
		SELECT	TURD.I_Role_ID,
				TURD.I_Status AS I_Status_ID,
				TRM.S_Role_Code,
				TRM.S_Role_Desc,
				TRM.S_Role_Type
		FROM dbo.T_User_Role_Details TURD WITH(NOLOCK)
		INNER JOIN dbo.T_Role_Master TRM WITH(NOLOCK)
		ON TURD.I_Role_ID = TRM.I_Role_ID
		WHERE TURD.I_User_ID= @iUserID
	END
END
