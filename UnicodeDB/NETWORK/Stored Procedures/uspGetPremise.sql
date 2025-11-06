-- =============================================
-- Author:		Debarshi Basu
-- Create date: 22/03/2007
-- Description:	Get the Details of a Premise
-- =============================================

CREATE PROCEDURE [NETWORK].[uspGetPremise]
	@iPremiseID INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT I_Premise_ID,
			I_Brand_ID,
			I_Plan_ID,
			S_Premise_Name,
			S_Rec_No,
			S_Rec_Spec,
			I_Status
	FROM NETWORK.T_Premise_Master
	WHERE   I_Status = 1
		AND I_Premise_ID = @iPremiseID
	
END
