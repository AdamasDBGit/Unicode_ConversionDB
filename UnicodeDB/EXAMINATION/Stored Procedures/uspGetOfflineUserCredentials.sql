/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 03.05.2007
Description : This SP will retrieve all the User Details associated with a particular center
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspGetOfflineUserCredentials]
	@iCenterID INT
AS

BEGIN
	SET NOCOUNT ON;	
	SELECT UM.I_User_ID,UM.S_Title,UM.S_First_Name,UM.S_Middle_Name,UM.S_Last_Name,UM.S_Login_ID,UM.S_Password,
		UM.I_Reference_ID,UM.S_User_Type
	FROM dbo.T_User_Master UM WITH(NOLOCK)
		INNER JOIN dbo.T_User_Hierarchy_Details UHD WITH(NOLOCK)
		ON UM.I_User_ID = UHD.I_User_ID
		INNER JOIN dbo.T_Center_Hierarchy_Details CHD WITH(NOLOCK)
		ON CHD.I_Hierarchy_Detail_ID = UHD.I_Hierarchy_Detail_ID
	WHERE CHD.I_Hierarchy_Master_ID = UHD.I_Hierarchy_Master_ID
		AND CHD.I_Center_Id = @iCenterID
		AND CHD.I_Status = 1
		AND UHD.I_Status = 1
		AND UM.I_Status = 1

END
