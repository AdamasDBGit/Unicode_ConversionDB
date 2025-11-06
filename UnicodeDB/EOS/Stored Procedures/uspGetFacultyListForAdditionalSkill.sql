CREATE PROCEDURE [EOS].[uspGetFacultyListForAdditionalSkill]
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
	INNER JOIN dbo.T_User_Role_Details URD
	ON TUM.I_User_ID = URD.I_User_ID AND URD.I_Status = 1
	INNER JOIN T_Role_Master RM
	ON RM.I_Role_ID = URD.I_Role_ID AND UPPER(RM.S_Role_Desc) = 'FACULTY'
	WHERE TED.I_Centre_Id = @iCenterID
	AND (TED.I_Status = 3 OR TED.I_Status = 6)
	AND TUM.S_User_Type <> 'ST' AND TUM.S_User_Type <> 'EM'
	ORDER BY TED.S_First_Name, ISNULL(TED.S_Middle_Name,''), TED.S_Last_Name
END
