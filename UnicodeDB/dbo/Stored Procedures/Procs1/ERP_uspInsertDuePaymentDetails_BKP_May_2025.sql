
CREATE PROCEDURE [dbo].[ERP_uspInsertDuePaymentDetails_BKP_May_2025]      
    (      
      @iBrandID Nnvarchar(max) ,      
      @sStudentID Nnvarchar(max) ,      
      @iInvoiceHeaderID INT ,      
      @iCentreId INT ,      
      @ReceiptAmount NUMERIC(18, 2) ,      
      @ReceiptTaxAmount NUMERIC(18, 2) ,      
      @iReceiptType INT = 2 ,      
      @sPaymentDetailsXML XML ,      
      @sTransactionCode Nnvarchar(max) ,      
      @sSource Nnvarchar(max),    
   -------New Parameter Added for Payment Information-----        
      @nCreditCardNo NUMERIC(18, 0)=Null ,        
      @dCreditCardExpiry Nnvarchar(max)=null ,        
      @sCreditCardIssuer Nnvarchar(max) =null,        
      @sChequeDDNo Nnvarchar(max) =null,        
      @dChequeDDDate Nnvarchar(max)=null ,        
      @sBankName Nnvarchar(max)=null ,        
      @sBranchName Nnvarchar(max)=null ,        
      @sNarration Nnvarchar(max)=null,    
      @paymentmodeid int,
	  @Createdby Nnvarchar(max)='rice-group-admin'
    )      
AS      
    SET NOCOUNT ON       
          
    --SET TRANSACTION ISOLATION LEVEL SERIALIZABLE      
         
      
      
       Insert into tEst(Test) Values('uspInsertDuePaymentDetails'+GETDATE())  
  
       
    BEGIN TRY      
      
       BEGIN TRANSACTION      
              
              
      
              
        DECLARE @sReceiptNo nvarchar(max)= NULL      
        DECLARE @iStudentDetailID INT      
        DECLARE @iReceiptHeader INT= 0      
        --DECLARE @paymentmodeid INT      
  DECLARE @rdate DATETIME=GETDATE()      
              
              
              
   --     IF @sSource='Online-SelfService'      
   --SET @paymentmodeid=26       
              
                  
                  
                  
        --IF NOT EXISTS(SELECT * FROM dbo.T_Student_Detail AS TSD      
        --        INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON TSCD.I_Student_Detail_ID = TSD.I_Student_Detail_ID      
        --        INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID=TSCD.I_Centre_Id      
        --        WHERE   TSD.S_Student_ID = @sStudentID AND TSD.I_Status=1 AND TCHND.I_Brand_ID=@iBrandID AND TSCD.I_Status=1)      
        --BEGIN      
              
        --RAISERROR('Invalid Student ID! Please contact your institution.',11,1)       
              
        --END      
              
                 
                  
                  
        --IF EXISTS ( SELECT  *      
        --            FROM    dbo.T_OnlinePayment_Receipt_Mapping AS TOPRM      
        --            WHERE   TOPRM.S_Transaction_No = @sTransactionCode      
        --                    AND TOPRM.S_Crtd_By = @sSource )      
        --    RAISERROR('Duplicate Transaction Code',11,1)       
                  
                  
                  
                       
       
      
        
        SELECT  @iStudentDetailID = TSD.I_Student_Detail_ID      
        FROM    dbo.T_Student_Detail AS TSD      
        INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON TSCD.I_Student_Detail_ID = TSD.I_Student_Detail_ID      
        INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID=TSCD.I_Centre_Id      
        WHERE   TSD.S_Student_ID = @sStudentID AND TSD.I_Status=1 AND TCHND.I_Brand_ID=@iBrandID AND TSCD.I_Status=1      
                                  
                                  
                              
                                      
  EXEC dbo.uspInsertReceiptHeaderFromAPI @sReceiptNo, -- nvarchar(max)      
   @iInvoiceHeaderID, -- int      
   @rdate, -- datetime      
   @iStudentDetailID, -- int      
   @paymentmodeid, -- int      
   @iCentreId, -- int      
   @ReceiptAmount, -- numeric      
   @ReceiptTaxAmount, -- numeric      
   'N', -- char(1)      
   @Createdby, -- nvarchar(max)      
   @rdate, -- datetime      
   Null,--@nCreditCardNo, -- nvarchar(max)      
   Null,--@dCreditCardExpiry, -- nvarchar(max)      
   Null,--@sCreditCardIssuer, -- nvarchar(max)      
   Null,--@sChequeDDNo, -- nvarchar(max)      
   Null,--@dChequeDDDate, -- nvarchar(max)      
   Null,--@sBankName,    
   Null,--@sBranchName,    
   @iReceiptType,    
   @iBrandID,    
   Null,--@sNarration,     
   @sPaymentDetailsXML,     
   @iReceiptHeader OUTPUT      
                                                  
                                                  
            PRINT @iReceiptHeader      
      
   IF(@iReceiptHeader>0)      
   BEGIN      
      
    update SelfService.T_Online_Payment_Master set ReceiptHeaderID=@iReceiptHeader,ReceiptDate=@rdate      
    where      
    TransactionNo=@sTransactionCode and InvoiceHeaderID=@iInvoiceHeaderID and StatusID=1      
      
   END      
   ELSE      
   BEGIN      
      
    RAISERROR('Receipt could not be created',11,1)      
      
   END      
      
   select @iReceiptHeader as ReceiptHeaderID    
      --select 1 as ReceiptHeaderID    
   Insert into tEst(Test) Values('uspInsertDuePaymentDetails')  
         
        -- DECLARE @ErrorMessage NVARCHAR(4000);  
        --DECLARE @ErrorSeverity INT;  
        --DECLARE @ErrorState INT;  
  
        --SELECT  
        --    @ErrorMessage = ERROR_MESSAGE(),  
        --    @ErrorSeverity = ERROR_SEVERITY(),  
        --    @ErrorState = ERROR_STATE();  
        --INSERT INTO ERP_ErrorLogTable (ErrorMessage, ErrorSeverity, ErrorState, ErrorProcedure)  
        --VALUES (@ErrorMessage, @ErrorSeverity, @ErrorState, 'ERP_uspInsertDuePaymentDetails_1');            
     
        COMMIT TRANSACTION      
              
        --EXEC dbo.uspSendSMSForOnlinePayments @iBrandID = @iBrandID, -- int      
        --    @sTransactionNo = @sTransactionCode -- varchar(max)       
              
    END TRY      
    BEGIN CATCH      
      
 --Error occurred:   
        DECLARE @ErrorMessage Nnvarchar(max);  
        DECLARE @ErrorSeverity INT;  
        DECLARE @ErrorState INT;  
  
        SELECT  
            @ErrorMessage = ERROR_MESSAGE(),  
            @ErrorSeverity = ERROR_SEVERITY(),  
            @ErrorState = ERROR_STATE();  
        --INSERT INTO ERP_ErrorLogTable (ErrorMessage, ErrorSeverity, ErrorState, ErrorProcedure)  
        --VALUES (@ErrorMessage, @ErrorSeverity, @ErrorState, 'ERP_uspInsertDuePaymentDetails');  
        ROLLBACK TRANSACTION          
        DECLARE @ErrMsg Nnvarchar(max) ,      
        @ErrSeverity INT          
        SELECT  @ErrMsg = ERROR_MESSAGE() ,      
                @ErrSeverity = ERROR_SEVERITY()    
    Select @ErrMsg  as ErrorMessage   
          
       RAISERROR(@ErrMsg, @ErrSeverity, 1)       
      
    END CATCH

