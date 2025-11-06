CREATE  procedure [dbo].[ERP_uspInsertOnAccPaymentDetailsFromAPI]  
(  
@DueID INT=null,  
@StudentID NVARCHAR(MAX)=Null,  
@BrandID INT,  
@CenterID INT,  
@TransactionNo NVARCHAR(MAX),  
@TransactionDate DATETIME,  
@TransactionStatus NVARCHAR(MAX),  
@TransactionSource NVARCHAR(MAX),  
@TransactionMode NVARCHAR(MAX),  
@Amount DECIMAL(14,2),  
@Tax DECIMAL(14,2),  
@OnAccReceiptTypeID INT=Null,  
@RawData NVARCHAR(MAX)=NULL ,
@Is_Online_Payment bit
)  
AS  
BEGIN TRY  
  
  DECLARE @iReceiptHeader INT=0  
  DECLARE @dtDate DATETIME=GETDATE()  
  DECLARE @PaymentModeID INT=0  
  DECLARE @iStudentDetailID INT=0  
  
  
  BEGIN TRANSACTION  
  SET @DueID=(
select top 1 ID from SelfService.T_OnAccount_Due where 
	--ID=@DueID and 
	I_Student_Detail_ID=@StudentID 
	and OnAccReceiptTypeID=@OnAccReceiptTypeID and StatusID=1  
                and ReceiptHeaderID IS NULL and PaidOn IS NULL 
  )
   --IF (@TransactionSource='Online-SelfService')  
   -- SET @PaymentModeID=27  
  
   IF NOT EXISTS  
   (  
    select 1 from SelfService.T_OnAccount_Due where 
	ID=@DueID and 
	I_Student_Detail_ID=@StudentID 
	and OnAccReceiptTypeID=@OnAccReceiptTypeID and StatusID=1  
                and ReceiptHeaderID IS NULL and PaidOn IS NULL  
   )  
   BEGIN  
  
    RAISERROR('No such due exists',11,1)   
    
   END  
   ELSE IF  
   (  
    (select Amount from SelfService.T_OnAccount_Due where ID=@DueID and ReceiptHeaderID IS NULL and StatusID=1)<>@Amount  
    OR  
    (select Tax from SelfService.T_OnAccount_Due where ID=@DueID and ReceiptHeaderID IS NULL and StatusID=1)<>@Tax  
   )  
   BEGIN  
  
    RAISERROR('Due amount does not match',11,1)  
  
   END  
  
   --IF NOT EXISTS(select * from SelfService.T_Online_Payment_Master 
   --where TransactionNo=@TransactionNo   
   --     and OnAccReceiptTypeID=@OnAccReceiptTypeID and StudentID=@StudentID and StatusID=1)  
   --begin  
   
   -- insert into SelfService.T_Online_Payment_Master  
   -- (  
   --  BrandID,  
   --  CenterID,  
   --  TransactionNo,  
   --  TransactionDate,  
   --  TransactionStatus,  
   --  TransactionSource,  
   --  TransactionMode,  
   --  Amount,  
   --  Tax,  
   --  TotalAmount,  
   --  OnAccReceiptTypeID,  
   --  StatusID,  
   --  StudentID,  
   --  OnAccDueID  
   -- )  
   -- values  
   -- (  
   --  @BrandID,  
   --  @CenterID,  
   --  @TransactionNo,  
   --  @TransactionDate,  
   --  @TransactionStatus,  
   --  @TransactionSource,  
   --  @TransactionMode,  
   --  @Amount,  
   --  @Tax,  
   --  @Amount+@Tax,  
   --  @OnAccReceiptTypeID,  
   --  1,  
   --  @StudentID,  
   --  @DueID  
   -- )  
  
   --end  
  
   insert into SelfService.T_Transaction_RawData  
   select @TransactionDate,@TransactionNo,@RawData,GETDATE()  
  
  
   SELECT @iStudentDetailID=A.I_Student_Detail_ID   
   FROM T_Student_Detail A  
   inner join T_Student_Center_Detail B on A.I_Student_Detail_ID=B.I_Student_Detail_ID  
   where   
   B.I_Centre_Id=@CenterID and B.I_Status=1 and A.S_Student_ID=@StudentID  
  
   IF(@TransactionStatus='Success' and @PaymentModeID>0 and @iStudentDetailID>0)  
   BEGIN  
  
    DECLARE @OnAccTaxXML XML='<ReceiptTax />'  
  
    DECLARE @cgst DECIMAL(14,2)=0  
    DECLARE @sgst DECIMAL(14,2)=0  
  
    IF (@Tax IS NOT NULL AND @Tax>0)                                      
                BEGIN  
     SET @cgst=ROUND((@Tax/2),2)  
     SET @sgst=@Tax-@cgst  
                
     SET @OnAccTaxXML='<ReceiptTax><TaxDetails TaxID="7" TaxPaid="'+CAST(@cgst AS VARCHAR)+'"/>  
     <TaxDetails TaxID="8" TaxPaid="'+CAST(@sgst AS VARCHAR)+'"/></ReceiptTax>'  
                
    END  
  
  
  
    EXEC ERP_uspGenerateReceiptForOnAccountAPI @iCenterId = @CenterID,  
             @iAmount = @Amount,  
             @iStudentDetailId = @iStudentDetailID,  
             @iReceiptDate = @dtDate,  
             @iPaymentModeId = @PaymentModeID,  
             @sChequeDDno = NULL,  
             @dChequeDate = NULL,  
             @sBankName = NULL,  
             @sBranchName = NULL,  
             @iCreditCardNo = NULL,  
             @sCreditCardIssuer = NULL,  
             @dCardExpiryDate = NULL,  
             @sCrtdBy = 'rice-group-admin',  
             @iReceiptType = @OnAccReceiptTypeID,  
             @dTaxAmount = @Tax,  
             @TaxXML = @OnAccTaxXML,  
             @iBrandID = @BrandID,  
             @iEnquiryID = NULL,  
             @sFormNo = NULL,  
             @sNarration = '',  
             @iReceiptHeader = @iReceiptHeader OUTPUT  
  
  
    IF(@iReceiptHeader>0)  
    begin  
  
     UPDATE SelfService.T_Online_Payment_Master set ReceiptHeaderID=@iReceiptHeader,ReceiptDate=@dtDate, TransactionStatus=@TransactionStatus  
     where   
     TransactionNo=@TransactionNo and OnAccReceiptTypeID=@OnAccReceiptTypeID and StatusID=1 and StudentID=@StudentID  
  
  
     UPDATE SelfService.T_OnAccount_Due set ReceiptHeaderID=@iReceiptHeader,PaidOn=@dtDate where ID=@DueID and StatusID=1  
  
    END  
  
  
   END  
  
     
  
   EXEC [SelfService].[uspGetStudentOnAccDuePaymentDetails] @DueID  
  
  
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

