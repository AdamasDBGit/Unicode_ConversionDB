-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/06/2007
-- Description:	Get the fee sharing percentage for all receipt types
-- =============================================

CREATE PROCEDURE [dbo].[uspGetReceiptTypeFeeSharingAll]

AS
BEGIN
	
	SELECT E.I_Fee_Sharing_OnAccount_ID,ISNULL(E.I_Country_ID,0) AS I_Country_ID,A.S_Country_Name,
			ISNULL(E.I_Brand_ID,0) AS I_Brand_ID,
			ISNULL(E.I_Center_ID,0) AS I_Center_ID,B.S_Center_Name,
			ISNULL(E.I_Receipt_Type,0) AS I_Receipt_Type,			
			E.N_Company_Share,E.Dt_Period_Start,E.Dt_Period_End,
			E.S_Crtd_By,E.S_Upd_By,E.Dt_Crtd_On,E.Dt_Upd_On
	FROM dbo.T_Fee_Sharing_OnAccount E
	LEFT OUTER JOIN dbo.T_Country_Master A
	ON E.I_Country_ID = A.I_Country_ID	
	LEFT OUTER JOIN dbo.T_Centre_Master B
	ON E.I_Center_ID = B.I_Centre_Id
	WHERE E.I_Status = 1

END
