CREATE PROC [dbo].[uspCheckCentreFTSAP]
(
@iCentreID INT
)
AS
BEGIN

SET NOCOUNT ON;

DECLARE @DtCurrentDate DATETIME
SET @DtCurrentDate = CAST(CAST(GETDATE() AS VARCHAR(11)) AS DATETIME)

    IF NOT EXISTS(SELECT * FROM T_Centre_Master WHERE i_centre_id=@iCentreID
        AND ((S_SAP_Customer_Id IS NOT NULL) AND (LTRIM(RTRIM(S_SAP_Customer_Id)) <> '')))
    BEGIN
        SELECT 1
        RETURN;
    END

    IF NOT EXISTS(SELECT 'True'
        FROM dbo.T_Currency_Rate CUR
        INNER JOIN dbo.T_Currency_Master CUM
        ON CUR.I_Currency_ID = CUM.I_Currency_ID
        INNER JOIN T_Centre_Master CM
        ON CM.I_Centre_ID = I_Centre_ID
        INNER JOIN T_Country_Master COM
        ON COM.I_Country_ID = CM.I_Country_ID
        AND COM.I_Currency_ID = CUM.I_Currency_ID
        WHERE CM.I_Centre_ID = @iCentreID
        AND CUR.I_Status <> 0
        AND CUM.I_Status <> 0
        AND COM.I_Status <> 0 )

    BEGIN                
        SELECT 2
        RETURN;
    END

        
    IF NOT EXISTS(SELECT 'True'
        FROM dbo.T_Currency_Rate CUR
        INNER JOIN dbo.T_Currency_Master CUM
        ON CUR.I_Currency_ID = CUM.I_Currency_ID
        INNER JOIN T_Centre_Master CM
        ON CM.I_Centre_ID = I_Centre_ID
        INNER JOIN T_Country_Master COM
        ON COM.I_Country_ID = CM.I_Country_ID
        AND COM.I_Currency_ID = CUM.I_Currency_ID        
        WHERE CM.I_Centre_ID = @iCentreID
        AND CUR.I_Status <> 0
        AND CUM.I_Status <> 0
        AND COM.I_Status <> 0        
        AND @DtCurrentDate >=CUR.Dt_Effective_Start_Date
        AND @DtCurrentDate <= CUR.Dt_Effective_End_Date )
        
    BEGIN
        SELECT 2
        RETURN;
    END

    SELECT 0
  
END
