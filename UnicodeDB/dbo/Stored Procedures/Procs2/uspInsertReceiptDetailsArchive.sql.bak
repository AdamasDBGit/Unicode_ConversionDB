CREATE PROCEDURE [dbo].[uspInsertReceiptDetailsArchive]  
(  
 @sReceiptDetail XML  
)  
  
AS  
BEGIN TRY  
  
  
DECLARE @ReceiptDetailXML XML   
DECLARE @iInvoiceDetailId int  
DECLARE @iReceiptDetailId int  
DECLARE @nAmountPaid numeric(18,2)  
DECLARE @TaxDetailXML XML   
DECLARE @iReceiptComponentDetailId int  
DECLARE @iTaxId int  
DECLARE @nTaxPaid numeric(18,2)  
DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT   
DECLARE @CompanyShare NUMERIC(18,2)  
DECLARE @TaxShare NUMERIC(18,2)  
DECLARE @bUseCenterServiceTax BIT  
  
BEGIN TRANSACTION  
  
SET @bUseCenterServiceTax = 'FALSE'  
  
SET @AdjPosition = 1  
SET @AdjCount = @sReceiptDetail.value('count((TblRctCompDtl/RowRctCompDtl))','int')  
WHILE(@AdjPosition<=@AdjCount)  
BEGIN  
 SET @ReceiptDetailXML = @sReceiptDetail.query('/TblRctCompDtl/RowRctCompDtl[position()=sql:variable("@AdjPosition")]')  
 SELECT @iInvoiceDetailId = T.a.value('@I_Invoice_Detail_ID','int'),  
   @iReceiptDetailId = T.a.value('@I_Receipt_Detail_ID','int'),  
   @nAmountPaid = T.a.value('@N_Amount_Paid','numeric(18,2)')   
 FROM @ReceiptDetailXML.nodes('/RowRctCompDtl') T(a)  
  
 SELECT @CompanyShare = [dbo].fnGetCompanyShare(RH.Dt_Receipt_Date,CM.I_Country_ID,RH.I_Centre_Id,ICH.I_Course_ID,ICD.I_Fee_Component_ID,BCD.I_Brand_ID)   
 FROM dbo.T_Receipt_Header_Archive RH WITH (NOLOCK)  
 INNER JOIN dbo.T_Invoice_Child_Detail ICD WITH (NOLOCK)  
 ON ICD.I_Invoice_Detail_ID = @iInvoiceDetailId  
 INNER JOIN dbo.T_Invoice_Child_Header ICH WITH (NOLOCK)  
 ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID  
 INNER JOIN dbo.T_Brand_Center_Details BCD  
 ON BCD.I_Centre_Id = RH.I_Centre_Id  
 AND BCD.I_Status = 1  
 INNER JOIN dbo.T_Centre_Master CM  
 ON RH.I_Centre_Id = CM.I_Centre_ID  
 where RH.I_Receipt_Header_ID = @iReceiptDetailId  
   
 SELECT @bUseCenterServiceTax = ISNULL(CM.I_Is_Center_Serv_Tax_Reqd,'False')  
 FROM dbo.T_Receipt_Header_Archive RH WITH (NOLOCK)  
 INNER JOIN [dbo].[T_Centre_Master] CM WITH (NOLOCK)  
 ON RH.[I_Centre_Id] = CM.[I_Centre_Id]  
 WHERE RH.I_Receipt_Header_ID = @iReceiptDetailId  
   
 IF (@bUseCenterServiceTax = 'TRUE')  
 BEGIN  
  SET @TaxShare = @CompanyShare  
 END  
 ELSE  
 BEGIN  
  SET @TaxShare = 100  
 END  
  
--set @CompanyShare = 80  
   
 INSERT INTO T_Receipt_Component_Detail_Archive  
 (  
  I_Invoice_Detail_ID,  
  I_Receipt_Detail_ID,  
  N_Amount_Paid,  
  N_Comp_Amount_Rff  
 )  
 values (@iInvoiceDetailId, @iReceiptDetailId, @nAmountPaid, @CompanyShare * @nAmountPaid/100)  
   
   
 SET @iReceiptComponentDetailId=SCOPE_IDENTITY()  
  
 DECLARE @InnerPosition SMALLINT, @InnerCount SMALLINT  
  
 SET @InnerPosition = 1  
 SET @InnerCount = @ReceiptDetailXML.value('count((RowRctCompDtl/TblRctTaxDtl/RowRctTaxDtl))','int')  
 WHILE(@InnerPosition<=@InnerCount)  
 BEGIN  
  SET @TaxDetailXML = @ReceiptDetailXML.query('RowRctCompDtl/TblRctTaxDtl/RowRctTaxDtl[position()=sql:variable("@InnerPosition")]')  
  SELECT @iTaxId = T.b.value('@I_Tax_ID','int'),  
    @iInvoiceDetailId = T.b.value('@I_Invoice_Detail_ID','int'),  
    @nTaxPaid = T.b.value('@N_Tax_Paid','numeric(18,2)')   
  FROM @TaxDetailXML.nodes('/RowRctTaxDtl') T(b)  
   
  INSERT INTO T_Receipt_Tax_Detail_Archive  
  (  
   I_Receipt_Comp_Detail_ID,  
   I_Tax_ID,  
   I_Invoice_Detail_ID,  
   N_Tax_Paid,  
   N_Tax_Rff  
  )  
  Values (@iReceiptComponentDetailId, @iTaxId, @iInvoiceDetailId,@nTaxPaid,@TaxShare * @nTaxPaid/100)  
  
 SET @InnerPosition = @InnerPosition+1  
 END  
 SET @AdjPosition = @AdjPosition + 1  
END  
  
DECLARE @N_Amount_Rff numeric(18,2)  
DECLARE @N_Receipt_Tax_Rff NUMERIC(18,2)  
  
SELECT @N_Amount_Rff = SUM (ISNULL(N_Comp_Amount_Rff,0))   
FROM dbo.T_Receipt_Component_Detail_Archive WITH (NOLOCK)  
WHERE I_Receipt_Detail_ID = @iReceiptDetailId  
  
SELECT @N_Receipt_Tax_Rff = SUM (ISNULL(RTD.N_Tax_Rff,0))  
FROM dbo.T_Receipt_Tax_Detail_Archive RTD WITH (NOLOCK)  
INNER JOIN dbo.T_Receipt_Component_Detail_Archive RCD WITH (NOLOCK)  
ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID  
WHERE RCD.I_Receipt_Detail_ID = @iReceiptDetailId  
  
UPDATE dbo.T_Receipt_Header_Archive  
SET N_Amount_Rff = @N_Amount_Rff,  
 N_Receipt_Tax_Rff = @N_Receipt_Tax_Rff  
WHERE I_Receipt_Header_ID = @iReceiptDetailId  
  
UPDATE dbo.T_Student_Registration_Details  
SET I_Status = 0  
WHERE I_Receipt_Header_ID = @iReceiptDetailId  
  
COMMIT TRANSACTION  
  
END TRY  
BEGIN CATCH  
 --Error occurred:    
 ROLLBACK TRANSACTION  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
