-- =============================================  
-- Author:  Aritra Saha  
-- Create date: 12/03/2007  
-- Description: Update Followupinformation  
-- =============================================  
CREATE PROCEDURE [dbo].[ERP_uspSaveFollowUpDetails]   
(  
 -- Add the parameters for the stored procedure here  
 @iERPFollowUpTypeID INT = NULL,
 @iProsEmployeeID int,
 @dFollowUpDate datetime,  
 @sFollowUpRemarks NVARCHAR(MAX),  
 @FollowUpStatus CHAR = NULL,  --
 @iEnquiryRegnID int,  
 @EnquiryRegnType INT = NULL, --
 @dNextFollowUpDate datetime  

 --@iFollowUpClosureID int  
   
)  
  
AS  
BEGIN TRY  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT OFF  
  
    -- Update FollowUp Information for an Enquiry  
 BEGIN TRANSACTION      
 INSERT INTO dbo.T_Enquiry_Regn_FollowUp (  
   ERP_R_I_FollowupType_ID,
   I_Employee_ID,
   Dt_Followup_Date,
   S_Followup_Remarks,  
   S_Followup_Status,
   I_Enquiry_Regn_ID,    
   ERP_R_I_Enquiry_Type_ID,
   Dt_Next_Followup_Date  

   --I_Followup_Closure_ID
   )  
 VALUES  
  (  
  @iERPFollowUpTypeID,  
  @iProsEmployeeID,
  @dFollowUpDate,  
  @sFollowUpRemarks,
  @FollowUpStatus,
  @iEnquiryRegnID,
  @EnquiryRegnType,
  @dNextFollowUpDate  

  )  
    
  -- Status Code = 3 ; Closed Enquiry  
  --IF @iFollowUpClosureID <> 0   
  -- UPDATE  T_Enquiry_Regn_Detail SET I_Enquiry_Status_Code = 3 WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID  
     
  COMMIT TRANSACTION 
  
  Select 1 StatusFlag, 'Pre Enquiry Created Successfully' Message --, @iEnquiryID AS EnquiryRegnID, CAST(@iEnquiryID AS VARCHAR(20)) AS EnquiryNo

END TRY  
  
BEGIN CATCH  
 --Error occurred:    
 ROLLBACK TRANSACTION  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH

