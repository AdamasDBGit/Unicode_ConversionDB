CREATE PROCEDURE [dbo].[uspFTBatchGetCenterList] 
 
AS
BEGIN

	SELECT CM.I_Centre_Id,CM.S_Center_Code,CM.S_Center_Name,
		ISNULL(CM.I_Is_OwnCenter,0) AS I_Is_OwnCenter,
		COU.I_Currency_ID
	FROM dbo.T_Centre_Master CM
	INNER JOIN dbo.T_Country_Master COU
	ON CM.I_Country_ID = COU.I_Country_ID
--	WHERE CM.I_Status = 20
--	AND GETDATE() >= ISNULL(CM.Dt_Valid_From,GETDATE())
--	AND GETDATE() <= ISNULL(CM.Dt_Valid_To,GETDATE())

END
