

    
CREATE PROCEDURE [dbo].[KPMG_uspStudyMaterialIssue] 
    
@StudentBarCodeNo nvarchar(255),    
@MaterialBarCode nvarchar(255),    
@ReplacedBarCode nvarchar(255),    
@ReissueReceiptNo nvarchar(255),    
@StudyMaterialName nvarchar(255),    
@Context nvarchar(255)    
    
AS    
BEGIN TRY     
DECLARE @ERROR NVARCHAR(MAX)    
DECLARE @STUDENTID INT    
DECLARE @INSTALLMENTNO INT    
DECLARE @STUDYMATERIALID INT    
DECLARE @STATUS NVARCHAR(MAX)    
DECLARE @itemCode NVARCHAR(255)    
DECLARE @ISSUED_STUDY_MATERIAL NVARCHAR(255)    
     
 IF (ISNULL(@StudentBarCodeNo,'')<>'')    
  BEGIN     
  DECLARE @CENTER_ID INT    
      
  SELECT @STUDENTID= I_Student_Detail_ID from T_Student_Detail where S_Student_ID=@StudentBarCodeNo    
  SELECT @CENTER_ID= I_Centre_Id FROM T_Invoice_Parent WHERE I_Student_Detail_ID=@STUDENTID    
      
  IF @Context='ISSUE'    
    BEGIN    
        
    SET @ISSUED_STUDY_MATERIAL=@MaterialBarCode    
        
    STUDY_MATERIAL_ISSUE:    
        
    SELECT @itemCode= Fld_KPMG_ItemCode from Tbl_KPMG_StockMaster A INNER JOIN Tbl_KPMG_StockDetails B ON A.Fld_KPMG_Stock_Id=B.Fld_KPMG_Stock_Id AND B.Fld_KPMG_Barcode=@ISSUED_STUDY_MATERIAL    
        
     SELECT @INSTALLMENTNO=Fld_KPMG_I_Installment_No FROM  Tbl_KPMG_SM_List where Fld_KPMG_ItemCode=@itemCode    
         
       INSERT INTO Tbl_KPMG_SM_Issue    
            
       ( Fld_KPMG_Barcode, Fld_KPMG_Context,Fld_KPMG_I_Installment_No,Fld_KPMG_IssueDate,Fld_KPMG_ItemCode,Fld_KPMG_StudentId)    
        VALUES    
        (    
         @ISSUED_STUDY_MATERIAL,'ISSUE',@INSTALLMENTNO,GETDATE(),@itemCode ,@STUDENTID    
        )    
           
       UPDATE Tbl_KPMG_StockDetails set Fld_KPMG_isIssued='1' WHERE Fld_KPMG_Barcode=@ISSUED_STUDY_MATERIAL    
           
       SET @STATUS='SUCCESS'    
           
        
    END    
    ELSE IF @Context='REPLACE'    
    BEGIN    
      UPDATE Tbl_KPMG_SM_Issue SET Fld_KPMG_Context='REPLACE' WHERE Fld_KPMG_Barcode=@MaterialBarCode AND Fld_KPMG_StudentId=@STUDENTID             
      UPDATE Tbl_KPMG_StockDetails SET Fld_KPMG_Status=5 ,Fld_KPMG_isIssued=0 WHERE Fld_KPMG_Barcode=@MaterialBarCode     
      SET @ISSUED_STUDY_MATERIAL=@ReplacedBarCode    
      GOTO STUDY_MATERIAL_ISSUE    
    END    
        
    ---------------------------    
    ELSE IF @Context='REISSUE'    
    BEGIN    
    print @StudyMaterialName  
     SELECT @itemCode= Fld_KPMG_ItemCode from Tbl_KPMG_SM_List WHERE ltrim(rtrim(Fld_KPMG_ItemCode_Description))=LTRIM(RTRIM(@StudyMaterialName))     
     INSERT INTO Tbl_KPMG_DuplicateMaterialIssue(Fld_KPMG_ReceiptNo,Fld_KPMG_Receipt_Date,Fld_KPMG_StudentBarCode,Fld_KPMG_Student_Id,Fld_Kpmg_ReIssuedBarCode,Fld_KPMG_Price,Fld_KPMG_Tax,Fld_KPMG_Total)    
     SELECT @ReissueReceiptNo,GETDATE(),@StudentBarCodeNo,@STUDENTID,@MaterialBarCode, Fld_KPMG_Price,Fld_KPMG_Tax,(Fld_KPMG_Price+Fld_KPMG_Tax) FROM Tbl_KPMG_SM_List     
     WHERE Fld_KPMG_ItemCode=@itemCode    
     SELECT @ISSUED_STUDY_MATERIAL= Fld_KPMG_Barcode FROM Tbl_KPMG_SM_Issue WHERE Fld_KPMG_ItemCode=@itemCode AND Fld_KPMG_Context='ISSUE' AND Fld_KPMG_StudentId=@STUDENTID    
    print  @Context  
     PRINT 2222    
     PRINT @itemCode    
     PRINT @ISSUED_STUDY_MATERIAL    
     UPDATE Tbl_KPMG_SM_Issue SET Fld_KPMG_Context='REISSUE' WHERE Fld_KPMG_Barcode=@ISSUED_STUDY_MATERIAL AND Fld_KPMG_StudentId=@STUDENTID    
         
     SET @ISSUED_STUDY_MATERIAL=@MaterialBarCode    
     GOTO STUDY_MATERIAL_ISSUE    
         
        
        
    END    
        
        
        
       
      
  IF @ERROR<>''    
  BEGIN    
   SET @STATUS=@ERROR    
  END    
      
  SELECT @STATUS AS Status    
       
  END    
       
      
     
    
END TRY    
BEGIN CATCH    
     
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
