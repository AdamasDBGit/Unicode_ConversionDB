CREATE PROC [dbo].[uspCheckIfStudentEnquiryPresent]     
(            
 @sEnquiryID VARCHAR(500) ,           
 @dtDOB DATETIME  = NULL         
)            
AS             
BEGIN            
           
 DECLARE @sUserType VARCHAR(50)          
 DECLARE @sLoginID   VARCHAR(50)    
           
 SET NOCOUNT ON            
     
        
          
      SELECT I_Enquiry_Regn_ID,Dt_Birth_Date,S_First_Name,S_Middle_Name,S_Last_Name,S_Email_ID FROM dbo.T_Enquiry_Regn_Detail AS terd     
      WHERE terd.I_Enquiry_Regn_ID = @sEnquiryID AND terd.Dt_Birth_Date = ISNULL(@dtDOB,terd.Dt_Birth_Date)    
          
END
