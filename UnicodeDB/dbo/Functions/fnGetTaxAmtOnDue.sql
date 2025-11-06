
CREATE FUNCTION [dbo].[fnGetTaxAmtOnDue]
(
	@I_Fee_Component_ID INT,
	@Dt_Installment_Date DATETIME,
	@Due_Amt DECIMAL(14, 2)
)
RETURNS DECIMAL(14, 2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Tax_Amt DECIMAL(14, 2) = 0.00

	-- Add the T-SQL statements to compute the return value here
	SELECT @Tax_Amt = ISNULL(SUM(B.N_Tax_Value),0)
	FROM(
			SELECT TAX.I_Tax_ID,
			CAST(@Due_Amt * TAX.N_Tax_Rate / 100.00 AS NUMERIC(18,2)) AS N_Tax_Value
			FROM (SELECT TCFC.N_Tax_Rate, TM.I_Tax_ID 
				  FROM (select * from dbo.T_Tax_Master) AS TM
				  INNER JOIN (select * from dbo.T_Tax_Country_Fee_Component where I_Fee_Component_ID=@I_Fee_Component_ID) AS TCFC
					ON (TM.I_Tax_ID = TCFC.I_Tax_ID
						AND TM.I_Country_ID = TCFC.I_Country_ID AND TCFC.N_Tax_Rate > 0
						AND @Dt_Installment_Date BETWEEN TCFC.Dt_Valid_From AND TCFC.Dt_Valid_To)
				 ) TAX
		) B

	-- Return the result of the function
	RETURN @Tax_Amt

END