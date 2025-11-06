CREATE PROCEDURE [dbo].[uspRequestForTransCertificate]  
    @iStudentID INT ,  
    @iRequestStatus INT ,   
    @SRemarks varchar(500) ,
    @sCreatedBy VARCHAR(20),	
	--@sUpdatedBy VARCHAR(20),
	@DtCreatedOn DATETIME
	--@DtUpdatedOn DATETIME  
AS   
    BEGIN TRY    
        SET NOCOUNT OFF
        DECLARE @I_Transfer_Cert_Req_ID INT     
     
        IF NOT EXISTS ( SELECT  *  
                        FROM    T_Transfer_Certificates  
                        WHERE   I_Student_Detail_ID = @iStudentID  
                                AND I_Transfer_Req_Status = @iRequestStatus )   
            BEGIN    
                INSERT  INTO T_Transfer_Certificates  
                        ( I_Student_Detail_ID ,  
                          I_Transfer_Req_Status ,   
                          S_Remarks ,
                          S_Crtd_By,Dt_Crtd_On   
                        )  
                VALUES  ( @iStudentID ,  
                          @iRequestStatus ,   
                          @SRemarks ,
                          @sCreatedBy ,  @DtCreatedOn  
                        )
                 SELECT  @I_Transfer_Cert_Req_ID = @@IDENTITY 
                 
                 INSERT  INTO T_Transfer_Certificates_Audit_Trial  
                        ( I_Transfer_Cert_Req_ID ,  
                          I_Transfer_Req_Status ,   
                          S_Remarks ,
                          S_Crtd_By,Dt_Crtd_On     
                        )  
                 VALUES  ( @I_Transfer_Cert_Req_ID ,  
                          @iRequestStatus ,   
                          @SRemarks ,
                          @sCreatedBy ,  @DtCreatedOn     
                        )
                    
            END    
     
    END TRY    
    
    BEGIN CATCH    
 --Error occurred:      
    
        DECLARE @ErrMsg NVARCHAR(4000) ,  
            @ErrSeverity INT    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()    
    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)    
    END CATCH
