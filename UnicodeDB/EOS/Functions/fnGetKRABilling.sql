-- =============================================
-- Author:		Arindam Roy
-- Create date: '07/30/2007'
-- Description:	This Function return a Numeric Value of Billing KRA 
-- =============================================
CREATE FUNCTION [EOS].[fnGetKRABilling]
(
	@iEmployeeID INT,
	@iCurtrentMonth INT,
	@iCurtrentYear INT
)

RETURNS  NUMERIC(18,2)

AS 

BEGIN

	DECLARE @InvoiceAmount NUMERIC(18,2)

	 SELECT @InvoiceAmount=ISNULL(SUM(IP.N_Invoice_Amount),0.00)
	   FROM dbo.T_Invoice_Parent IP
			INNER JOIN dbo.T_User_Master UM
				ON IP.S_Crtd_By=UM.S_Login_ID
				AND UM.I_Reference_ID=@iEmployeeID
				AND UM.S_User_Type='CE'
	  WHERE IP.I_Status<>0
--		AND IP.S_Crtd_By='CenterHead378'
		AND UM.I_Status<>0
		AND MONTH(IP.Dt_Crtd_On)=@iCurtrentMonth
		AND YEAR(IP.Dt_Crtd_On)=@iCurtrentYear

	RETURN @InvoiceAmount

END