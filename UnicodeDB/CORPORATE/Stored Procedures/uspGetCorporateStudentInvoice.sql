CREATE PROCEDURE [CORPORATE].[uspGetCorporateStudentInvoice] --1,9,'1/1/2011','1/1/2012'                                  
(                                    
 -- Add the parameters for the stored procedure here                                    
 @iCorporateID int = NULL,                                  
 @iCorporatePlanID int = NULL,                                  
 @dtStartDate datetime = NULL,                                    
 @dtEndDate datetime = NULL                            
)                                    
                                    
AS                                    
BEGIN                                    
 -- SET NOCOUNT ON added to prevent extra result sets from                                    
 -- interfering with SELECT statements.                                    
 SET NOCOUNT ON                                    
      ---Table[0]                    
SELECT terd.I_Enquiry_Regn_ID,tcm.S_Center_Name,tsd.I_Student_Detail_ID,tsd.S_Student_ID,                
tsd.S_First_Name + ' '+ tsd.S_Last_Name AS StudentName,tip.I_Invoice_Header_ID,tip.S_Invoice_No,tip.N_Invoice_Amount, tip.N_Tax_Amount,                
tcp1.I_Corporate_Plan_Type_ID,tcp1.N_Percent_Student_Share, CheckID =                
CASE tcisim.I_Invoice_Header_ID               
  WHEN tip.I_Invoice_Header_ID THEN 'Y'                
  ELSE 'N'                
END                
FROM dbo.T_Enquiry_Regn_Detail AS terd                        
INNER JOIN dbo.T_Centre_Master AS tcm                        
ON terd.I_Centre_Id = tcm.I_Centre_Id                        
INNER JOIN dbo.T_Student_Detail AS tsd                        
ON terd.I_Enquiry_Regn_ID = tsd.I_Enquiry_Regn_ID                        
INNER JOIN dbo.T_Invoice_Parent AS tip                        
ON tsd.I_Student_Detail_ID = tip.I_Student_Detail_ID                
INNER JOIN CORPORATE.T_Corporate_Plan AS tcp1                  
ON   terd.I_Corporate_Plan_ID = tcp1.I_Corporate_Plan_ID                  
LEFT OUTER JOIN CORPORATE.T_CorporateInvoice_StudentInvoice_Map AS tcisim               
ON tip.I_Invoice_Header_ID = tcisim.I_Invoice_Header_ID                
WHERE terd.I_Corporate_ID = @iCorporateID AND terd.I_Corporate_Plan_ID = @iCorporatePlanID                        
AND CAST(CONVERT(VARCHAR(10), tsd.Dt_Crtd_On, 101) AS DATETIME) >= ISNULL(@dtStartDate,CAST(CONVERT(VARCHAR(10), tsd.Dt_Crtd_On, 101) AS DATETIME))                                       
AND CAST(CONVERT(VARCHAR(10), tsd.Dt_Crtd_On, 101) AS DATETIME) <= ISNULL(@dtEndDate, CAST(CONVERT(VARCHAR(10), tsd.Dt_Crtd_On, 101) AS DATETIME))                         
            
---Table[1]                    
SELECT I_Corporate_Plan_ID ,            
        S_Corporate_Plan_Name ,            
        I_Corporate_ID ,            
        Dt_Valid_From ,            
        Dt_Valid_To ,            
        B_Is_Fund_Shared ,            
        I_Corporate_Plan_Type_ID ,            
        I_Minimum_Strength ,            
        I_Maximum_Strength ,            
        N_Percent_Student_Share ,            
        I_Status ,            
        S_Crtd_By ,            
        S_Updt_by ,            
        Dt_Crtd_On ,            
        Dt_Updt_On             
        FROM CORPORATE.T_Corporate_Plan AS tcp1            
        WHERE tcp1.I_Corporate_Plan_ID = @iCorporatePlanID            
                    
       ---Table[2]                    
                    
         SELECT COUNT(I_Student_Detail_ID) AS NoOfStudents  FROM dbo.T_Student_Detail AS tsd          
    INNER JOIN dbo.T_Enquiry_Regn_Detail AS terd          
    ON tsd.I_Enquiry_Regn_ID = terd.I_Enquiry_Regn_ID          
    WHERE terd.I_Corporate_Plan_ID = @iCorporatePlanID          
            
    ---Table[3]        
            
    SELECT I_Corporate_Invoice_Id ,        
            I_Corporate_Plan_ID ,        
            S_Crtd_By ,        
            S_Upd_By ,        
            Dt_Crtd_On ,        
            Dt_Upd_On ,        
            I_Status ,        
            N_Excess_Amt FROM CORPORATE.T_Corporate_Invoice AS tci12        
           WHERE tci12.I_Corporate_Plan_ID = @iCorporatePlanID        
                 
    ---Table[4]        
          
           SELECT I_Corporate_Plan_ID ,      
                   I_Batch_ID FROM CORPORATE.T_Corporate_Plan_Batch_Map AS tcpbm      
           WHERE   tcpbm.I_Corporate_Plan_ID =  @iCorporatePlanID          
                         
          
END
