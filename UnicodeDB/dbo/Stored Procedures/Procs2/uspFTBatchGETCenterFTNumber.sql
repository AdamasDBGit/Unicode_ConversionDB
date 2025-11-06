CREATE PROCEDURE [dbo].[uspFTBatchGETCenterFTNumber]
(
	@iCenterID int
)

AS
BEGIN

	SELECT ISNULL(MAX(I_Center_FT_ID),0) AS I_Center_FT_ID 
	FROM dbo.T_FT_History 
	WHERE I_Center_ID = @iCenterID
	AND DATEPART(yyyy,Dt_FT_Date) = DATEPART(yyyy,getdate())

END
