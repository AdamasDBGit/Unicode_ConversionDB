-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	GETS list for Hardware of a center
-- =============================================
CREATE PROCEDURE [NETWORK].[uspGetCenterHardware]
	@iCenterID INT,
	@iHardwareID INT = NULL	
AS
BEGIN
	SET NOCOUNT OFF;
	
	SELECT I_Hardware_ID,I_Centre_Id,S_Act_Spec,S_Act_No
	FROM NETWORK.T_Hardware_Detail
	WHERE I_Centre_Id = @iCenterID
		AND ISNULL(@iHardwareID,I_Hardware_ID) = I_Hardware_ID
		AND I_Status <> 0
	
END
