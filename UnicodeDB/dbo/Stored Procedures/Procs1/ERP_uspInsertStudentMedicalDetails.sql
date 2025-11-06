CREATE PROCEDURE [dbo].[ERP_uspInsertStudentMedicalDetails]      
    (  
       @EnquiryRegnID int = NULL,
	   @StudentID int =NULL
	  ,@IsAllergies int=null
	  ,@SAllergies nvarchar(MAX)=null
	  ,@IsChronic int = null
	  ,@SChronic nvarchar(MAX)=null
	  ,@IsDisabilities int=null
	  ,@SDisabilities nvarchar(MAX)=null
	  ,@SAdditional nvarchar(MAX)=null
    )  
AS   
 SET NOCOUNT ON        
    BEGIN TRY   
	IF @StudentID IS NULL
	BEGIN

		SELECT @StudentID = I_Student_Detail_ID
		FROM dbo.T_Student_Detail
		WHERE I_Enquiry_Regn_ID = @EnquiryRegnID; 
	END
        BEGIN TRANSACTION     
		IF NOT EXISTS(select * from T_ERP_Student_Medical_Details 
		where I_Student_Detail_ID=@StudentID 
		)
		BEGIN
        INSERT INTO T_ERP_Student_Medical_Details
		(
		 I_Student_Detail_ID
		,I_Is_Allergies
		,S_Allergies
		,I_Is_Chronic
		,S_Chronic
		,I_Is_Disabilities
		,S_Disabilities
		,S_Additional
		,S_CreatedBy
		,Dt_CreatedAt

		)
		VALUES
		(
		 @StudentID
		,@IsAllergies
		,@SAllergies
		,@IsChronic
		,@SChronic
		,@IsDisabilities
		,@SDisabilities
		,@SAdditional
		,'dba'
		,GETDATE()
		)
		select 1 StatusFlag,'Medical details saved succesfully!' Message
              END
			  ELSE
			  BEGIN
			  update T_ERP_Student_Medical_Details
			  set 
			   I_Is_Allergies      = 	 @IsAllergies
			  ,S_Allergies		   = 	 @SAllergies
			  ,I_Is_Chronic		   = 	 @IsChronic
			  ,S_Chronic		   = 	 @SChronic
			  ,I_Is_Disabilities   = 	 @IsDisabilities
			  ,S_Disabilities	   = 	 @SDisabilities
			  ,S_Additional		   =	 @SAdditional
			  ,S_CreatedBy		   = 	 'dba'
			  ,Dt_UpdatedAt		   = 	 GETDATE()
			  where I_Student_Detail_ID = @StudentID
		select 1 StatusFlag,'Medical details updated succesfully!' Message
			  END
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
