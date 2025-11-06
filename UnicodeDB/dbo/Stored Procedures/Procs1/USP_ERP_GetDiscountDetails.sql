CREATE procedure [dbo].[USP_ERP_GetDiscountDetails]      
    @BrandID INT = NULL,    
    @FeeComponent NVARCHAR(max) = NULL,    
    @FromInstalment NVARCHAR(max) = NULL    
AS    
BEGIN    
SET NOCOUNT ON;    
    IF OBJECT_ID('tempdb..#TempDiscountDetails') IS NOT NULL    
    DROP TABLE #TempDiscountDetails;    
    
    CREATE TABLE #TempDiscountDetails    
    (    
        I_Discount_Scheme_Detail_ID INT,    
        I_Discount_Scheme_ID INT,    
        S_Discount_Scheme_Name nvarchar(max),  
        S_Discount_Scheme_Code nvarchar(max),  
        I_Brand_ID INT,    
        S_FeeComponents nvarchar(max),    
        I_Fee_Component_ID INT,    
        S_Component_Name nvarchar(max),    
        S_FromInstalment nvarchar(max),    
        I_Fee_Structure_ID nvarchar(max),    
        S_Fee_Structure_Name nvarchar(max),    
        N_Discount_Rate NUMERIC(18,2),    
        N_Discount_Amount NUMERIC(18,2),    
        I_IsApplicableOn INT,    
        I_NoofInstallments INT,    
        Dt_Valid_From DATE,    
        Dt_Valid_To DATE,    
        I_Status INT,    
        Is_Active INT    
    );    
    
    INSERT INTO #TempDiscountDetails    
    SELECT    
        EDSD.I_Discount_Scheme_Detail_ID,    
        TDSM.I_Discount_Scheme_ID,    
        TDSM.S_Discount_Scheme_Name,    
        TDSM.S_Discount_Scheme_Code,  
        TDBM.I_Brand_ID,    
        EDSD.I_FeeComponentID,    
        TFCM.I_Fee_Component_ID,    
        TFCM.S_Component_Name,    
        EDSD.I_FromInstalment,    
        TDFSD.I_ERP_Fee_Structure_ID,    
        TEFS.S_Fee_Structure_Name,    
        EDSD.N_Discount_Rate,    
        EDSD.N_Discount_Amount,    
        EDSD.I_IsApplicableOn,    
        EDSD.I_NoofInstallments,    
        TDSM.Dt_Valid_From,    
        TDSM.Dt_Valid_To,    
        EDSD.I_Status_ID,    
        TEFS.Is_Active    
    FROM    
    dbo.T_ERP_Discount_Scheme_Details AS EDSD    
    LEFT JOIN dbo.t_discount_scheme_master AS TDSM ON EDSD.I_Discount_Scheme_ID = TDSM.I_Discount_Scheme_ID    
    LEFT JOIN dbo.t_discount_brand_map AS TDBM ON TDBM.I_Discount_Scheme_ID = TDSM.I_Discount_Scheme_ID  
    LEFT JOIN T_Fee_Component_Master AS TFCM ON TFCM.I_Fee_Component_ID = EDSD.I_FeeComponentID  
    --CROSS APPLY dbo.ERP_SplitString(EDSD.I_FeeComponentID, ',') AS splitcomp    
    --LEFT JOIN dbo.T_Fee_Component_Master AS TFCM ON TRY_CAST(splitcomp.value AS INT) = TFCM.I_Fee_Component_ID    
    LEFT JOIN T_Discount_Fee_Schedule_Detail AS TDFSD ON TDFSD.I_Discount_Brand_ID = TDBM.I_Discount_Brand_ID    
    LEFT JOIN T_ERP_Fee_Structure AS TEFS ON TEFS.I_Fee_Structure_ID = TDFSD.I_ERP_Fee_Structure_ID    
    WHERE    
        TDSM.I_Status = 1 OR TDSM.I_Status = 0    
        AND EDSD.I_Status_ID = 1 OR EDSD.I_Status_ID = 0    
        AND TDBM.I_Status_ID = 1 OR TDBM.I_Status_ID = 0    
        AND TFCM.I_Status = 1 OR TFCM.I_Status = 0    
        AND TDFSD.I_Status_ID = 1 OR TDFSD.I_Status_ID = 0    
        AND TEFS.Is_Active = 1 OR TEFS.Is_Active = 0    
        AND CONVERT(date, GETDATE()) BETWEEN TDSM.Dt_Valid_From AND TDSM.Dt_Valid_To;    
    SELECT    
    T.I_Discount_Scheme_Detail_ID,    
    T.I_Discount_Scheme_ID,    
    T.S_Discount_Scheme_Name,   
    T.S_Discount_Scheme_Code,  
    T.I_Brand_ID,    
    T.S_FeeComponents,    
    STUFF((SELECT DISTINCT ',' + T2.S_Component_Name      
           FROM #TempDiscountDetails T2      
           WHERE T2.I_Discount_Scheme_Detail_ID = T.I_Discount_Scheme_Detail_ID      
           FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(max)'), 1, 1, '') AS S_Component_Names,    
    CASE     
      WHEN T.S_FromInstalment = 0 THEN 'First'    
      WHEN T.S_FromInstalment = -1 THEN 'Last'    
      WHEN T.S_FromInstalment IS NULL THEN 'Specific'    
      ELSE 'N/A' END AS S_FromInstalment,    
  CASE     
    WHEN T.S_FromInstalment IS NULL THEN CONCAT('Discount On Installment No. ', T.I_NoofInstallments)    
    WHEN T.S_FromInstalment = 0 THEN CONCAT('Discount for First ', T.I_NoofInstallments, ' Installments')    
    WHEN T.S_FromInstalment = -1 THEN CONCAT('Discount for Last ', T.I_NoofInstallments, ' Installments')    
    ELSE CONCAT('Discount for ', T.S_FromInstalment, ' ', T.I_NoofInstallments, ' Installments')    
END AS S_DiscountDescription,    
     STUFF((SELECT DISTINCT ',' + T2.I_Fee_Structure_ID     
           FROM #TempDiscountDetails T2      
           WHERE T2.I_Discount_Scheme_Detail_ID = T.I_Discount_Scheme_Detail_ID      
  FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(max)'), 1, 1, '') AS I_Fee_Structure_ID,    
     STUFF((SELECT DISTINCT ',' + T2.S_Fee_Structure_Name      
           FROM #TempDiscountDetails T2      
           WHERE T2.I_Discount_Scheme_Detail_ID = T.I_Discount_Scheme_Detail_ID      
           FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(max)'), 1, 1, '') AS S_Fee_Structure_Name,    
    T.N_Discount_Rate,    
    T.N_Discount_Amount,    
    T.I_IsApplicableOn,    
    T.I_NoofInstallments,     
    T.Dt_Valid_From,    
    T.Dt_Valid_To,    
    T.I_Status,    
    T.Is_Active    
FROM    
    #TempDiscountDetails T    
WHERE    
    (@BrandID IS NULL OR T.I_Brand_ID = @BrandID)    
    AND (@FeeComponent IS NULL OR T.S_Component_Name = @FeeComponent)    
    AND (@FromInstalment IS NULL OR T.S_FromInstalment = @FromInstalment)    
GROUP BY    
    T.I_Discount_Scheme_Detail_ID,    
    T.I_Discount_Scheme_ID,    
    T.S_Discount_Scheme_Name,  
    T.S_Discount_Scheme_Code,  
    T.I_Brand_ID,    
    T.S_FeeComponents,    
    T.S_FromInstalment,    
    T.N_Discount_Rate,    
    T.N_Discount_Amount,    
    T.I_IsApplicableOn,    
    T.I_NoofInstallments,     
    T.Dt_Valid_From,    
    T.Dt_Valid_To,    
    T.I_Status,    
    T.Is_Active    
ORDER BY    
    T.I_Discount_Scheme_Detail_ID DESC,    
    T.I_Brand_ID,    
    T.S_FromInstalment;    
  DROP TABLE #TempDiscountDetails;    
END;

