-- =============================================    
-- Author:  Aritra Saha    
-- Create date: 12/03/2007    
-- Description: Get the list of FollowUps for an Enquiry    
-- =============================================    
CREATE PROCEDURE [dbo].[uspGetFollowUpList]     
(    
 -- Add the parameters for the stored procedure here    
 @iEnquiryRegnID INT,  
 @dtFollowUpFromDate DATETIME = NULL,  
 @dtFollowUpToDate DATETIME = NULL    
)    
    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT OFF    
    
   -- Table[0] Enquiry Course Details      
 SELECT      
  A.I_Followup_ID,    
  B.S_First_Name,    
  B.S_Middle_Name,    
  B.S_Last_Name,    
  A.Dt_Followup_Date,    
  A.Dt_Next_Followup_Date,    
  A.S_Followup_Remarks    
 FROM     
  dbo.T_Enquiry_Regn_FollowUp A LEFT JOIN dbo.T_Employee_Dtls B  ON A.I_Employee_ID = B.I_Employee_ID    
 WHERE    
  A.I_Enquiry_Regn_ID = @iEnquiryRegnID    
  AND CAST(CONVERT(VARCHAR(10), ISNULL(Dt_Next_Followup_Date,'1/1/2000'), 101) AS DATETIME) >= ISNULL(@dtFollowUpFromDate,'1/1/2000')       
   AND CAST(CONVERT(VARCHAR(10), ISNULL(Dt_Next_Followup_Date,GETDATE()), 101) AS DATETIME) <= ISNULL(@dtFollowUpToDate,Dt_Next_Followup_Date)   
 ORDER BY A.Dt_Next_Followup_Date DESC    
     
      
     
END
