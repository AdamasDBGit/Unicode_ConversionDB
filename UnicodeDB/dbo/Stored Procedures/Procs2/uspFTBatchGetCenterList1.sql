CREATE PROCEDURE [dbo].[uspFTBatchGetCenterList1]
AS

BEGIN
	SELECT CM.I_Centre_Id,CM.S_Center_Code,CM.S_Center_Name,
		ISNULL(CM.I_Is_OwnCenter,0) AS I_Is_OwnCenter,
		COU.I_Currency_ID,ISNULL(CM.S_SAP_Customer_Id,'') S_SAP_Customer_Id
	FROM dbo.T_Centre_Master CM
	INNER JOIN dbo.T_Country_Master COU
	ON CM.I_Country_ID = COU.I_Country_ID
END
