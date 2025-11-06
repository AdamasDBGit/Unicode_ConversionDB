CREATE PROCEDURE [dbo].[uspReleaseTransCertificate]  
    @iStudentID INT ,  
    @iRequestStatus INT ,/* status 2 = Approved, 1 = Initiated ;For this Sp it will be 2*/  
    @iTC_Serial_No VARCHAR ,  
    @iRelease_Date DATETIME  ,
    @SRemarks varchar(500) ,
    @sUpdatedBy VARCHAR(20),
    @DtUpdatedOn DATETIME     
AS   
    BEGIN TRY    
        DECLARE @initiated BIT ;    
        SET @initiated = 0 ;    
        SET NOCOUNT OFF    
		DECLARE @I_Transfer_Cert_Req_ID INT      
        IF EXISTS ( SELECT  *  
                    FROM    T_Transfer_Certificates  
                    WHERE   I_Student_Detail_ID = @iStudentID  
                            AND I_Transfer_Req_Status = @iRequestStatus )   
            BEGIN    
                SELECT @I_Transfer_Cert_Req_ID=I_Transfer_Cert_Req_ID FROM dbo.T_Transfer_Certificates
				WHERE   I_Student_Detail_ID = @iStudentID  
                            AND I_Transfer_Req_Status = @iRequestStatus
                
                
                UPDATE  T_Transfer_Certificates  
                SET     TC_Serial_No = @iTC_Serial_No ,  
                        Release_Date = @iRelease_Date ,  
                        Is_Released = 1  ,
                        S_Remarks = @SRemarks,
                        S_Upd_By =@sUpdatedBy ,
						Dt_Upd_On = @DtUpdatedOn
                WHERE   I_Student_Detail_ID = @iStudentID  
                        AND I_Transfer_Req_Status = @iRequestStatus 

				
				INSERT  INTO T_Transfer_Certificates_Audit_Trial  
                        ( I_Transfer_Cert_Req_ID ,  
                          I_Transfer_Req_Status ,   
                          S_Remarks ,
                          Is_Released ,
                          S_Crtd_By,Dt_Crtd_On   
                        )  
                        VALUES
                        ( @I_Transfer_Cert_Req_ID,@iRequestStatus,@SRemarks,1,@sUpdatedBy ,@DtUpdatedOn )
							 
                                         
      
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
