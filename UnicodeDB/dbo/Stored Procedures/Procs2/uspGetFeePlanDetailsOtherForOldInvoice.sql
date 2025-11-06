CREATE PROCEDURE [dbo].[uspGetFeePlanDetailsOtherForOldInvoice] --uspGetFeePlanDetailsOtherForOldInvoice 150978
( 
	@iOldInvoiceHeaderID INT
)
AS 
BEGIN      
    SET NOCOUNT ON    
    
    CREATE TABLE #IWFPD
    (
		ID INT IDENTITY(1,1),
		I_Invoice_Detail_ID int, 
		I_Invoice_Child_Header_ID int, 
		I_Course_Fee_Plan_ID int,
		I_Fee_Component_ID int, 
		I_Installment_No int, 
		Dt_Installment_Date DATETIME, 
		N_Amount_Due numeric(18,0)
    ) 
    
    INSERT INTO #IWFPD
    (
		I_Invoice_Detail_ID, 
		I_Invoice_Child_Header_ID, 
		I_Course_Fee_Plan_ID,
		I_Fee_Component_ID, 
		I_Installment_No, 
		Dt_Installment_Date, 
		N_Amount_Due
    )     
    SELECT B.I_Invoice_Detail_ID, B.I_Invoice_Child_Header_ID, B.I_Course_FeePlan_ID, B.I_Fee_Component_ID, B.I_Installment_No, B.Dt_Installment_Date, 
    (ISNULL(B.N_Amount_Due,0.00) - ISNULL(A.N_Amount_Paid,0.00)) N_Amount_Due
	FROM (SELECT ICD.I_Invoice_Detail_ID, ICD.I_Invoice_Child_Header_ID, ICH.I_Course_FeePlan_ID, ICD.I_Fee_Component_ID, ICD.I_Installment_No, ICD.Dt_Installment_Date, ICD.N_Amount_Due
	FROM T_Invoice_Child_Detail ICD 
	INNER JOIN T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
	INNER JOIN T_Invoice_Parent IP ON ICH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID 
	WHERE IP.I_Invoice_Header_ID = @iOldInvoiceHeaderID
	AND ISNULL(ICD.Flag_IsAdvanceTax,'N') <> 'Y') B
	LEFT JOIN 
	(SELECT RCD.I_Invoice_Detail_ID, SUM(ISNULL(RCD.N_Amount_Paid,0)) N_Amount_Paid
	FROM T_Receipt_Header RH
	INNER JOIN T_Receipt_Component_Detail RCD ON RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
	WHERE RH.I_Invoice_Header_ID = @iOldInvoiceHeaderID
	AND ISNULL(RH.I_Status,0) <> 0
	GROUP BY RCD.I_Invoice_Detail_ID) A	ON B.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
	INNER JOIN T_Invoice_Child_Header ICH1 ON B.I_Invoice_Child_Header_ID = ICH1.I_Invoice_Child_Header_ID
	WHERE ISNULL(ICH1.I_Course_FeePlan_ID,0) = 0
	AND (ISNULL(B.N_Amount_Due,0.00) - ISNULL(A.N_Amount_Paid,0.00)) > 0
	ORDER BY B.I_Installment_No
	
	SELECT 0 AS I_Invoice_Detail_ID
		   ,A.I_Fee_Component_ID
		   ,A.I_Installment_No
		   ,A.Dt_Installment_Date
		   ,SUM(ISNULL(A.N_Amount_Due,0)) AS N_Amount_Due
		   ,0 N_Amount_Paid
	FROM (SELECT I_Fee_Component_ID
		   ,CASE WHEN CONVERT(DATE, GETDATE()) >= CONVERT(DATE, Dt_Installment_Date) THEN 1
				 ELSE I_Installment_No
			END I_Installment_No
		   ,CASE WHEN CONVERT(DATE, GETDATE()) >= CONVERT(DATE, Dt_Installment_Date) THEN DATEADD(d,DATEDIFF(d,0,getdate()),0)
				 ELSE Dt_Installment_Date
			END Dt_Installment_Date
		   ,N_Amount_Due
	FROM #IWFPD) A
	GROUP BY A.I_Fee_Component_ID,A.I_Installment_No,A.Dt_Installment_Date
	ORDER BY A.I_Installment_No ASC
	
	DROP TABLE #IWFPD
END
