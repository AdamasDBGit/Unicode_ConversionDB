      
CREATE PROCEDURE [dbo].[uspGetOAInvoice] --exec uspGetOAInvoice 'RC19-17BS-00001'     
(      
  @OAInvoiceNo NVARCHAR(max)          
)      
AS       
      
  BEGIN          
        
   DECLARE @OAInvoiceID INT,@StudentDetailsID INT,@EnquiryRegID INT      
         
   SELECT @OAInvoiceID=I_OnAccount_Ivoice_ID,      
   @StudentDetailsID=I_Student_Detail_ID,      
   @EnquiryRegID=I_Enquiry_Regn_ID      
   FROM      
   T_Invoice_OnAccount_Details      
   WHERE S_Invoice_Number=@OAInvoiceNo      
            
              
 IF(ISNULL(@StudentDetailsID,0)>0)      
 BEGIN      
         
    SELECT TSD.S_First_Name+' '+ISNULL(TSD.S_Middle_Name,' ')+TSD.S_Last_Name AS StudentName,      
    TSD.S_Curr_Address1 AS StudentAddress,      
    TSD.I_RollNo AS RollNo,      
    TSD.I_Student_Detail_ID AS StudentNo,     
    ISNULL(SBM.S_Batch_Name,'NA') AS BatchNo,     
    TCM.S_Center_Code ,        
    TBM.S_Brand_Name AS CenterName,     
    CA.S_Center_Address1 AS CenterAddress,       
    CA.S_Telephone_No+' '+CA.S_Email_ID AS CenterEmail,    
    'GSTIN NO - '+GCM.S_GST_Code+' State -'+SM.S_State_Name+', '+'State Code -'+GCM.S_State_Code AS CenterGST,        
    GCM.S_State_Code StateCode,     
    (    
		SELECT ISM.S_State_Name FROM     
		T_State_Master ISM    
		WHERE ISM.I_State_ID=GCM.I_State_ID    
    )StateName,      
    SM.S_State_Name PlaceOfSupply,    
    (    
	   SELECT CASE WHEN TIOAD.S_Invoice_Type IN ('BS','RI') THEN 'I'    
	   WHEN TIOAD.S_Invoice_Type ='RC' THEN 'C'    
	   END    
    )AS InvoiceType,    
    TIOAD.N_Receipt_Amount,    
    TIOAD.N_Tax_Amount,    
    TIOAD.N_Receipt_Amount+ TIOAD.N_Tax_Amount AS TotalAmount,    
    TIOAD.S_Invoice_Number AS InvoiceNumber,    
    REPLACE(CONVERT(varchar,TIOAD.Dt_Crtd_On,106),' ','/') AS InvoiceDate,    
    (    
		SELECT      
		ITIOAD.S_Invoice_Number    
		FROM T_Invoice_OnAccount_Details ITIOAD    
		WHERE ITIOAD.I_Receipt_Header_ID=TIOAD.I_Receipt_Header_ID    
		AND ITIOAD.I_Status=1    
    )AS ReferenceInvoice,    
    (    
    SELECT      
    REPLACE(CONVERT(varchar,ITIOAD.Dt_Crtd_On,106),' ','/')    
    FROM T_Invoice_OnAccount_Details ITIOAD    
    WHERE ITIOAD.I_Receipt_Header_ID=TIOAD.I_Receipt_Header_ID    
    AND ITIOAD.I_Status=1    
    )AS ReferenceInvoiceDate,    
    REPLACE(CONVERT(varchar,TIOAD.Dt_Receipt_Date,106),' ','/') AS ReceiptDate,    
    TSM.S_Status_Desc OnAccountDesc,
    GCM.S_SAC_Code
    FROM          
    T_Invoice_OnAccount_Details TIOAD      
    INNER JOIN T_Student_Detail TSD ON TSD.I_Student_Detail_ID=TIOAD.I_Student_Detail_ID      
    INNER JOIN dbo.T_Centre_Master TCM  ON TCM.I_Centre_ID=TIOAD.I_Centre_Id      
    INNER JOIN dbo.T_Brand_Center_Details TBCD ON TBCD.I_Centre_Id = TCM.I_Centre_Id        
    INNER JOIN dbo.T_Brand_Master TBM ON TBM.I_Brand_ID = TBCD.I_Brand_ID     
    LEFT JOIN T_Student_Batch_Details STBD on STBD.I_Student_ID=TSD.I_Student_Detail_ID  AND  STBD.I_Status = 1     
    LEFT JOIN dbo.T_Student_Batch_Master SBM ON SBM.I_Batch_ID = STBD.I_Batch_ID           
    INNER JOIN NETWORK.T_Center_Address AS CA ON TBCD.I_Centre_Id = CA.I_Centre_Id        
    INNER JOIN dbo.T_State_Master AS SM ON CA.I_State_ID = SM.I_State_ID      
    INNER JOIN T_Status_Master TSM ON TSM.I_Status_Value=TIOAD.I_Receipt_Type    
    LEFT JOIN dbo.T_GST_Code_Master AS GCM ON GCM.I_State_ID = SM.I_State_ID     
    AND GCM.I_Brand_ID = TBM.I_Brand_ID      
    WHERE TIOAD.I_OnAccount_Ivoice_ID = @OAInvoiceID      
    AND TCM.I_Status <> 0        
         
 END    
 ELSE    
 BEGIN      
         
    SELECT  DISTINCT    
    TSD.S_First_Name+' '+ISNULL(TSD.S_Middle_Name,' ')+TSD.S_Last_Name AS StudentName,      
    TSD.S_Curr_Address1 AS StudentAddress,      
    'NA' AS RollNo,      
    'NA' AS StudentNo,      
    'NA' AS BatchNo,    
    TCM.S_Center_Code ,        
    TBM.S_Brand_Name AS CenterName,     
    CA.S_Center_Address1 AS CenterAddress,       
    CA.S_Telephone_No+' '+CA.S_Email_ID AS CenterEmail,    
    'GSTIN NO - '+GCM.S_GST_Code+' State -'+SM.S_State_Name+', '+'State Code -'+GCM.S_State_Code AS CenterGST,    
    GCM.S_State_Code StateCode,     
    (    
		SELECT ISM.S_State_Name FROM     
		T_State_Master ISM    
		WHERE ISM.I_State_ID=GCM.I_State_ID    
    )StateName,      
    SM.S_State_Name PlaceOfSupply,    
    (    
	   SELECT CASE WHEN TIOAD.S_Invoice_Type IN ('BS','RI') THEN 'I'    
	   WHEN TIOAD.S_Invoice_Type ='RC' THEN 'C'    
	   END    
    )AS InvoiceType,    
    TIOAD.N_Receipt_Amount,    
    TIOAD.N_Tax_Amount,    
    TIOAD.N_Receipt_Amount+ TIOAD.N_Tax_Amount AS TotalAmount,    
    TIOAD.S_Invoice_Number AS InvoiceNumber,    
    REPLACE(CONVERT(varchar,TIOAD.Dt_Crtd_On,106),' ','/') AS InvoiceDate,    
    (    
	   SELECT      
	   ITIOAD.S_Invoice_Number    
	   FROM T_Invoice_OnAccount_Details ITIOAD    
	   WHERE ITIOAD.I_Receipt_Header_ID=TIOAD.I_Receipt_Header_ID    
	   AND ITIOAD.I_Status=1    
    )AS ReferenceInvoice,    
    (    
	   SELECT      
	   REPLACE(CONVERT(varchar,ITIOAD.Dt_Crtd_On,106),' ','/')    
	   FROM T_Invoice_OnAccount_Details ITIOAD    
	   WHERE ITIOAD.I_Receipt_Header_ID=TIOAD.I_Receipt_Header_ID    
	   AND ITIOAD.I_Status=1    
    )AS ReferenceInvoiceDate,    
    REPLACE(CONVERT(varchar,TIOAD.Dt_Receipt_Date,106),' ','/') AS ReceiptDate,    
    TSM.S_Status_Desc OnAccountDesc,
    GCM.S_SAC_Code    
    FROM          
    T_Invoice_OnAccount_Details TIOAD      
    INNER JOIN T_Enquiry_Regn_Detail TSD ON TSD.I_Enquiry_Regn_ID=TIOAD.I_Enquiry_Regn_ID      
    INNER JOIN dbo.T_Centre_Master TCM  ON TCM.I_Centre_ID=TIOAD.I_Centre_Id      
    INNER JOIN dbo.T_Brand_Center_Details TBCD ON TBCD.I_Centre_Id = TCM.I_Centre_Id        
    INNER JOIN dbo.T_Brand_Master TBM ON TBM.I_Brand_ID = TBCD.I_Brand_ID        
    INNER JOIN NETWORK.T_Center_Address AS CA ON TBCD.I_Centre_Id = CA.I_Centre_Id        
    INNER JOIN dbo.T_State_Master AS SM ON CA.I_State_ID = SM.I_State_ID       
    INNER JOIN T_Status_Master TSM ON TSM.I_Status_Value=TIOAD.I_Receipt_Type    
    LEFT JOIN dbo.T_GST_Code_Master AS GCM ON GCM.I_State_ID = SM.I_State_ID       
    AND GCM.I_Brand_ID = TBM.I_Brand_ID      
    WHERE TIOAD.I_OnAccount_Ivoice_ID = @OAInvoiceID      
    AND TCM.I_Status <> 0        
         
 END      
   --on account TAX details      
   SELECT      
   TIOADT.N_Tax_Paid AS TaxPaid,      
   TTM.S_Tax_Desc AS TaxType    
   FROM      
   T_Invoice_OnAccount_Details_Tax TIOADT      
   INNER JOIN T_Tax_Master TTM ON TTM.I_Tax_ID=TIOADT.I_Tax_ID      
   WHERE TIOADT.I_OnAccount_Ivoice_ID=@OAInvoiceID      
   ORDER BY TIOADT.I_Tax_ID    
              
END


