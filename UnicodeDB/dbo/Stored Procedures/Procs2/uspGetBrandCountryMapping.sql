-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: 30/12/2006
-- Description:	Loads the association of Brand and Country
-- =============================================
CREATE PROCEDURE [dbo].[uspGetBrandCountryMapping] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

	SELECT A.I_BCD_Brand_Country_Detail_ID, A.I_BCD_Brand_ID, A.I_BCD_Country_ID, A.I_BCD_Country_Group_ID,
	B.S_CNM_Country_Name, B.S_CNM_Country_Code, C.S_TBM_Brand_Code, C.S_TBM_Brand_Name
	FROM dbo.T_Brand_Country_Details A, dbo.T_Country_Master B, dbo.T_Brand_Master C
	WHERE A.I_BCD_Country_ID = B.I_CNM_Country_ID
	AND A.I_BCD_Brand_ID = C.I_TBM_Brand_ID
END
