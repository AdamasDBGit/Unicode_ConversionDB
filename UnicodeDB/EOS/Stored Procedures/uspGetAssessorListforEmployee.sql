/**************************************************************************************************************
Created by  : Swagata De
Date		: 26.06.2007
Description : This SP will retrieve the email ids for the assessors of a particualr role for an employee
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/
CREATE PROCEDURE [EOS].[uspGetAssessorListforEmployee]
(	
	@iEmployeeID INT
	
)	
AS
BEGIN 
	DECLARE
		@iUserID INT
		
		SET @iUserID = (SELECT TOP 1 I_User_ID FROM dbo.T_User_Master WHERE I_Reference_ID = @iEmployeeID AND S_User_Type <> 'ST')
		
		
	SELECT DISTINCT 
	TUM.S_Title,TUM.S_First_Name,TUM.S_Middle_Name,TUM.S_Last_Name,TUM.S_Email_ID,TUM.I_Reference_ID,TUM.I_user_ID,TUM.S_user_Type,
	ISNULL(TED.I_Employee_ID,0) AS I_Employee_ID
	FROM dbo.T_User_Master TUM 
	INNER JOIN dbo.T_User_Role_Details TURD WITH(NOLOCK)
	ON TUM.I_User_ID = TURD.I_User_ID
	LEFT OUTER JOIN dbo.T_Employee_Dtls TED WITH(NOLOCK)
	ON TED.I_Employee_ID = TUM.I_Reference_ID
			WHERE  TURD.I_Role_ID IN
				(
					SELECT I_Assessor_Role_ID
					FROM EOS.T_Role_Assessor TRA WITH (NOLOCK)
					INNER JOIN dbo.T_User_Role_Details TURD WITH (NOLOCK)
					ON TRA.I_Role_ID = TURD.I_Role_ID
					WHERE TURD.I_User_ID = @iUserID AND TURD.I_Status =1 --Active status
				)	
END
