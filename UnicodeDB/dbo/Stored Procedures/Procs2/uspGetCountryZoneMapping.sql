-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: 30/12/2006
-- Description:	Loads all the zone country brand mapping
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCountryZoneMapping] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

	SELECT A.I_CZD_Country_Zone_Detail_ID, A.I_CZD_Brand_Country_Detail_ID, A.I_CZD_Zone_Id,
	B.I_BCD_Country_ID, B.I_BCD_Brand_ID, C.S_ZNM_Zone_Code , C.S_ZNM_Zone_Name, D.S_CNM_Country_Code , D.S_CNM_Country_Name,
	E.S_TBM_Brand_Code , E.S_TBM_Brand_Name 
	FROM dbo.T_Country_Zone_Details A, dbo.T_Brand_Country_Details B, 
	dbo.T_Zone_Master C, dbo.T_Country_Master D, dbo.T_Brand_Master E
	WHERE A.I_CZD_Brand_Country_Detail_ID = B.I_BCD_Brand_Country_Detail_ID
	AND A.I_CZD_Zone_Id = C.I_ZNM_Zone_Id
	AND B.I_BCD_Country_ID = D.I_CNM_Country_ID
	AND B.I_BCD_Brand_ID = E.I_TBM_Brand_ID
END
