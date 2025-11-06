-- =====================================================================
-- Author:		Swagatam Sarkar
-- Create date: 10/12/2007'
-- Description:	This Function return a Numeric Value of Collection KRA 
-- =====================================================================
CREATE FUNCTION [EOS].[fnGetKRACollection]
(
	@iEmployeeID INT,
	@iCurrentMonth INT,
	@iCurrentYear INT
)

RETURNS  NUMERIC(18,2)

AS 

BEGIN

	DECLARE @ReceiptAmount NUMERIC(18,2)

	 SELECT @ReceiptAmount=ISNULL(SUM(RH.N_Receipt_Amount),0.00)
	   FROM dbo.T_Receipt_Header RH
			INNER JOIN dbo.T_User_Master UM
				ON RH.S_Crtd_By=UM.S_Login_ID
				AND UM.I_Reference_ID=@iEmployeeID
				AND UM.S_User_Type='CE'
	  WHERE RH.I_Status<>0
		AND UM.I_Status<>0
		AND MONTH(RH.Dt_Crtd_On)=@iCurrentMonth
		AND YEAR(RH.Dt_Crtd_On)=@iCurrentYear

	RETURN @ReceiptAmount

END