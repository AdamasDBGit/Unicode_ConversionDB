-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/06/2007
-- Description:	Get the fee sharing percentage for all
-- =============================================
CREATE PROCEDURE [dbo].[uspGetFeeSharingAllDetails]

AS
BEGIN
	
	SELECT E.I_Fee_Sharing_ID,ISNULL(E.I_Country_ID,0) AS I_Country_ID,A.S_Country_Name,
			ISNULL(E.I_Brand_ID,0) AS I_Brand_ID,
			ISNULL(E.I_Center_ID,0) AS I_Center_ID,B.S_Center_Name,
			ISNULL(E.I_Course_ID,0) AS I_Course_ID,C.S_Course_Name,
			ISNULL(E.I_Fee_Component_ID,0) AS I_Fee_Component_ID,D.S_Component_Name,
			E.N_Company_Share,E.Dt_Period_Start,E.Dt_Period_End,
			E.S_Crtd_By,E.S_Upd_By,E.Dt_Crtd_On,E.Dt_Upd_On
	FROM dbo.T_Fee_Sharing_Master E
	LEFT OUTER JOIN dbo.T_Country_Master A
	ON E.I_Country_ID = A.I_Country_ID	
	LEFT OUTER JOIN dbo.T_Centre_Master B
	ON E.I_Center_ID = B.I_Centre_Id
	LEFT OUTER JOIN dbo.T_Course_Master C
	ON E.I_Course_ID = C.I_Course_ID
	LEFT OUTER JOIN dbo.T_Fee_Component_Master D
	ON E.I_Fee_Component_ID = D.I_Fee_Component_ID
	WHERE E.I_Status = 1

END
