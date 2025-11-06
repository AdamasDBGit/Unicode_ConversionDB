CREATE PROCEDURE [dbo].[uspFTBatchGetCurrencyRate] --10
(
	@iCurrencyID INT
)
 
AS
BEGIN

	SELECT  A.I_Currency_ID, B.S_Currency_Code, B.S_Currency_Name, 
			A.N_Conversion_Rate, A.Dt_Effective_Start_Date, A.Dt_Effective_End_Date 
	FROM dbo.T_Currency_Rate A, dbo.T_Currency_Master B
	WHERE A.I_Status <> 0
	AND A.I_Currency_ID = B.I_Currency_ID
	AND B.I_Currency_ID = @iCurrencyID
	ORDER BY A.I_Currency_Rate_ID DESC 
END
