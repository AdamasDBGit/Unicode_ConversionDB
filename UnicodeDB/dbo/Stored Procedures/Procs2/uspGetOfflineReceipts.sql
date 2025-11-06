-- =============================================
-- Author:		Swagatam Sarkar	
-- Create date: 07/06/2007
-- Description:	Gets all unreconciled receipts
-- =============================================
CREATE PROCEDURE [dbo].[uspGetOfflineReceipts] 

AS
BEGIN

	SET NOCOUNT OFF;

	SELECT *
	FROM  dbo.T_Center_Receipt
	WHERE I_Status=1
	AND I_Flag_IsAdjusted = 0
	ORDER BY S_Student_ID
	 
	
END
