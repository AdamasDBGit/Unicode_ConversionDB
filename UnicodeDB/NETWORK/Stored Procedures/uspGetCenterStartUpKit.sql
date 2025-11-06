-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	GETS list for StartUpKit of a center
-- =============================================
CREATE PROCEDURE [NETWORK].[uspGetCenterStartUpKit]
	@iCenterID INT,
	@iStartUpKitID INT = NULL
AS
BEGIN
	SET NOCOUNT OFF;
	
	SELECT I_Centre_Id,I_Startup_Kit_ID,S_Act_Spec,S_Act_No
	FROM NETWORK.T_Startup_Kit_Detail
	WHERE I_Centre_Id = @iCenterID
		AND ISNULL(@iStartUpKitID,I_Startup_Kit_ID) = I_Startup_Kit_ID
		AND I_Status <> 0
	
END
