-- =============================================
-- Author:		Debarshi Basu
-- Create date: 22/03/2007
-- Description:	Get the List of all StartUp Items
-- =============================================

CREATE PROCEDURE [NETWORK].[uspGetStartUpList]
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT I_Startup_Kit_ID,
			I_Brand_ID,
			I_Plan_ID,
			S_Material_Item,
			S_Rec_Spec,
			S_Rec_No,
			I_Status
	FROM NETWORK.T_Startup_Kit_Master
	WHERE   I_Status = 1
	
END
