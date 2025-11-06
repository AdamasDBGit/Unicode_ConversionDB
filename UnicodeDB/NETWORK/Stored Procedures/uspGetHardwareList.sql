-- =============================================
-- Author:		Debarshi Basu
-- Create date: 22/03/2007
-- Description:	Get the List of all Hardware Items
-- =============================================

CREATE PROCEDURE [NETWORK].[uspGetHardwareList]
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT I_Hardware_ID,
			I_Brand_ID,
			I_Plan_ID,
			S_Hardware_Item,
			S_Rec_Spec,
			S_Rec_No,
			I_Status
	FROM NETWORK.T_Hardware_Master
	WHERE   I_Status = 1
	
END
