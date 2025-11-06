CREATE PROCEDURE [dbo].[uspFetchTemporaryCHDetails]
(
@iCenterID INT,
@iRoleID INT
)
AS

BEGIN

SELECT tum.I_User_ID,
	   tum.S_Title,
	   tum.S_First_Name,
	   tum.S_Middle_Name,
	   tum.S_Last_Name,
	   tum.I_Reference_ID
FROM dbo.T_User_Master tum
INNER JOIN dbo.T_Employee_Dtls ted
ON tum.I_Reference_ID = ted.I_Employee_ID
INNER JOIN EOS.T_Employee_Role_Map term
ON ted.I_Employee_ID = term.I_Employee_ID
WHERE I_Centre_Id = @iCenterID
AND term.I_Role_ID = @iRoleID
AND tum.I_Status <>0
AND ted.I_Status <>0

END
