-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: 30/12/2006
-- Description:	Loads all the center region zone country brand mapping
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRegionCenterMapping] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

	SELECT A.I_RCD_Region_Center_Detail_ID, A.I_RCD_Centre_Id, A.I_RCD_Zone_Region_Detail_ID,
	B.I_ZRD_Rgn_ID, B.I_ZRD_Country_Zone_Detail_ID,
	C.I_CZD_Zone_Id, C.I_CZD_Brand_Country_Detail_ID,
	D.I_BCD_Country_ID, D.I_BCD_Brand_ID,
	E.S_CEM_Center_Code, E.S_CEM_Center_Name,
	F.S_RGM_Rgn_Code , F.S_RGM_Rgn_Name,
	G.S_ZNM_Zone_Code , G.S_ZNM_Zone_Name,
	H.S_CNM_Country_Code , H.S_CNM_Country_Name,
	I.S_TBM_Brand_Code , I.S_TBM_Brand_Name 
	FROM dbo.T_Region_Center_Details A, dbo.T_Zone_Region_Details B, 
	dbo.T_Country_Zone_Details C, dbo.T_Brand_Country_Details D, 
	dbo.T_Centre_Master E, dbo.T_Region_Master F,
	dbo.T_Zone_Master G, dbo.T_Country_Master H, dbo.T_Brand_Master I
	WHERE A.I_RCD_Zone_Region_Detail_ID = B.I_ZRD_Zone_Region_Detail_ID
	AND B.I_ZRD_Country_Zone_Detail_ID = C.I_CZD_Country_Zone_Detail_ID
	AND C.I_CZD_Brand_Country_Detail_ID = D.I_BCD_Brand_Country_Detail_ID
	AND A.I_RCD_Centre_Id = E.I_CEM_Centre_Id
	AND B.I_ZRD_Rgn_ID = F.I_RGM_Rgn_ID
	AND C.I_CZD_Zone_Id = G.I_ZNM_Zone_Id
	AND D.I_BCD_Country_ID = H.I_CNM_Country_ID
	AND D.I_BCD_Brand_ID = I.I_TBM_Brand_ID
END
