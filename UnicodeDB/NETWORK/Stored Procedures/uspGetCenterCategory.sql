-- =============================================
-- Author:		Debarshi Basu
-- Create date: 06/06/2007
-- Description:	Get all the center categories
-- =============================================

CREATE PROCEDURE [NETWORK].[uspGetCenterCategory]

AS
BEGIN
	SET NOCOUNT ON;

	SELECT I_Center_Category_ID,
		S_Center_Category_Name
	FROM dbo.T_Center_Category_Master WITH(NOLOCK)
	WHERE   I_Status = 1
	
END
