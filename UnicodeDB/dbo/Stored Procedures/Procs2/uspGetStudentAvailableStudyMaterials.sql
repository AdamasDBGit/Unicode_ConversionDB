--sp_helptext 'uspgetstudentavailablestudymaterials'    
--exec uspgetstudentavailablestudymaterials '1415/RICE/10290'  
        
CREATE PROCEDURE [dbo].[uspGetStudentAvailableStudyMaterials] -- '1415/RICE/12657'      
        
@StudentBarCodeNo nvarchar(255)        
--,@ItemCode nvarchar(255)         
        
AS        
BEGIN TRY         
        
DECLARE @StudentDetailId INT        
DECLARE @TEMP_STUDENT_STUDY_MATERIAL TABLE(STUENT_ID NVARCHAR(255),INSTALLMENT_PAID INT,ISSUEDBARCODE NVARCHAR(255),RECEIPTNO NVARCHAR(255) ,REPLACEDBARCODE NVARCHAR(255))        
DECLARE @Temp_Student_StudyMaterial TABLE(Name NVARCHAR(255), InstallmentNo INT,ItemType INT, InstallmentPaid CHAR(1),MaterialBarcode NVARCHAR(255),Context NVARCHAR(255),ReceiptNo  NVARCHAR(255),InvoiceId INT )        
DECLARE @TEMP_INVOICE TABLE (UUID INT IDENTITY(1,1),InVoiceParentId INT)        
 IF (ISNULL(@StudentBarCodeNo,'')<>'')        
  BEGIN         
  SELECT @StudentDetailId=I_Student_Detail_ID FROM T_Student_Detail  WHERE S_Student_ID=@StudentBarCodeNo        
  INSERT INTO @TEMP_INVOICE(InVoiceParentId)        
  SELECT DISTINCT InvoiceParentId FROM Tbl_KPMG_StudentInstallment where StudentId=@StudentDetailId        
        
--  SELECT * FROM @TEMP_INVOICE        
        
  PRINT 1111        
  DECLARE @MIN_COUNT INT =1        
  DECLARE @MAX_COUNT INT         
  DECLARE @InVoiceParentId INT        
  DECLARE @CourseId int        
  SELECT @MAX_COUNT= COUNT(*) FROM @TEMP_INVOICE        
          
  WHILE (@MAX_COUNT>=@MIN_COUNT)        
           
  BEGIN        
   SELECT @InVoiceParentId= InVoiceParentId FROM @TEMP_INVOICE WHERE UUID=@MIN_COUNT        
   select @CourseId= I_Course_ID from T_Invoice_Child_Header where I_Invoice_Header_ID=@InVoiceParentId        
   PRINT @CourseId        
   INSERT INTO @Temp_Student_StudyMaterial(Name,ItemType,InstallmentNo,InstallmentPaid,InvoiceId)        
   SELECT Fld_KPMG_ItemCode_Description        
    --CASE (A.Fld_KPMG_ItemType)         
    --WHEN 1 THEN 'Study Material '+ CONVERT(NVARCHAR(50),Fld_KPMG_I_Installment_No)        
    --ELSE 'Homework Material ' END        
    ,Fld_KPMG_ItemType, Fld_KPMG_I_Installment_No,'N',@InVoiceParentId FROM Tbl_KPMG_SM_List A         
    where A.Fld_KPMG_CourseId=@CourseId        
   PRINT @InVoiceParentId        
   --SELECT * FROM @Temp_Student_StudyMaterial  A        
   --INNER JOIN Tbl_KPMG_StudentInstallment B ON B.InstallmentNo=A.InstallmentNo        
   --AND B.InvoiceParentId=@InVoiceParentId        

if exists(SELECT 1 FROM T_Invoice_Parent IP INNER JOIN T_Invoice_Child_Header ICH ON IP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
 WHERE IP.I_Invoice_Header_ID=@InVoiceParentId AND ICH.C_Is_LumpSum='Y' AND ip.I_Status<>0)   
 UPDATE A SET InstallmentPaid='Y' from @Temp_Student_StudyMaterial A   WHERE A.InvoiceId=@InVoiceParentId 
 ELSE             
   UPDATE A SET InstallmentPaid='Y' from @Temp_Student_StudyMaterial A        
   INNER JOIN Tbl_KPMG_StudentInstallment B ON B.InstallmentNo=A.InstallmentNo        
   AND A.InvoiceId=B.InvoiceParentId        
   AND A.InvoiceId=@InVoiceParentId        
           
   --SELECT * FROM @Temp_Student_StudyMaterial  A        
   --INNER JOIN Tbl_KPMG_StudentInstallment B ON B.InstallmentNo=A.InstallmentNo        
   --AND B.InvoiceParentId=@InVoiceParentId        
           
   --DELETE FROM @Temp_Student_StudyMaterial        
           
   --SELECT * FROM @Temp_Student_StudyMaterial        
           
   --UPDATE A SET A.InstallmentPaid='Y' FROM @Temp_Student_StudyMaterial A         
   --where A.InstallmentNo in (        
   --select distinct (I_Installment_No) from T_Invoice_Child_Detail B        
   --INNER JOIN T_Invoice_Child_Header C ON B.I_Invoice_Child_Header_ID=C.I_Invoice_Child_Header_ID        
   --AND C.I_Invoice_Header_ID=@InVoiceParentId)        
   --print 2        
   UPDATE A SET MaterialBarcode=B.Fld_KPMG_Barcode ,Context=B.Fld_KPMG_Context FROM @Temp_Student_StudyMaterial A         
   INNER JOIN Tbl_KPMG_SM_Issue B on A.InstallmentNo=B.Fld_KPMG_I_Installment_No         
   INNER JOIN Tbl_KPMG_SM_List C ON B.Fld_KPMG_ItemCode=C.Fld_KPMG_ItemCode        
   AND C.Fld_KPMG_ItemType=A.ItemType        
   AND B.Fld_KPMG_Context='ISSUE'        
   AND B.Fld_KPMG_StudentId=@StudentDetailId           
   AND A.InstallmentPaid='Y'        
   AND C.Fld_KPMG_CourseId=@CourseId        
           
           
       
           
   SET @MIN_COUNT=@MIN_COUNT+1        
  END        
  UPDATE A SET ReceiptNo=c.Fld_KPMG_ReceiptNo FROM @Temp_Student_StudyMaterial A         
   INNER JOIN Tbl_KPMG_DuplicateMaterialIssue C ON C.Fld_Kpmg_ReIssuedBarCode=A.MaterialBarcode        
   AND C.Fld_KPMG_Student_Id=@StudentDetailId        
           
  declare @maxinvoice int      
  select @maxinvoice =  MAX(InvoiceId) from @Temp_Student_StudyMaterial         
  select * from @Temp_Student_StudyMaterial where InvoiceId = @maxinvoice      
          
  PRINT 2        
  END        
           
          
         
        
        
        
END TRY        
BEGIN CATCH        
         
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int        
        
 SELECT @ErrMsg = ERROR_MESSAGE(),        
   @ErrSeverity = ERROR_SEVERITY()        
        
 RAISERROR(@ErrMsg, @ErrSeverity, 1)        
END CATCH
