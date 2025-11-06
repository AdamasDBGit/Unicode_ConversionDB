-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	GETS list for all infrastructure details of a center
-- =============================================
CREATE PROCEDURE [NETWORK].[uspGetCenterInfrastructureDetails]
	@iCenterID INT	
AS
BEGIN
	SET NOCOUNT OFF;
	
	SELECT PM.S_Premise_Name,PD.S_Act_Spec,PD.S_Act_No,
			PM.S_Rec_No,PM.S_Rec_Spec
	FROM NETWORK.T_Premise_Details PD WITH(NOLOCK)
		INNER JOIN NETWORK.T_Premise_Master PM
		ON PD.I_Premise_ID = PM.I_Premise_ID
	WHERE PD.I_Centre_Id = @iCenterID
	
END
