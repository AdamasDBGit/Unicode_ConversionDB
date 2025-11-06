/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP will retrieve the employee details for an employee
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspGetEmployeeDetails]
(	
 @iEmployeeID INT
)
	
AS
BEGIN
--Get the general details
	SELECT DISTINCT TED.I_Employee_ID,
		TED.I_Centre_Id,
		TED.S_Title,
		TED.S_First_Name,
		TED.S_Middle_Name,
		TED.S_Last_Name,
		TED.Dt_DOB,
		TED.S_Phone_No,
		TED.S_Email_ID,
		TED.Dt_Joining_Date,
		TED.I_Status,
		TUM.I_User_ID,
		TUM.S_Login_ID,
		TUM.S_User_Type,
		ISNULL(TED.I_Document_ID,0) AS I_Document_ID,
		ISNULL(UD.S_Document_Name,'') AS S_Document_Name,
		ISNULL(UD.S_Document_Type,'') AS S_Document_Type,
		ISNULL(UD.S_Document_Path,'') AS S_Document_Path,
		ISNULL(UD.S_Document_URL,'') AS S_Document_URL,
		ISNULL(TED.Is_Interview_Cleared, 0) AS Is_Interview_Cleared
FROM dbo.T_Employee_Dtls TED WITH(NOLOCK) 
INNER JOIN dbo.T_User_Master TUM WITH(NOLOCK)
ON TED.I_Employee_ID=TUM.I_Reference_ID
LEFT OUTER JOIN dbo.T_Upload_Document UD
	ON TED.I_Document_ID = UD.I_Document_ID
WHERE TED.I_Employee_ID=@iEmployeeID
AND TUM.S_User_Type <> 'ST' AND TUM.S_User_Type <> 'EM'


--Get the address details
SELECT  TEA.S_Address_Line1,
		TEA.S_Address_Line2,
		TEA.S_Zip_Code,
		TEA.S_District_Name,
		TEA.S_Address_Phone_No,
		TEA.I_Address_Type,
		TEA.I_Country_ID,
		TEA.I_State_ID,
		TEA.I_City_ID,
		TEA.I_Address_Type
FROM dbo.T_Employee_Dtls TED WITH(NOLOCK) 
INNER JOIN EOS.T_Employee_Address TEA WITH(NOLOCK)
ON TED.I_Employee_ID=TEA.I_Employee_ID
WHERE TED.I_Employee_ID=@iEmployeeID

END
