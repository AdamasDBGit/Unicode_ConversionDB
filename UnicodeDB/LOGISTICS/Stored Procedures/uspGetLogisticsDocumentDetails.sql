/*
-- =================================================================
-- Author:sa
-- Create date:04/08/2007
-- Description:Get Kit Details From T_Kit_Master table
-- Parameter : 
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspGetLogisticsDocumentDetails]
(
	@iLogisticsID  INT = NULL
)
AS
BEGIN
	SELECT 
		ISNULL(LM.I_Logistics_ID, 0) AS I_Logistics_ID,
		ISNULL(LM.I_Document_ID, 0) AS I_Document_ID,
		ISNULL(UD.S_Document_Name,' ') AS S_Document_Name,
		ISNULL(UD.S_Document_Path,' ') AS S_Document_Path,
		ISNULL(UD.S_Document_Type,' ') AS S_Document_Type,
		ISNULL(UD.S_Document_URL,' ') AS S_Document_URL,
		ISNULL(UD.I_Document_ID,0) AS I_Document_ID

			FROM LOGISTICS.T_Logistics_Master LM
			LEFT OUTER JOIN  dbo.T_Upload_Document UD 
			ON    LM.I_Document_ID  = UD.I_Document_ID 
			WHERE I_Logistics_ID= @iLogisticsID
END
