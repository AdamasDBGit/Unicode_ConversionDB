CREATE PROCEDURE [dbo].[uspUpdateInvoiceParent]  
(  
 @iStudentDetailId INT,  
 @iCenterId INT,  
 @dInvoiceAmount NUMERIC(18,2),  
 @sCreatedBy Nnvarchar(max),  
 @sInvoiceNo Nnvarchar(max),
 @iBrandID INT  
)  
  
AS  
  
BEGIN TRY  
 SET NOCOUNT ON;  
  
  INSERT INTO T_INVOICE_PARENT (S_Invoice_No,I_Student_Detail_ID,I_Centre_Id,N_Invoice_Amount,Dt_Invoice_Date,I_Status,S_Crtd_By,Dt_Crtd_On)  
  VALUES  
  (@sInvoiceNo,@iStudentDetailId,@iCenterId,@dInvoiceAmount,GETDATE(),1,@sCreatedBy,GETDATE())  
    
  DECLARE @iInvoiceNo BIGINT  
  
  SELECT @iInvoiceNo = MAX(CAST(S_Invoice_No AS BIGINT)) FROM T_Invoice_Parent  TIP
   WHERE I_Invoice_Header_ID NOT IN  
   (SELECT I_Invoice_Header_ID from T_Invoice_Parent  
   WHERE @iInvoiceNo LIKE '%[A-Z]')  
   AND TIP.I_Centre_Id IN (SELECT I_Centre_Id FROM dbo.T_Brand_Center_Details AS TBCD WHERE I_Brand_ID = @iBrandID AND I_Status = 1)        
     
  SET @iInvoiceNo = ISNULL(@iInvoiceNo,0) + 1  
  
  UPDATE T_INVOICE_PARENT   
  SET S_Invoice_No = CAST(@iInvoiceNo AS VARCHAR(20))  
  WHERE I_Invoice_Header_ID = @@identity  
END TRY  
  
  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH

