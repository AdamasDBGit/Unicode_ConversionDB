CREATE PROCEDURE [dbo].[uspCancelReceipt]      -- [dbo].[uspCancelReceipt] 3965,'',null  
    (  
      @iReceiptHeaderId INT ,  
      @sCancellationReason NVARCHAR(MAX) ,  
      @sUpdatedBy NVARCHAR(MAX) = NULL,  
      @iFlag INT--akash      
    )  
AS   
    BEGIN TRY        
        DECLARE @iInvoiceHeaderID INT        
        DECLARE @dtInvoiceDate DATETIME        
        DECLARE @dtReceiptDate DATETIME        
        DECLARE @iStudentDetailID INT        
        DECLARE @iCenterID INT        
      
        BEGIN TRANSACTION      
        
        SELECT  @iInvoiceHeaderID = RH.I_Invoice_Header_ID ,  
                @dtReceiptDate = RH.Dt_Receipt_Date  
        FROM    T_Receipt_Header RH  
                INNER JOIN dbo.T_Invoice_Parent IP ON RH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID  
        WHERE   RH.I_Receipt_Header_ID = @iReceiptHeaderId  
                AND IP.I_Status <> 0        
        
        IF @iInvoiceHeaderID IS NOT NULL   
            BEGIN        
                SELECT  @dtInvoiceDate = Dt_Invoice_Date  
                FROM    dbo.T_Invoice_Parent  
                WHERE   I_Invoice_Header_ID = @iInvoiceHeaderID        
           
           
                IF DATEDIFF(minute, @dtInvoiceDate, @dtReceiptDate) < 2   
                    BEGIN        
                        SELECT  1          
        
                        SELECT  @iStudentDetailID = I_Student_Detail_ID ,  
                                @iCenterID = I_Centre_Id  
                        FROM    dbo.T_Invoice_Parent  
                        WHERE   I_Invoice_Header_ID = @iInvoiceHeaderID        
            
                        --IF NOT EXISTS ( SELECT  *  
                        --                FROM    ACADEMICS.T_Dropout_Details  
                        --                WHERE   I_Student_Detail_ID = @iStudentDetailID  
                        --                        AND I_Dropout_Type_ID = 2  
                        --                        AND I_Dropout_Status = 1 )   
                        --    BEGIN        
                        --        INSERT  INTO ACADEMICS.T_Dropout_Details  
                        --                ( I_Dropout_Status ,  
                        --                  I_Student_Detail_ID ,  
                        --                  I_Center_Id ,  
                        --                  Dt_Dropout_Date ,  
                        --                  I_Dropout_Type_ID ,  
                        --                  S_Crtd_By ,  
                        --                  S_Reason ,  
                        --                  Dt_Crtd_On  
                        --                )  
                        --        VALUES  ( 1 ,  
                        --                  @iStudentDetailID ,  
                        --                  @iCenterID ,  
                        --                  GETDATE() ,  
                        --                  2 ,  
                        --                  'SYSTEM' ,  
                        --                  'Admission Cheque Bounce' ,  
                        --                  GETDATE()  
                        --                )        
        
                        --        UPDATE  dbo.T_Student_Detail  
                        --        SET     I_Status = 0 ,  
                        --                S_Upd_By = 'SYSTEM' ,  
                        --                Dt_Upd_On = GETDATE()  
                        --        WHERE   I_Student_Detail_ID = @iStudentDetailID        
                        --    END        
                    END        
                ELSE   
                    BEGIN        
                        SELECT  1        
                    END        
            END        
        ELSE   
            BEGIN        
                SELECT  0        
            END        
           
        UPDATE  T_Receipt_Header  
        SET     I_Status = 0 ,  
                S_Upd_By = @sUpdatedBy ,  
                Dt_Upd_On = GETDATE() ,  
                S_Cancellation_Reason = @sCancellationReason  
        WHERE   I_Receipt_Header_ID = @iReceiptHeaderId  
        AND I_Status=1--akash 4.2.2017  
        
        IF NOT EXISTS  
		(  
		  SELECT 1  
		  FROM T_Invoice_OnAccount_Details  
		  WHERE 
		  I_Receipt_Header_ID = @iReceiptHeaderId  
		  AND I_Status=0
		 )  
		 BEGIN
		 
			EXEC dbo.uspInsertInvoiceDetailsForOnAccountReceipt @iReceiptHeaderId
			
		 END
        
        EXEC uspInsertCreditNoteForCancelReceipt @iReceiptHeaderId  
          
        PRINT @iReceiptHeaderId;  
        PRINT @iStudentDetailID;  
        PRINT @iCenterID;  
        PRINT @iFlag;   
          
      
    
        COMMIT TRANSACTION   
          
  
    END TRY        
    BEGIN CATCH        
        ROLLBACK TRANSACTION       
        DECLARE @ErrMsg NVARCHAR(4000) ,  
            @ErrSeverity INT        
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()        
        
        RAISERROR(@ErrMsg, @ErrSeverity, 1)        
        
    END CATCH    
      
         --akash   
        EXEC dbo.uspInsertReceiptCancelDataforSMS @iReceiptHeaderID = @iReceiptHeaderId, -- int  
            @iFlag = @iFlag -- int  
        --akash   

