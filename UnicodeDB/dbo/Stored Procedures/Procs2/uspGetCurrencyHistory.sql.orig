CREATE PROC [dbo].[uspGetCurrencyHistory]
(
@sCurrencyList VARCHAR(50)
)

AS 
BEGIN
DECLARE @iCount INT
DECLARE @iStatus INT

    SELECT @iCount=COUNT(DISTINCT Val) FROM dbo.fnString2Rows(@sCurrencyList,',')


	IF (@iCount > 1)
	BEGIN		 
			SELECT 
            CM.S_Currency_Code [Currency Code],CM.S_Currency_Name [Currency Name],'USD' [Base Currency],
            CR.N_Conversion_Rate [Conversion Rate],
            'Effective Start Date' = CASE 
            WHEN CR.Dt_Effective_Start_Date IS NULL THEN ''
            WHEN ISDATE(CR.Dt_Effective_Start_Date)=1 THEN CAST(CR.Dt_Effective_Start_Date AS VARCHAR(11))
            END,
            'Effective End Date' = CASE 
            WHEN CR.Dt_Effective_End_Date IS NULL THEN ''
            WHEN ISDATE(CR.Dt_Effective_End_Date)=1 THEN CAST(CR.Dt_Effective_End_Date AS VARCHAR(11))
            END,
            'Status' =CASE 
            WHEN CR.I_Status=1 THEN 'Active'
            WHEN CR.I_Status=0 THEN 'Deleted'
            END
            FROM T_Currency_Rate CR
            INNER JOIN  T_Currency_Master CM
            ON CR.I_Currency_ID = CM.I_Currency_ID
			WHERE CR.I_Currency_ID IN (SELECT DISTINCT * FROM dbo.fnString2Rows(@sCurrencyList,','))
			AND CM.I_Status <> 0
			ORDER BY CM.S_Currency_Code
	END
	ELSE
	BEGIN
		IF ((SELECT DISTINCT * FROM dbo.fnString2Rows(@sCurrencyList,','))=0)
		BEGIN
			SELECT 
            CM.S_Currency_Code [Currency Code],CM.S_Currency_Name [Currency Name],'USD' [Base Currency],
            CR.N_Conversion_Rate [Conversion Rate],
            'Effective Start Date' = CASE 
            WHEN CR.Dt_Effective_Start_Date IS NULL THEN ''
            WHEN ISDATE(CR.Dt_Effective_Start_Date)=1 THEN CAST(CR.Dt_Effective_Start_Date AS VARCHAR(11))
            END,
            'Effective End Date' = CASE 
            WHEN CR.Dt_Effective_End_Date IS NULL THEN ''
            WHEN ISDATE(CR.Dt_Effective_End_Date)=1 THEN CAST(CR.Dt_Effective_End_Date AS VARCHAR(11))
            END,
            'Status' =CASE 
            WHEN CR.I_Status=1 THEN 'Active'
            WHEN CR.I_Status=0 THEN 'Deleted'
            END
            FROM T_Currency_Rate CR
            INNER JOIN  T_Currency_Master CM
            ON CR.I_Currency_ID = CM.I_Currency_ID
			WHERE CM.I_Status <> 0
			ORDER BY CM.S_Currency_Code
		END
		
	END
	
END
