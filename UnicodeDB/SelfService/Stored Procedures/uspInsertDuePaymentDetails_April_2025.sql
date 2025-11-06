create PROCEDURE [SelfService].[uspInsertDuePaymentDetails_April_2025]  
    (  
      @iBrandID VARCHAR(MAX) ,  
      @sStudentID VARCHAR(MAX) ,  
      @iInvoiceHeaderID INT ,  
      @iCentreId INT ,  
      @ReceiptAmount NUMERIC(18, 2) ,  
      @ReceiptTaxAmount NUMERIC(18, 2) ,  
      @iReceiptType INT = 2 ,  
      @sPaymentDetailsXML XML ,  
      @sTransactionCode VARCHAR(MAX) ,  
      @sSource VARCHAR(MAX)  
    )  
AS  
    SET NOCOUNT ON   
      
    --SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  
     
  
  
  
   
    BEGIN TRY  
  
       BEGIN TRANSACTION  
          
          
  
          
        DECLARE @sReceiptNo VARCHAR(MAX)= NULL  
        DECLARE @iStudentDetailID INT  
        DECLARE @iReceiptHeader INT= 0  
        DECLARE @paymentmodeid INT  
  DECLARE @rdate DATETIME=GETDATE()  
          
          
          
        IF @sSource='Online-SelfService'  
   SET @paymentmodeid=26   
          
              
              
              
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
                              
                              
                          
                                  
  EXEC dbo.uspInsertReceiptHeaderFromAPI @sReceiptNo, -- varchar(20)  
   @iInvoiceHeaderID, -- int  
   @rdate, -- datetime  
   @iStudentDetailID, -- int  
   @paymentmodeid, -- int  
   @iCentreId, -- int  
   @ReceiptAmount, -- numeric  
   @ReceiptTaxAmount, -- numeric  
   'N', -- char(1)  
   'rice-group-admin', -- varchar(20)  
   @rdate, -- datetime  
   NULL, -- numeric  
   NULL, -- varchar(12)  
   NULL, -- varchar(500)  
   NULL, -- varchar(20)  
   NULL, -- varchar(12)  
   NULL, -- varchar(50)  
   NULL, -- varchar(20)  
   @iReceiptType, -- int  
   @iBrandID, -- int  
   '', -- varchar(500)  
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
     
                 
  
        COMMIT TRANSACTION  
          
        --EXEC dbo.uspSendSMSForOnlinePayments @iBrandID = @iBrandID, -- int  
        --    @sTransactionNo = @sTransactionCode -- varchar(max)   
          
    END TRY  
    BEGIN CATCH  
  
 --Error occurred:        
        ROLLBACK TRANSACTION      
        DECLARE @ErrMsg NVARCHAR(4000) ,  
         @ErrSeverity INT,@errline int      
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY() ,
			@errline=ERROR_LINE()
      
        RAISERROR(@ErrMsg, @ErrSeverity, 1)  
		--Select @ErrMsg+' '+@errline as Message
		Insert Into tEst (Test) Values('uspInsertDuePaymentDetails')
  
    END CATCH
