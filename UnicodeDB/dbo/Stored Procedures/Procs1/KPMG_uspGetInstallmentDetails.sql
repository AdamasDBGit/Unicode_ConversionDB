--sp_helptext 'KPMG_uspGetInstallmentDetails'      
      
        
CREATE PROCEDURE [dbo].[KPMG_uspGetInstallmentDetails]        
(         
 @InvoiceDetailId INT        
)        
AS        
 BEGIN TRY         
DECLARE @TEMP_STUDENTS TABLE (UUID INT IDENTITY(1,1),StudentId Int)        
DECLARE @TEMP_INSTALLMENT_PAID TABLE(UUID INT IDENTITY(1,1),StudentId Int, InstallmentNo INT,InstallmentPaid CHAR(1),BranchId INT)        
DECLARE @TEMP_INSTALLMENT TABLE (UUID INT IDENTITY(1,1),InstallmentNo INT,InstallmentPaid CHAR(1))        
DECLARE @TEMP_MO_INSTALLMENT TABLE(StudentId INT,BranchId INT, InstallmentNo INT, InstallmentPaid CHAR(1))        
DECLARE @MIN_COUNT INT        
DECLARE @MAX_COUNT  INT        
DECLARE @STUDENT_ID INT        
DECLARE @BRANCH_ID INT        
DECLARE @PARENT_INV_ID INT=-1      
DECLARE @OLDCOURSE INT=0      
DECLARE @NEWCOURSE INT=0     
DECLARE @ROW_CHECK INT=0     
  
declare @Stu_ID INT = 0  
declare @lastinvoiceparentid INT = 0  
set @Stu_ID = (select top 1  studentid from Tbl_KPMG_StudentInstallment where InvoiceParentId = @InvoiceDetailId)  
--SELECT * FROM TBL_KPMG_BRANCHCONFIGURATION        
IF EXISTS(SELECT 1 FROM T_Invoice_Parent WHERE I_Invoice_Header_ID=@InvoiceDetailId AND  I_Parent_Invoice_ID IS NOT NULL)        
begin      
 SELECT @PARENT_INV_ID=I_Parent_Invoice_ID FROM T_Invoice_Parent WHERE I_Invoice_Header_ID=@InvoiceDetailId AND  I_Parent_Invoice_ID IS NOT NULL        
 SELECT @NEWCOURSE=TICH.I_Course_ID FROM T_Invoice_Parent tip INNER JOIN T_Invoice_Child_Header TICH ON tip.I_Invoice_Header_ID=TICH.I_Invoice_Header_ID WHERE TIP.I_Invoice_Header_ID=@InvoiceDetailId AND I_Course_ID IS NOT NULL       
 SELECT @OLDCOURSE=TICH.I_Course_ID FROM T_Invoice_Parent tip INNER JOIN T_Invoice_Child_Header TICH ON tip.I_Invoice_Header_ID=TICH.I_Invoice_Header_ID WHERE TIP.I_Invoice_Header_ID=@PARENT_INV_ID AND I_Course_ID IS NOT NULL      
End      
DECLARE @TEMP_BRACH TABLE(UUID INT IDENTITY (1,1),BranchId INT)        
        
DECLARE @MIN_BRACH_CNT INT        
DECLARE @MAX_BRANCH_CNT INT        
SET @MIN_BRACH_CNT=1        
--PRINT @MIN_BRACH_CNT        
--INSERT into @TEMP_BRACH (BranchId)        
--SELECT distinct FLD_KPMG_BRANCHID from TBL_KPMG_BRANCHCONFIGURATION        
----SELECT * FROM @TEMP_BRACH        
--SELECT @MAX_BRANCH_CNT= MAX(UUID) FROM @TEMP_BRACH        
--PRINT @MAX_BRANCH_CNT        
--WHILE(@MAX_BRANCH_CNT>=@MIN_BRACH_CNT)        
BEGIN        
       
