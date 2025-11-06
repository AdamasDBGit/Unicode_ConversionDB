-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: 30/12/2006
-- Description:	Loads all the region zone country brand mapping
-- =============================================
CREATE PROCEDURE [dbo].[uspGetZoneRegionMapping] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

	SELECT  A.I_ZRD_Zone_Region_Detail_ID, A.I_ZRD_Rgn_ID, A.I_ZRD_Country_Zone_Detail_ID,
	B.I_CZD_Brand_Country_Detail_ID, B.I_CZD_Zone_Id,
	C.I_BCD_Country_ID, C.I_BCD_Brand_ID,
	D.S_RGM_Rgn_Code, D.S_RGM_Rgn_Name,
	E.S_ZNM_Zone_Code , E.S_ZNM_Zone_Name ,
	F.S_CNM_Country_Code , F.S_CNM_Country_Name ,
	G.S_TBM_Brand_Code , G.S_TBM_Brand_Name
	FROM dbo.T_Zone_Region_Details A, dbo.T_Country_Zone_Details B, 
	dbo.T_Brand_Country_Details C, dbo.T_Region_Master D,
	dbo.T_Zone_Master E, dbo.T_Country_Master F, dbo.T_Brand_Master G
	WHERE A.I_ZRD_Country_Zone_Detail_ID = B.I_CZD_Country_Zone_Detail_ID
	AND C.I_BCD_Brand_Country_Detail_ID = B.I_CZD_Brand_Country_Detail_ID
	AND D.I_RGM_Rgn_ID = A.I_ZRD_Rgn_ID
	AND B.I_CZD_Zone_Id = E.I_ZNM_Zone_Id
	AND C.I_BCD_Country_ID = F.I_CNM_Country_ID
	AND C.I_BCD_Brand_ID = G.I_TBM_Brand_ID
END
