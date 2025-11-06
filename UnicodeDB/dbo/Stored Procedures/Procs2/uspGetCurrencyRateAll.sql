CREATE PROCEDURE [dbo].[uspGetCurrencyRateAll] 

AS
BEGIN

DECLARE @DtCurrentDate DATETIME
SET @DtCurrentDate = CAST(CAST(GETDATE() AS VARCHAR(11)) AS DATETIME)

	SELECT DISTINCT A.I_Currency_Rate_ID, B.S_Currency_Code, B.S_Currency_Name, A.I_Currency_ID, 
    A.Dt_Effective_Start_Date,A.N_Conversion_Rate, A.Dt_Effective_End_Date, A.I_Status,
    A.S_Crtd_By, A.S_Upd_By, A.Dt_Crtd_On, A.Dt_Upd_On
    FROM dbo.T_Currency_Rate A
    INNER JOIN dbo.T_Currency_Master B
    ON A.I_Currency_ID = B.I_Currency_ID
    WHERE A.I_Status <> 0
    AND B.I_Status <> 0
    AND A.Dt_Effective_End_Date IS NULL
    UNION    
    SELECT A.I_Currency_Rate_ID, B.S_Currency_Code, B.S_Currency_Name, A.I_Currency_ID, 
    A.Dt_Effective_Start_Date,A.N_Conversion_Rate, A.Dt_Effective_End_Date, A.I_Status,
    A.S_Crtd_By, A.S_Upd_By, A.Dt_Crtd_On, A.Dt_Upd_On
    FROM dbo.T_Currency_Rate A
    INNER JOIN dbo.T_Currency_Master B
    ON A.I_Currency_ID = B.I_Currency_ID
    WHERE A.I_Status <> 0
    AND B.I_Status <> 0    
    AND @DtCurrentDate >= A.Dt_Effective_Start_Date
    AND @DtCurrentDate <= A.Dt_Effective_End_Date
    AND A.Dt_Effective_End_Date IS NOT NULL     
    UNION
    SELECT A.I_Currency_Rate_ID, B.S_Currency_Code, B.S_Currency_Name, A.I_Currency_ID, 
    A.Dt_Effective_Start_Date,A.N_Conversion_Rate, A.Dt_Effective_End_Date, A.I_Status,
    A.S_Crtd_By, A.S_Upd_By, A.Dt_Crtd_On, A.Dt_Upd_On
    FROM dbo.T_Currency_Rate A
    INNER JOIN dbo.T_Currency_Master B
    ON A.I_Currency_ID = B.I_Currency_ID
    WHERE A.I_Status <> 0
    AND B.I_Status <> 0    
    AND @DtCurrentDate <= A.Dt_Effective_Start_Date
    AND @DtCurrentDate <= A.Dt_Effective_End_Date
    AND A.Dt_Effective_End_Date IS NOT NULL 
    ORDER BY A.I_Currency_ID
END
