CREATE PROCEDURE [dbo].[uspCloseEnquiry_BKP_LANG]           
(             
  @iCenterID INT,    
  @iEnquiryID INT,      
  @iEnquiryStatus INT,         
  @sUpdatedBy VARCHAR(20),    
  @dtUpdatedOn DATETIME ,
  @iNewEnquiryID VARCHAR(20)     
)            
AS            
BEGIN TRY    
UPDATE  dbo.T_Enquiry_Regn_Detail      
SET     I_Enquiry_Status_Code = @iEnquiryStatus,   
  S_Mobile_No = NULL,  
  S_Upd_By= @sUpdatedBy,    
  Dt_Upd_On = @dtUpdatedOn      
WHERE   I_Enquiry_Regn_ID = @iEnquiryID     
  AND I_Centre_Id = @iCenterID    
  
  
DECLARE @sFormNo varchar(100)	

SELECT  @sFormNo = S_Form_No FROM dbo.T_Enquiry_Regn_Detail WHERE I_Enquiry_Regn_ID=@iEnquiryID 
  UPDATE  dbo.T_Enquiry_Regn_Detail      
	SET   S_Form_No = @sFormNo  WHERE   I_Enquiry_Regn_ID = @iNewEnquiryID    
    
END TRY    
BEGIN CATCH    
 --Error occurred:      
    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH 
