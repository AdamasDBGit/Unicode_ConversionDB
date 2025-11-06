-- =============================================
-- Author:		Debarshi Basu
-- Create date: 22/03/2007
-- Description:	Get the List of all Software Items
-- =============================================

CREATE PROCEDURE [NETWORK].[uspGetSoftwareList]
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT I_Software_ID,
			I_Brand_ID,
			I_Plan_ID,
			S_Software_Name,
			S_Rec_Version,
			S_Rec_License_No,
			I_Status
	FROM NETWORK.T_Software_Master
	WHERE   I_Status = 1
	
END
