--exec [ERP_uspGetStudentMedicalDetails] 116148
CREATE PROCEDURE [dbo].[ERP_uspGetStudentMedicalDetails]      
    (  
      --@Centre INT , 

	   @StudentID int=null, 
	 @iEnquiryRegnID int = null
    )  
AS   
 SET NOCOUNT ON        
    BEGIN TRY                    
                       
        BEGIN TRANSACTION    
		IF @StudentID IS NULL
		BEGIN
		SELECT @StudentID = I_Student_Detail_ID
		FROM dbo.T_Student_Detail
		WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID; 
		END
		select 
		   
		I_Student_Detail_ID  
		,I_Is_Allergies IsAllergies 
		,S_Allergies SAllergies
		,I_Is_Chronic IsChronic
		,S_Chronic SChronic
		,I_Is_Disabilities IsDisabilities
		,S_Disabilities Disabilities
		,S_Additional SAdditional
		from T_ERP_Student_Medical_Details
		where  I_Student_Detail_ID = @StudentID   
        COMMIT TRANSACTION        
                
    END TRY                    
    BEGIN CATCH                    
 --Error occurred:                      
        ROLLBACK TRANSACTION                     
        DECLARE @ErrMsg NVARCHAR(4000) ,  
				@ErrSeverity INT                    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()                    
                    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                    
    END CATCH
