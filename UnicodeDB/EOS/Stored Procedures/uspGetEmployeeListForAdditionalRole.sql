/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP will retrieve the employee list for a particular center for assigning additional roles
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspGetEmployeeListForAdditionalRole]
(	
 @iCenterID INT,
 @iStatus INT = NULL 
)
	
AS
BEGIN
	SELECT  TED.I_Employee_ID,
		TED.I_Centre_Id,
		TED.S_Title,
		TED.S_First_Name,
		TED.S_Middle_Name,
		TED.S_Last_Name,
		TUM.I_User_ID,
		TUM.S_Login_ID,
		TUM.S_User_Type,
		TED.I_Status
	FROM dbo.T_Employee_Dtls TED WITH(NOLOCK) 
	INNER JOIN dbo.T_User_Master TUM WITH(NOLOCK)
	ON TED.I_Employee_ID=TUM.I_Reference_ID
	WHERE TED.I_Centre_Id=@iCenterID
	--AND TED.I_Status = ISNULL(@iStatus, TED.I_Status)
	AND TUM.S_User_Type = 'CE'
	ORDER BY TED.S_First_Name, ISNULL(TED.S_Middle_Name,''), TED.S_Last_Name
END
