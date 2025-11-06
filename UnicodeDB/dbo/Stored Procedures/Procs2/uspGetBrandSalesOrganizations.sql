-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: 27/02/2007
-- Description:	Selects All the Sales Organization Brand Mapping 
-- =============================================

CREATE PROCEDURE [dbo].[uspGetBrandSalesOrganizations] 

AS
BEGIN

	SELECT A.I_Hierarchy_Brand_ID,
		   A.I_Hierarchy_Master_ID,
		   A.I_Brand_ID,
		   A.I_Status,
		   A.Dt_Valid_From,
		   A.Dt_Valid_To,
		   B.S_Brand_Code,
		   B.S_Brand_Name
	FROM dbo.T_Hierarchy_Brand_Details A, dbo.T_Brand_Master B
	WHERE A.I_Status <> 0
	AND B.I_Status <> 0
	AND GETDATE() >= ISNULL(A.Dt_Valid_From,GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To,GETDATE())
	AND A.I_Brand_ID = B.I_Brand_ID

END
