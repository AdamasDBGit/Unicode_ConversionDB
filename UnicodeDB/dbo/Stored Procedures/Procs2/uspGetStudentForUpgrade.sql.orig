CREATE PROCEDURE [dbo].[uspGetStudentForUpgrade] --NULL,'Sudipta',NULL,'das',NULL,null,13                  
(                  
 @sStudentCode VARCHAR(500) = NULL                  
,@sStudentFName VARCHAR(50)  = NULL                  
,@sStudentMName VARCHAR(50)  = NULL                  
,@sStudentLName VARCHAR(50)  = NULL                  
,@sInvoiceNo VARCHAR(200) = NULL     
,@sCourseCode VARCHAR(50)=NULL                 
,@iCentreId  INT                  
)                  
AS                  
BEGIN                  
SELECT  SD.I_Student_Detail_ID                  
   ,SD.S_Student_ID                  
   ,SD.S_First_Name                  
   ,SD.S_Middle_Name                  
   ,SD.S_Last_Name                 
   ,SD.I_Enquiry_Regn_ID          
   ,IP.[I_Invoice_Header_ID]           
   ,IP.[S_Invoice_No]          
   ,CM.[I_Course_ID]          
   ,CM.[S_Course_Name] 
   ,'20-Aug-2010' AS Dt_Last_Installment_Date
 FROM T_Student_Detail SD WITH(NOLOCK)              
 INNER JOIN T_Student_Center_Detail SCD WITH(NOLOCK) ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID          
 INNER JOIN [T_Invoice_Parent] IP WITH(NOLOCK)       ON SD.[I_Student_Detail_ID] = IP.[I_Student_Detail_ID]          
 INNER JOIN [T_Invoice_Child_Header] ICH WITH(NOLOCK)ON IP.[I_Invoice_Header_ID] = ICH.[I_Invoice_Header_ID]          
 INNER JOIN [T_Course_Master] CM WITH(NOLOCK)   ON ICH.[I_Course_ID] = CM.[I_Course_ID]          
 WHERE SCD.I_Centre_Id = @iCentreId                  
 AND ISNULL(SD.I_Status,1) = 1                  
 AND ISNULL(SCD.I_Status,1) = 1           
 AND IP.S_Invoice_No LIKE ISNULL(@sInvoiceNo,IP.S_Invoice_No )+'%'                 
 AND SD.S_Student_ID LIKE ISNULL(@sStudentCode,SD.S_Student_ID )+'%'                  
 AND SD.S_First_Name LIKE ISNULL(@sStudentFName,SD.S_First_Name )+'%'                  
 AND ISNULL(SD.S_Middle_Name,'') LIKE ISNULL(@sStudentMName,'' )+'%'                  
 AND SD.S_Last_Name LIKE ISNULL(@sStudentLName,SD.S_Last_Name )+'%'    
 AND CM.[S_Course_Name] LIKE  ISNULL(@sCourseCode,CM.[S_Course_Name])+'%'       
 EXCEPT      
 SELECT  SD.I_Student_Detail_ID                  
   ,SD.S_Student_ID                  
   ,SD.S_First_Name                  
   ,SD.S_Middle_Name                  
   ,SD.S_Last_Name                 
   ,SD.I_Enquiry_Regn_ID          
   ,IP.[I_Invoice_Header_ID]           
   ,IP.[S_Invoice_No]          
   ,CM.[I_Course_ID]          
   ,CM.[S_Course_Name] 
   ,'20-Aug-2010' AS Dt_Last_Installment_Date                
 FROM T_Student_Detail SD WITH(NOLOCK)              
 INNER JOIN T_Student_Center_Detail SCD WITH(NOLOCK) ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID          
 INNER JOIN [T_Invoice_Parent] IP WITH(NOLOCK)       ON SD.[I_Student_Detail_ID] = IP.[I_Student_Detail_ID]              
 INNER JOIN T_Student_Upgrade_Detail SUD WITH(NOLOCK)  ON IP.I_Invoice_Header_ID =  SUD.I_Previous_Invoice_Header_ID      
              AND SUD.I_Upgrade_Invoice_Header_Id IS NOT NULL      
 INNER JOIN [T_Course_Master] CM WITH(NOLOCK)   ON SUD.[I_Course_ID] = CM.[I_Course_ID]       
 WHERE SCD.I_Centre_Id = 13               
 AND ISNULL(SD.I_Status,1) = 1                  
 AND ISNULL(SCD.I_Status,1) = 1           
 AND IP.S_Invoice_No LIKE ISNULL(@sInvoiceNo,IP.S_Invoice_No )+'%'                 
 AND SD.S_Student_ID LIKE ISNULL(@sStudentCode,SD.S_Student_ID )+'%'                  
 AND SD.S_First_Name LIKE ISNULL(@sStudentFName,SD.S_First_Name )+'%'                  
 AND ISNULL(SD.S_Middle_Name,'') LIKE ISNULL(@sStudentMName,'' )+'%'                  
 AND SD.S_Last_Name LIKE ISNULL(@sStudentLName,SD.S_Last_Name )+'%'     
 AND CM.[S_Course_Name] LIKE  ISNULL(@sCourseCode,CM.[S_Course_Name])+'%'                        
END              
---------------------------------------------------------------------------------------------------------------------------------------              
              
      
-------------------------------------------------------------------------------------------------------------------------------------------      
--------------------------------------------
