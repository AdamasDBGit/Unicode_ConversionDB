
CREATE PROCEDURE [dbo].[usp_ERP_GetInvoiceSummary]  --exec uspGetInvoiceSummary 168173      
    (  
      @iInvoiceID INT  
    )  
AS   

DECLARE @SACCode NVARCHAR(50) = ''
SELECT 
@SACCode = GCM.S_SAC_Code
FROM dbo.T_GST_Code_Master AS GCM
INNER JOIN dbo.T_State_Master AS SM
ON GCM.I_State_ID = SM.I_State_ID
AND GCM.I_Status = 1
AND SM.I_Status = 1
INNER JOIN NETWORK.T_Center_Address AS NCA
ON SM.I_State_ID = NCA.I_State_ID
INNER JOIN dbo.T_Invoice_Parent AS IP
ON NCA.I_Centre_Id = IP.I_Centre_Id
INNER JOIN T_Center_Hierarchy_Name_Details CHND
ON IP.I_Centre_Id = CHND.I_Center_ID
AND GCM.I_Brand_ID = CHND.I_Brand_ID
WHERE IP.I_Invoice_Header_ID = @iInvoiceID	
	
CREATE TABLE #FSTN
(
	I_Invoice_Header_ID INT,
	I_Invoice_CHILD_Header_ID INT,
	S_Tax_Code NVARCHAR(50),
	S_Tax_Desc NVARCHAR(50),
	N_Tax_Value NUMERIC (18,2)
)

SET NOCOUNT OFF                    
BEGIN TRY

	INSERT INTO #FSTN
	SELECT I_Invoice_Header_ID, I_Invoice_CHILD_Header_ID, S_Tax_Code, S_Tax_Desc, SUM(N_Tax_Value) AS N_Tax_Value
	FROM(SELECT 
		IP.I_Invoice_Header_ID,
		ICH.I_Invoice_CHILD_Header_ID,
		CASE WHEN ISNULL(TM.S_Tax_Code,'') NOT LIKE '%GST' THEN 'TAX'
		ELSE TM.S_Tax_Code END AS S_Tax_Code,
		CASE WHEN ISNULL(TM.S_Tax_Code,'') NOT LIKE '%GST' THEN 'SERVICE TAX'
		ELSE TM.S_Tax_Desc END AS S_Tax_Desc,
		SUM(ISNULL(IDT.N_Tax_Value,0))AS N_Tax_Value
	FROM dbo.T_Invoice_Parent AS IP
	INNER JOIN dbo.T_Invoice_Child_Header AS ICH
	ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ICD
	ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
	LEFT OUTER JOIN dbo.T_Invoice_Detail_Tax AS IDT
	ON IDT.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID 
	LEFT OUTER JOIN dbo.T_Tax_Master AS TM
	ON TM.I_Tax_ID = IDT.I_Tax_ID
	WHERE IP.I_Invoice_Header_ID = @iInvoiceID
	GROUP BY IP.I_Invoice_Header_ID, 
	ICH.I_Invoice_CHILD_Header_ID,
		TM.S_Tax_Code,
		TM.S_Tax_Desc) AS FS
	GROUP BY
		FS.I_Invoice_Header_ID, 
		I_Invoice_CHILD_Header_ID,
		FS.S_Tax_Code,
		FS.S_Tax_Desc
					
	SELECT 
		FinalResult.CourseName,
		@SACCode SACCode,
		FinalResult.Course_Amt CourseAmount,
		FinalResult.Discount as Discount,
		FinalResult.TAX OLDTAX,
		FinalResult.SGST SGSTTax,
		FinalResult.CGST CGSTTax,
		FinalResult.IGST IGSTTax,
		ISNULL((FinalResult.TAX + FinalResult.SGST + FinalResult.CGST + FinalResult.IGST),0.00) TaxAmt,
		ISNULL(FinalResult.Course_Amt,0.00)-ISNULL(FinalResult.Discount,0.00) + ISNULL((FinalResult.TAX + FinalResult.SGST + FinalResult.CGST + FinalResult.IGST),0.00) Total				
	FROM           
	(SELECT ISNULL(TCM.S_Course_Name,'') CourseName,  
			ISNULL(TICH.N_Amount,0)  AS Course_Amt ,  
			ISNULL(TICH.N_Discount_Amount, 0) AS Discount ,  					
			ISNULL(TICH.N_Amount,0) + ISNULL(TICH.N_Tax_Amount, 0) AS Total,			
			ISNULL((SELECT SUM(ISNULL(#FSTN.N_Tax_Value,0.00)) FROM #FSTN WHERE I_Invoice_CHILD_Header_ID = TICH.I_Invoice_CHILD_Header_ID AND #FSTN.S_Tax_Code = 'TAX') ,0.00) AS TAX,
			ISNULL((SELECT SUM(ISNULL(#FSTN.N_Tax_Value,0.00)) FROM #FSTN WHERE I_Invoice_CHILD_Header_ID = TICH.I_Invoice_CHILD_Header_ID AND #FSTN.S_Tax_Code = 'SGST'),0.00) AS SGST,
			ISNULL((SELECT SUM(ISNULL(#FSTN.N_Tax_Value,0.00)) FROM #FSTN WHERE I_Invoice_CHILD_Header_ID = TICH.I_Invoice_CHILD_Header_ID AND #FSTN.S_Tax_Code = 'CGST'),0.00) AS CGST,
			ISNULL((SELECT SUM(ISNULL(#FSTN.N_Tax_Value,0.00)) FROM #FSTN WHERE I_Invoice_CHILD_Header_ID = TICH.I_Invoice_CHILD_Header_ID AND #FSTN.S_Tax_Code = 'IGST'),0.00) AS IGST
	FROM    dbo.T_Invoice_Parent AS TIP  
			INNER JOIN dbo.T_Invoice_Child_Header AS TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID  
			LEFT OUTER JOIN dbo.T_Course_Master AS TCM ON TICH.I_Course_ID = TCM.I_Course_ID 
	WHERE   TIP.I_Invoice_Header_ID = @iInvoiceID
			) FinalResult
	ORDER BY CourseName ASC						
	                
	                
END TRY                    
	                    
BEGIN CATCH                    
--Error occurred:                      
	                    
	DECLARE @ErrMsg NVARCHAR(4000) ,  
		@ErrSeverity INT                    
	SELECT  @ErrMsg = ERROR_MESSAGE() ,  
			@ErrSeverity = ERROR_SEVERITY()                    
	                    
	RAISERROR(@ErrMsg, @ErrSeverity, 1)                    
END CATCH 

DROP TABLE #FSTN
