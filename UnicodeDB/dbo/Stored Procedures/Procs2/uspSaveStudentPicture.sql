CREATE PROCEDURE [dbo].[uspSaveStudentPicture]  
    (  
      @iEnquiryID INT ,  
      @sPicture NVARCHAR(MAX)  
      --@sPicture NVARCHAR(MAX)  
    )  
AS   
    BEGIN TRY     
        UPDATE  dbo.T_Enquiry_Regn_Detail  
        SET     S_Student_Photo = @sPicture  
        WHERE   I_Enquiry_Regn_ID = @iEnquiryID    
    END TRY    
    BEGIN CATCH    
 --Error occurred:      
    
        DECLARE @ErrMsg NVARCHAR(4000) ,  
            @ErrSeverity INT    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()    
    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)    
    END CATCH