-- PRINT @MIN_BRACH_CNT        
 INSERT INTO @TEMP_INSTALLMENT_PAID(StudentId,InstallmentNo,InstallmentPaid,BranchId)        
 SELECT DISTINCT IP.I_Student_Detail_ID,        
  ICD.I_Installment_No,         
  [dbo].[Func_KPMG_InstallmentStatus](ICD.I_Invoice_Detail_ID),        
  IP.I_Centre_Id        
  FROM T_Invoice_Child_Detail ICD        
  INNER JOIN T_Invoice_Child_Header ICH        
  ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID         
  INNER JOIN  T_Invoice_Parent IP ON IP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID         
  INNER JOIN T_Brand_Center_Details BCD ON BCD.I_Centre_Id=IP.I_Centre_Id        
  AND BCD.I_Brand_ID=109        
  AND IP.I_Status=1        
  --AND IP.I_Centre_Id=(SELECT BranchId FROM @TEMP_BRACH WHERE UUID= @MIN_BRACH_CNT)        
  --AND ICD.I_Installment_No>1        
  --AND A.I_Student_Detail_ID>30000        
  AND IP.I_Invoice_Header_ID =@InvoiceDetailId        
  ORDER BY IP.I_Student_Detail_ID DESC        
  --SET @MIN_BRACH_CNT=@MIN_BRACH_CNT+1        
END          
        
