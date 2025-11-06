CREATE PROCEDURE [dbo].[uspGetStudetForCT]     
(    
 @sStudentCode NVARCHAR(MAX) = NULL    
,@sStudentFName NVARCHAR(MAX)  = NULL    
,@sStudentMName NVARCHAR(MAX)  = NULL    
,@sStudentLName NVARCHAR(MAX)  = NULL    
,@sInvoiceNo NVARCHAR(MAX) = NULL    
,@iCentreId  INT    
)    
as    
begin    
 SELECT DISTINCT  SD.I_Student_Detail_ID        
   ,SD.S_Student_ID        
   ,SD.S_First_Name        
   ,SD.S_Middle_Name        
   ,SD.S_Last_Name        
   ,SD.I_Enquiry_Regn_ID 
 FROM T_Student_Detail SD        
 INNER JOIN T_Student_Center_Detail SCD        
  ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID  
 INNER JOIN dbo.T_Invoice_Parent IP
 ON SCD.I_Student_Detail_ID = IP.I_Student_Detail_ID       
 WHERE SCD.I_Centre_Id = @iCentreId        
 AND ISNULL(SD.I_Status,1) = 1        
 AND ISNULL(SCD.I_Status,1) = 1        
 AND SD.S_Student_ID LIKE ISNULL(@sStudentCode,SD.S_Student_ID )+'%'        
 AND SD.S_First_Name LIKE ISNULL(@sStudentFName,SD.S_First_Name )+'%'        
 AND ISNULL(SD.S_Middle_Name,'') LIKE ISNULL(@sStudentMName,'' )+'%'        
 AND SD.S_Last_Name LIKE ISNULL(@sStudentLName,SD.S_Last_Name )+'%'   
 AND IP.S_Invoice_No = ISNULL(@sInvoiceNo,IP.S_Invoice_No )
 AND (SD.I_Corporate_ID IS NULL OR SD.I_Corporate_ID = 0)   
     
end

