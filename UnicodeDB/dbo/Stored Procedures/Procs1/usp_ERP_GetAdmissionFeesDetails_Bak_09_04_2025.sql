CREATE PROCEDURE [dbo].[usp_ERP_GetAdmissionFeesDetails_Bak_09_04_2025]          
(          
    @EnquiryID INT,          
    @Brand_ID INT = NULL,          
    @SessionID INT = NULL          
)          
AS          
BEGIN          
    DECLARE @formcellid INT;        
    SET @formcellid = (SELECT I_Status_Value      
                       FROM T_Status_Master      
                       WHERE Status_Type = 1 AND I_Brand_ID = @Brand_ID);   
        If @SessionID is NULL --or @SessionID IS NOT NULL  
        Begin  
     SET @SessionID=  
     (Select top 1 R_I_School_Session_ID from T_Enquiry_Regn_Detail   
     where I_Enquiry_Regn_ID=@EnquiryID)  
     End  
        
    -- Correcting the SELECT DISTINCT issue    
    SELECT DISTINCT     
           t1.I_Fee_Component_InstallmentID,          
           t1.R_I_Enquiry_Regn_ID,          
           t1.Seq,          
           CONVERT(VARCHAR, t1.Dt_Payment_Installment_Dt, 107) AS Dt_Payment_Installment_Dt,          
           CASE          
               WHEN t1.N_Installment_Amount - FLOOR(t1.N_Installment_Amount) >= 0.5 THEN          
                   CEILING(t1.N_Installment_Amount)          
               ELSE          
                   FLOOR(t1.N_Installment_Amount)          
           END AS N_Installment_Amount,          
           CASE          
               WHEN (t1.N_Installment_Amount + N_IGST_Value) - FLOOR(t1.N_Installment_Amount + ISNULL(N_IGST_Value, 0)) >= 0.5 THEN          
                   CEILING(t1.N_Installment_Amount + ISNULL(N_IGST_Value, 0))          
               ELSE          
                   FLOOR(t1.N_Installment_Amount + ISNULL(N_IGST_Value, 0))          
           END AS N_Installment_Amount_IncludeTax,          
           t1.R_I_Fee_Structure_ID,  
     t2.I_Fee_Component_ID as Fee_ComponentID,   
           t2.S_Component_Name AS S_Fee_Component_Name,          
           t3.S_Fee_Structure_Name,          
           DENSE_RANK() OVER (ORDER BY t1.Dt_Payment_Installment_Dt) AS DateWiseInstallmentSequenceNo,          
           t4.CGST_per,          
           t1.N_CGST_Value,          
           t4.SGST_per,          
           t1.N_SGST_Value,          
           t4.IGST_per,          
           t1.N_IGST_Value,          
           TS.S_Label        
    INTO #Temp_Fee_Installment          
    FROM T_ERP_Fee_Payment_Installment t1          
        LEFT JOIN T_Fee_Component_Master t2          
            ON t2.I_Fee_Component_ID = t1.R_I_Fee_Component_ID          
        LEFT JOIN T_ERP_Fee_Structure t3          
            ON t3.I_Fee_Structure_ID = t1.R_I_Fee_Structure_ID          
               AND t2.I_Fee_Component_ID = t1.R_I_Fee_Component_ID          
        LEFT JOIN T_ERP_Stud_Fee_Struct_Comp_Mapping SCM          
            ON SCM.R_I_Enquiry_Regn_ID = @EnquiryID          
               AND SCM.I_Brand_ID = @Brand_ID          
        INNER JOIN T_ERP_Stud_Fee_Struct_Comp_Mapping_Details t4           
            ON t4.I_Stud_Fee_Struct_CompMap_Details_ID = t1.I_Stud_Fee_Struct_CompMap_Details_ID           
            AND t4.R_I_Fee_Component_ID = t1.R_I_Fee_Component_ID         
        INNER JOIN T_School_Academic_Session_Master TS         
            ON TS.I_School_Session_ID = SCM.R_I_School_Session_ID       
    WHERE          
        t1.R_I_Enquiry_Regn_ID = @EnquiryID          
        AND t1.Is_Moved IS NULL    
  AND TS.I_School_Session_ID=@SessionID;    
        
    -- Summarize and group data    
    SELECT *          
    FROM #Temp_Fee_Installment        
    order by seq    
    SELECT         
        SUM(N_Installment_Amount) + SUM(ISNULL(N_IGST_Value, 0)) AS Total_AMt,          
        DateWiseInstallmentSequenceNo,          
        CONVERT(VARCHAR, Dt_Payment_Installment_Dt, 107) AS Dt_Payment_Installment_Dt,        
        Dt_Payment_Installment_Dt AS D1          
    INTO #TotalAmount          
    FROM #Temp_Fee_Installment          
    GROUP BY         
        DateWiseInstallmentSequenceNo,          
        Dt_Payment_Installment_Dt;        
        
    -- Query and order the results from #TotalAmount        
    SELECT *         
    FROM #TotalAmount          
    ORDER BY DateWiseInstallmentSequenceNo;        
        
    SELECT SUM(Total_AMt) AS ComponentTotalAmount          
    FROM #TotalAmount          
    WHERE CONVERT(DATE, D1) <= CONVERT(DATE, GETDATE());        
        
    SELECT SUM(N_Installment_Amount) AS TotalBaseAmount,          
           SUM(ISNULL(N_Installment_Amount_IncludeTax, 0)) AS TotalTaxBaseAmount,            
           SUM(ISNULL(N_SGST_Value, 0)) AS SGST,          
           SUM(ISNULL(N_CGST_Value, 0)) AS CGST,          
           SUM(ISNULL(N_IGST_Value, 0)) AS IGST,        
           S_Label AS Label     
    FROM #Temp_Fee_Installment     
    GROUP BY S_Label;        
        
  
DECLARE @StudentDetailID int=NULL  
  
select top 1 @StudentDetailID = I_Student_Detail_ID from T_Student_Detail where I_Enquiry_Regn_ID=@EnquiryID  
  
    SELECT     
        t1.S_Receipt_No AS ReceiptNo,     
        t1.N_Receipt_Amount AS ReceiptAmount,     
        t2.S_Status_Desc AS Status,     
        t1.I_Receipt_Header_ID AS ReceiptHeaderID,      
        CONVERT(VARCHAR, t1.Dt_Receipt_Date, 107) AS ReceiptDate     
    FROM T_Receipt_Header t1        
    INNER JOIN T_Status_Master t2     
        ON t2.I_Status_value = t1.I_Receipt_type        
    WHERE (t1.I_Enquiry_Regn_ID = @EnquiryID OR t1.I_Student_Detail_ID = @StudentDetailID)   
 and t2.Is_AdmissionToken = 'true'  
 and t1.I_Status=1  
      --AND t1.I_Receipt_Type != @formcellid     
    ORDER BY t1.S_Receipt_No DESC;        
         
    DROP TABLE #Temp_Fee_Installment;          
END; 