--SELECT * FROM @TEMP_INSTALLMENT_PAID        
--RETURN         
--SELECT * FROM @TEMP_INSTALLMENT_PAID        
  INSERT INTO @TEMP_STUDENTS         
  SELECT DISTINCT StudentId FROM @TEMP_INSTALLMENT_PAID         
          
          
  SELECT @MAX_COUNT= COUNT(*) FROM @TEMP_STUDENTS         
  SET @MIN_COUNT=1        
  WHILE (@MIN_COUNT<=@MAX_COUNT)        
   BEGIN        
           
   SELECT @STUDENT_ID= StudentId FROM @TEMP_STUDENTS WHERE UUID=@MIN_COUNT        
   SELECT @BRANCH_ID = BranchId FROM @TEMP_INSTALLMENT_PAID WHERE StudentId=@STUDENT_ID        
   --SELECT @STUDENT_ID        
   INSERT INTO @TEMP_INSTALLMENT        
    SELECT InstallmentNo,InstallmentPaid FROM @TEMP_INSTALLMENT_PAID WHERE StudentId=@STUDENT_ID        
            
    --SELECT * FROM @TEMP_INSTALLMENT        
    DECLARE @MAX_COUNT_INNER INT        
    DECLARE @MIN_COUNT_INNER INT=1        
    DECLARE @FIRST_ISTALLMENT INT          DECLARE @FIRST_ISTALLMENT_PAID CHAR(1)        
    DECLARE @SECOND_ISTALLMENT INT        
    DECLARE @SECOND_ISTALLMENT_PAID CHAR(1)        
    SELECT @MAX_COUNT_INNER=COUNT(*) FROM  @TEMP_INSTALLMENT         
  WHILE (@MIN_COUNT_INNER<=@MAX_COUNT_INNER)        
     BEGIN        
     print @FIRST_ISTALLMENT     
     print @SECOND_ISTALLMENT     
     print @FIRST_ISTALLMENT_PAID    
         SELECT * FROM Tbl_KPMG_StudentInstallment WHERE StudentId=@STUDENT_ID AND InvoiceParentId=@InvoiceDetailId    
      SELECT @FIRST_ISTALLMENT = ISNULL(InstallmentNo,0),@FIRST_ISTALLMENT_PAID=InstallmentPaid FROM @TEMP_INSTALLMENT WHERE UUID=@MIN_COUNT_INNER        
      SELECT @SECOND_ISTALLMENT = ISNULL(InstallmentNo,0),@SECOND_ISTALLMENT_PAID=InstallmentPaid FROM @TEMP_INSTALLMENT WHERE UUID=@MIN_COUNT_INNER+1        
      --SELECT @FIRST_ISTALLMENT,@SECOND_ISTALLMENT        
      IF(@FIRST_ISTALLMENT>0 AND @FIRST_ISTALLMENT_PAID='Y')        
       BEGIN        
       PRINT 22222        
       IF NOT EXISTS(SELECT 1 FROM Tbl_KPMG_StudentInstallment WHERE StudentId=@STUDENT_ID AND InstallmentNo=@FIRST_ISTALLMENT AND InvoiceParentId=@InvoiceDetailId)        
        BEGIN      
   IF @OLDCOURSE = @NEWCOURSE     
   BEGIN    
    
    INSERT INTO Tbl_KPMG_StudentInstallment(StudentId,InstallmentNo,InstallmentPaid,BranchId,InvoiceParentId)        
    SELECT @STUDENT_ID,@FIRST_ISTALLMENT,'Y',@BRANCH_ID,@InvoiceDetailId        
        
    UPDATE Tbl_KPMG_StudentInstallment SET IsMoveOrderCreted = I.IsMoveOrderCreted, MoveOrderId = I.MoveOrderId    
    FROM     
    (SELECT B.IsMoveOrderCreted, B.MoveOrderId FROM Tbl_KPMG_StudentInstallment B     
     WHERE B.StudentId = @STUDENT_ID and B.InvoiceParentId  = @PARENT_INV_ID    
     AND B.BranchId = @BRANCH_ID AND B.InstallmentNo = @FIRST_ISTALLMENT) I    
    WHERE StudentId = @STUDENT_ID AND InvoiceParentId = @InvoiceDetailId AND BranchId = @BRANCH_ID AND InstallmentNo = @FIRST_ISTALLMENT    
   END    
   ELSE    
   BEGIN    
    INSERT INTO Tbl_KPMG_StudentInstallment(StudentId,InstallmentNo,InstallmentPaid,BranchId,InvoiceParentId)        
    SELECT @STUDENT_ID,@FIRST_ISTALLMENT,'Y',@BRANCH_ID,@InvoiceDetailId       
    IF ISNULL(@PARENT_INV_ID,0) != @InvoiceDetailId    
    BEGIN    
     UPDATE  Tbl_KPMG_StudentInstallment SET IsMoveOrderCreted = 'Y' where StudentId = @STUDENT_ID and InvoiceParentId  = @PARENT_INV_ID    
    END    
   END    
       
             
   print('lopp 1');    
        END        
               
       END        
      IF(((@SECOND_ISTALLMENT-@FIRST_ISTALLMENT)>1) AND @FIRST_ISTALLMENT<>0 AND @SECOND_ISTALLMENT<>0  AND @FIRST_ISTALLMENT_PAID ='Y'  )        
       BEGIN        
       DECLARE @INSTALLMENT_COUNT INT         
       SET @INSTALLMENT_COUNT =@FIRST_ISTALLMENT        
        WHILE(@SECOND_ISTALLMENT>@INSTALLMENT_COUNT)        
         BEGIN        
          IF NOT EXISTS(SELECT 1 FROM Tbl_KPMG_StudentInstallment WHERE StudentId=@STUDENT_ID AND InstallmentNo=@INSTALLMENT_COUNT AND InvoiceParentId=@InvoiceDetailId)        
          BEGIN        
          IF @OLDCOURSE = @NEWCOURSE     
   BEGIN    
        
    INSERT INTO Tbl_KPMG_StudentInstallment(StudentId,InstallmentNo,InstallmentPaid,BranchId,InvoiceParentId)        
    SELECT @STUDENT_ID,@INSTALLMENT_COUNT,'Y',@BRANCH_ID,@InvoiceDetailId         
        
    UPDATE Tbl_KPMG_StudentInstallment SET IsMoveOrderCreted = I.IsMoveOrderCreted, MoveOrderId = I.MoveOrderId    
    FROM     
     (SELECT B.IsMoveOrderCreted, B.MoveOrderId FROM Tbl_KPMG_StudentInstallment B     
     WHERE B.StudentId = @STUDENT_ID and B.InvoiceParentId  = @PARENT_INV_ID    
     AND B.BranchId = @BRANCH_ID AND B.InstallmentNo = @INSTALLMENT_COUNT) I    
    WHERE StudentId = @STUDENT_ID AND InvoiceParentId = @InvoiceDetailId AND BranchId = @BRANCH_ID AND InstallmentNo = @INSTALLMENT_COUNT    
   END    
   ELSE    
   BEGIN    
    INSERT INTO Tbl_KPMG_StudentInstallment(StudentId,InstallmentNo,InstallmentPaid,BranchId,InvoiceParentId)        
    SELECT @STUDENT_ID,@INSTALLMENT_COUNT,'Y',@BRANCH_ID,@InvoiceDetailId          
    IF ISNULL(@PARENT_INV_ID,0) != @InvoiceDetailId    
    BEGIN    
     UPDATE  Tbl_KPMG_StudentInstallment SET IsMoveOrderCreted = 'Y' where StudentId = @STUDENT_ID and InvoiceParentId  = @PARENT_INV_ID    
    END    
   END    
       
        
       
       
     print('lopp 2');    
          END        
          SET @INSTALLMENT_COUNT=@INSTALLMENT_COUNT+1        
         END        
       END        
      ELSE IF( @PARENT_INV_ID<>-1 AND @OLDCOURSE=@NEWCOURSE AND @MAX_COUNT_INNER=1 and @FIRST_ISTALLMENT=1)      
      BEGIN      
      DECLARE @Loop INT , @MaxLoop int      
      select @MaxLoop=COUNT(*) FROM Tbl_KPMG_StudentInstallment where InvoiceParentId=@PARENT_INV_ID AND InstallmentNo<>@FIRST_ISTALLMENT        
       SET @Loop =@FIRST_ISTALLMENT+1        
        WHILE(@MaxLoop>=@INSTALLMENT_COUNT)        
         BEGIN        
          IF NOT EXISTS(SELECT 1 FROM Tbl_KPMG_StudentInstallment WHERE StudentId=@STUDENT_ID AND InstallmentNo=@Loop AND InvoiceParentId=@InvoiceDetailId)        
          begin      
      INSERT INTO Tbl_KPMG_StudentInstallment( StudentId,BranchId,InstallmentNo,InstallmentPaid,IsMoveOrderCreted,MoveOrderId,InvoiceParentId)        
      select StudentId,@BRANCH_ID,InstallmentNo,InstallmentPaid,IsMoveOrderCreted,MoveOrderId,@InvoiceDetailId       
      from Tbl_KPMG_StudentInstallment where InvoiceParentId=@PARENT_INV_ID AND InstallmentNo=@Loop AND StudentId=@STUDENT_ID      
      print('last loop')    
  end      
  set @Loop=@Loop+1      
  end      
      END      
            
      set @MIN_COUNT_INNER=@MIN_COUNT_INNER+1         
     END        
            
    SET @MIN_COUNT=@MIN_COUNT+1        
   END     
 IF ISNULL(@PARENT_INV_ID,0) != @InvoiceDetailId    
 BEGIN       
      UPDATE  Tbl_KPMG_StudentInstallment SET IsMoveOrderCreted = 'Y' where StudentId = @STUDENT_ID and InvoiceParentId  = @PARENT_INV_ID    
    END    
 --SELECT * FROM @TEMP_MO_INSTALLMENT       
   
 declare @batchcount int = 1  
 set @batchcount = (select COUNT(distinct I_batch_id) from  t_student_batch_details where I_Student_Id=@Stu_ID)  
 if (@batchcount >1)  
	BEGIN  
		set @lastinvoiceparentid = (select MAX(invoiceparentid) from Tbl_KPMG_StudentInstallment where StudentId=@Stu_ID) 
		--	IF (@lastinvoiceparentid != @InvoiceDetailId) 
			--	BEGIN
					update Tbl_KPMG_StudentInstallment set IsMoveOrderCreted = 'N' where StudentId=@Stu_ID and InvoiceParentId = @lastinvoiceparentid    
					and IsMoveOrderCreted = 'Y' and moveorderid is null --and InstallmentNo != 1  
			--	END
			--	END
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
