-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	GETS list for Software of a center
-- =============================================
CREATE PROCEDURE [NETWORK].[uspGetCenterSoftware]
	@iCenterID INT,
	@iSoftwareID INT = NULL
AS
BEGIN
	SET NOCOUNT OFF;
	
	SELECT I_Software_ID,I_Centre_Id,S_Act_Version,S_Act_License_No
	FROM NETWORK.T_Software_Detail
	WHERE I_Centre_Id = @iCenterID
		AND ISNULL(@iSoftwareID,I_Software_ID)= I_Software_ID
		AND I_Status <> 0
	
END
