CREATE PROCEDURE [CORPORATE].[uspGetCorporateStudentReceipt] --1             
(                            
 -- Add the parameters for the stored procedure here                            
 @iCorporatePlanID INT = NULL                      
                      
)                            
AS                            
BEGIN         
    
SELECT tci1.I_Corporate_Invoice_Id,tci1.N_Excess_Amt,tcisim.I_Invoice_Header_ID , tip1.I_Student_Detail_ID ,    
CheckID =              
CASE tcirm.I_Corporate_Invoice_Id            
  WHEN tci1.I_Corporate_Invoice_Id THEN 'Y'              
  ELSE 'N'              
END               
    
INTO #temp         
FROM CORPORATE.T_Corporate_Invoice AS tci1          
INNER JOIN CORPORATE.T_CorporateInvoice_StudentInvoice_Map AS tcisim        
ON tci1.I_Corporate_Invoice_Id = tcisim.I_Corporate_Invoice_Id        
INNER JOIN dbo.T_Invoice_Parent AS tip1      
ON tcisim.I_Invoice_Header_ID = tip1.I_Invoice_Header_ID    
LEFT OUTER JOIN CORPORATE.T_Corporate_Invoice_Receipt_Map AS tcirm    
ON tci1.I_Corporate_Invoice_Id = tcirm.I_Corporate_Invoice_Id    
WHERE tci1.I_Corporate_Plan_ID = @iCorporatePlanID            
            
    
        
SELECT  DISTINCT t4.I_Corporate_Invoice_Id,t4.N_Excess_Amt, t4.CheckID,       
  InvoiceIds = STUFF((SELECT ', '+ +CAST(t3.I_Invoice_Header_ID AS VARCHAR(8))            
  FROM #temp AS t3              
 WHERE t3.I_Corporate_Invoice_Id = t4.I_Corporate_Invoice_Id        
 ORDER BY t3.I_Corporate_Invoice_Id              
 FOR XML PATH('')),1,1,'')  ,      
 StudentIds = STUFF((SELECT ', '+ +CAST(t3.I_Student_Detail_ID AS VARCHAR(8))       
 FROM #temp AS t3              
 WHERE t3.I_Corporate_Invoice_Id = t4.I_Corporate_Invoice_Id        
 ORDER BY t3.I_Corporate_Invoice_Id              
 FOR XML PATH('')),1,1,'')         
 INTO #temp1        
       
 FROM #temp AS t4           
         
 --SELECT * FROM #temp1        
           
SELECT tci1.I_Corporate_Invoice_Id,SUM(tip1.N_Invoice_Amount) TotalAmt ,SUM(tip1.N_Tax_Amount) AS TTax         
INTO #temp2        
FROM CORPORATE.T_Corporate_Invoice AS tci1          
INNER JOIN CORPORATE.T_CorporateInvoice_StudentInvoice_Map AS tcisim        
ON tci1.I_Corporate_Invoice_Id = tcisim.I_Corporate_Invoice_Id        
INNER JOIN dbo.T_Invoice_Parent AS tip1        
ON tcisim.I_Invoice_Header_ID = tip1.I_Invoice_Header_ID        
WHERE tci1.I_Corporate_Plan_ID = @iCorporatePlanID        
GROUP BY tci1.I_Corporate_Invoice_Id        
        
SELECT t.I_Corporate_Invoice_Id,t.N_Excess_Amt,t.CheckID,t2.TotalAmt,t2.TTax,t.InvoiceIds,t.StudentIds FROM #temp1 AS t        
INNER JOIN #temp2 AS t2        
ON t.I_Corporate_Invoice_Id = t2.I_Corporate_Invoice_Id        
        
 DROP TABLE #temp        
 DROP TABLE #temp1        
 DROP TABLE #temp2          
         
    ---Table[1]  
           SELECT I_Corporate_Plan_ID ,    
                   I_Batch_ID FROM CORPORATE.T_Corporate_Plan_Batch_Map AS tcpbm    
           WHERE   tcpbm.I_Corporate_Plan_ID =  @iCorporatePlanID          
        
END
