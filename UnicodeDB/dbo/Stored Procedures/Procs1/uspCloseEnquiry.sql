
CREATE PROCEDURE [dbo].[uspCloseEnquiry]           
(             
  @iCenterID INT,    
  @iEnquiryID INT,      
  @iEnquiryStatus INT,         
  @sUpdatedBy NVARCHAR(max),    
  @dtUpdatedOn DATETIME ,
  @iNewEnquiryID NVARCHAR(max)     
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
  

-- UPDATE language part : By Susmita --- only executed for 109

if exists (select * from T_Student_Tags where I_Enquiry_Regn_ID=@iEnquiryID)
	BEGIN
		UPDATE T_Student_Tags 
		SET I_Enquiry_Status_Code = @iEnquiryStatus,
		S_Upd_By= @sUpdatedBy,    
		Dt_Upd_On = @dtUpdatedOn
		where I_Enquiry_Regn_ID=@iEnquiryID
	END
  
  
DECLARE @sFormNo nvarchar(max)	

SELECT  @sFormNo = S_Form_No FROM dbo.T_Enquiry_Regn_Detail WHERE I_Enquiry_Regn_ID=@iEnquiryID 
  UPDATE  dbo.T_Enquiry_Regn_Detail      
	SET   S_Form_No = @sFormNo  WHERE   I_Enquiry_Regn_ID = @iNewEnquiryID    
    
END TRY    
BEGIN CATCH    
 --Error occurred:      
    
 DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH


