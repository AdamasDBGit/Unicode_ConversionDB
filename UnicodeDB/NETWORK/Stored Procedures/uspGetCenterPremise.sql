-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	GETS list for premise of a center
-- =============================================
CREATE PROCEDURE [NETWORK].[uspGetCenterPremise]
	@iCenterID INT,
	@iPremiseID INT	= NULL
AS
BEGIN
	SET NOCOUNT OFF;
	
	SELECT I_Centre_Id,I_Premise_ID,S_Act_Spec,S_Act_No
	FROM NETWORK.T_Premise_Details
	WHERE I_Centre_Id = @iCenterID
		AND ISNULL(@iPremiseID,I_Premise_ID) = I_Premise_ID
		AND I_Status <> 0
		
END
