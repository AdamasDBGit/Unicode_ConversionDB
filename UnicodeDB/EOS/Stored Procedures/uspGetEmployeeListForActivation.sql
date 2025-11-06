CREATE PROCEDURE [EOS].[uspGetEmployeeListForActivation]
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
		AND (TED.I_Status = 2 OR TED.I_Status = 5 OR TED.I_Status = 6) -- 2 for Registered Users and 5 for Resigned Users
		AND TUM.S_User_Type <> 'ST' AND TUM.S_User_Type <> 'EM'
		ORDER BY TED.S_First_Name, ISNULL(TED.S_Middle_Name,''), TED.S_Last_Name
END
