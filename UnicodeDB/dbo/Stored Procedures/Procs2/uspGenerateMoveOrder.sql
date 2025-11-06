        
CREATE PROCEDURE [dbo].[uspGenerateMoveOrder]        
AS        
        
         
        
BEGIN TRY         
--TRUNCATE TABLE Tbl_KPMG_MoStudentMap         
DECLARE @TEMP_MO_ITEMS_FOR_INSTALLMENT TABLE(BranchId INT,ItemCode Nnvarchar(max),Quantity INT)        
DECLARE @TEMP_MO_ITEMS_FOR_ADMISSION TABLE(BranchId INT,ItemCode Nnvarchar(max),Quantity INT)        
DECLARE @TEMP_MO_INSTALLMENT TABLE(StudentId INT,BranchId INT, InstallmentNo INT, InstallmentPaid CHAR(1))        
DECLARE @TEMP_MO_ITEMS_TO_CONSIDER TABLE(StudentId INT, InstallmentNo INT, BranchId INT)        
DECLARE @TEMP_CENTERS TABLE ( UUID INT IDENTITY(1,1),BranchId INT)        
DECLARE @TEMP_MO_ITEMS_FOR_SPL_SM TABLE(BranchId INT,ItemCode Nnvarchar(max),Quantity INT)        
DECLARE @MINCOUNT INT        
DECLARE @MAXCOUNT INT        
        
DECLARE @TempTable TABLE (Id INT IDENTITY, ItemCode nvarchar(max))        
      
-----------------------------------------------------Lumpsum Changes------------------------------------------------------------------      
DECLARE @TEMP_MO_ITEMS_FOR_LUMPSUM TABLE(BranchId INT,ItemCode Nnvarchar(max),Quantity INT)          
      
INSERT INTO @TEMP_MO_ITEMS_FOR_LUMPSUM(BranchId,ItemCode,Quantity)         
select  tip.I_Centre_Id,Fld_KPMG_ItemCode,COUNT(distinct tip.I_Invoice_Header_ID)       
from T_Invoice_Parent  tip       
inner join T_Invoice_Child_Header tich on tip.I_Invoice_Header_ID=tich.I_Invoice_Header_ID      
inner join Tbl_KPMG_SM_List SM on SM.Fld_KPMG_CourseId=tich.I_Course_ID       
--inner join Tbl_KPMG_StudentInstallment SI on tip.I_Student_Detail_ID=SI.StudentId and si.InstallmentNo=1 and SI.InstallmentPaid='Y' and SI.InvoiceParentId=tip.I_Invoice_Header_ID      
inner join T_Brand_Center_Details tbcd on tip.I_Centre_Id=tbcd.I_Centre_Id      
where C_Is_LumpSum = 'Y' and tbcd.I_Brand_ID=109 AND tip.I_Status=1 and tich.I_Course_ID is not null      
--and Dt_Invoice_Date >DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) and SM.Fld_KPMG_I_Installment_No>2      
and Dt_Invoice_Date >= DATEADD(MM, -1, getdate()) and SM.Fld_KPMG_I_Installment_No>2      
group by tip.I_Centre_Id,Fld_KPMG_ItemCode      
      
DECLARE @TEMP_MO_ITEMS_OLD_LUMPSUM TABLE(BranchId INT,ItemCode Nnvarchar(max),Quantity INT)       
DECLARE @COUNT INT =2       
declare @startdate datetime      
while (@COUNT<7)      
begin      
select  @startdate=DATEADD(MM, -@COUNT, getdate())      
 if (@startdate<='2015-12-17')
 begin      
INSERT INTO @TEMP_MO_ITEMS_OLD_LUMPSUM(BranchId,ItemCode,Quantity)       
select  tip.I_Centre_Id,Fld_KPMG_ItemCode,COUNT(distinct tip.I_Invoice_Header_ID)     
from T_Invoice_Parent  tip     
inner join T_Invoice_Child_Header tich on tip.I_Invoice_Header_ID=tich.I_Invoice_Header_ID    
inner join Tbl_KPMG_SM_List SM on SM.Fld_KPMG_CourseId=tich.I_Course_ID     
--inner join Tbl_KPMG_StudentInstallment SI on tip.I_Student_Detail_ID=SI.StudentId and si.InstallmentNo=1 and SI.InstallmentPaid='Y' and SI.InvoiceParentId=tip.I_Invoice_Header_ID    
inner join T_Brand_Center_Details tbcd on tip.I_Centre_Id=tbcd.I_Centre_Id    
where C_Is_LumpSum = 'Y' and tbcd.I_Brand_ID=109 AND tip.I_Status=1 and tich.I_Course_ID is not null    
and Dt_Invoice_Date >=DATEADD(MONTH, -1,  @startdate ) --DATEADD(MONTH, DATEDIFF(MONTH, 0, @startdate) , 0)     
and Dt_Invoice_Date<@startdate -- DATEADD(SECOND, -1, DATEADD(MONTH, 1,  DATEADD(MONTH, DATEDIFF(MONTH, 0, @startdate) , 0) ) )     
and SM.Fld_KPMG_I_Installment_No=@COUNT+2    
group by tip.I_Centre_Id,Fld_KPMG_ItemCode       
      
MERGE @TEMP_MO_ITEMS_FOR_LUMPSUM AS target      
    USING (SELECT BranchId,ItemCode,Quantity  from @TEMP_MO_ITEMS_OLD_LUMPSUM) AS source (BranchId,ItemCode,Quantity )      
    ON (target.BranchId = source.BranchId and target.ItemCode = source.ItemCode)      
    WHEN MATCHED THEN       
        UPDATE SET Quantity = target.Quantity + source.Quantity      
WHEN NOT MATCHED THEN      
    INSERT (BranchId,ItemCode,Quantity)      
    VALUES (source.BranchId,source.ItemCode,source.Quantity);      
end          
delete  @TEMP_MO_ITEMS_OLD_LUMPSUM         
    set @COUNT=@COUNT+1      
end      
-----------------------------------------------------Lumpsum Changes------------------------------------------------------------------        
       
  --INSERT INTO  @TEMP_MO_INSTALLMENT (StudentId,BranchId,InstallmentNo,InstallmentPaid)        
  --exec KPMG_uspGetInstallmentDetails        
  --declare @cnt int =0        
  --select @cnt=count(*)from @TEMP_MO_INSTALLMENT         
  --print @cnt        
  --UPDATE A SET A.InstallmentPaid='N' FROM @TEMP_MO_INSTALLMENT A INNER JOIN Tbl_KPMG_MoStudentMap B ON A.StudentId=B.Fld_KPMG_I_Student_Detail_ID        
  --AND A.InstallmentNo=B.Fld_KPMG_I_Installment_No        
          
  --DELETE FROM @TEMP_MO_INSTALLMENT WHERE InstallmentPaid='N'           
          
  --INSERT INTO Tbl_KPMG_MoStudentMap(Fld_KPMG_I_Student_Detail_ID,Fld_KPMG_I_Installment_No)        
  --SELECT StudentId,InstallmentNo FROM @TEMP_MO_INSTALLMENT          
          
          
  --------------------        
  --INSERT INTO @TEMP_MO_ITEMS_FOR_INSTALLMENT(BranchId,ItemCode,Quantity)        
  --SELECT BranchId,B.Fld_KPMG_ItemCode,COUNT(Fld_KPMG_ItemCode) FROM Tbl_KPMG_StudentInstallment A INNER JOIN Tbl_KPMG_SM_List B         
  --ON A.InstallmentNo=B.Fld_KPMG_I_Installment_No + 1        
  --INNER JOIN T_Student_Course_Detail CRS ON CRS.I_Student_Detail_ID = A.StudentId        
  --AND CRS.I_Course_ID=B.Fld_KPMG_CourseId         
  --AND A.InstallmentNo>1          
  --AND A.IsMoveOrderCreted='N'         
  --AND B.Fld_KPMG_IsValid='Y' AND B.Fld_KPMG_IsEnable='Y'         
  --GROUP BY A.BranchId ,B.Fld_KPMG_ItemCode         
          
  --UPDATE A SET A.IsMoveOrderCreted='P'  FROM  Tbl_KPMG_StudentInstallment A         
  --INNER JOIN Tbl_KPMG_SM_List B         
  --ON A.InstallmentNo=B.Fld_KPMG_I_Installment_No        
  --INNER JOIN T_Student_Course_Detail CRS ON CRS.I_Student_Detail_ID = A.StudentId        
  --AND CRS.I_Course_ID=B.Fld_KPMG_CourseId         
  --AND A.InstallmentNo>1        
  --AND A.IsMoveOrderCreted='N'        
  --AND B.Fld_KPMG_IsValid='Y' AND B.Fld_KPMG_IsEnable='Y'         
          
            
  INSERT INTO @TEMP_MO_ITEMS_FOR_INSTALLMENT(BranchId,ItemCode,Quantity)         
  SELECT BranchId,B.Fld_KPMG_ItemCode, COUNT(Fld_KPMG_ItemCode) FROM Tbl_KPMG_StudentInstallment A INNER JOIN Tbl_KPMG_SM_List B         
  ON A.InstallmentNo + 1 = B.Fld_KPMG_I_Installment_No         
  INNER JOIN T_Student_Course_Detail CRS ON CRS.I_Student_Detail_ID = A.StudentId         
  AND CRS.I_Course_ID = B.Fld_KPMG_CourseId         
  AND A.InstallmentNo>1         
  AND A.IsMoveOrderCreted='N'          
  AND B.Fld_KPMG_IsValid='Y' AND B.Fld_KPMG_IsEnable='Y'          
  AND CRS.I_Course_ID IN (11,12)           
  GROUP BY A.BranchId ,B.Fld_KPMG_ItemCode         
          
  UPDATE A SET A.IsMoveOrderCreted='P'  FROM  Tbl_KPMG_StudentInstallment A         
  INNER JOIN Tbl_KPMG_SM_List B         
  ON A.InstallmentNo + 1 = B.Fld_KPMG_I_Installment_No         
  INNER JOIN T_Student_Course_Detail CRS ON CRS.I_Student_Detail_ID = A.StudentId         
  AND CRS.I_Course_ID = B.Fld_KPMG_CourseId         
  AND A.InstallmentNo>1         
  AND A.IsMoveOrderCreted='N'          
  AND B.Fld_KPMG_IsValid='Y' AND B.Fld_KPMG_IsEnable='Y'          
  AND CRS.I_Course_ID IN (11,12)           
         
      
-----------------------------------------------------Lumpsum Changes------------------------------------------------------------------      
MERGE @TEMP_MO_ITEMS_FOR_INSTALLMENT AS target      
    USING (SELECT BranchId,ItemCode,Quantity  from @TEMP_MO_ITEMS_FOR_LUMPSUM) AS source (BranchId,ItemCode,Quantity )      
    ON (target.BranchId = source.BranchId and target.ItemCode = source.ItemCode)      
    WHEN MATCHED THEN       
        UPDATE SET Quantity = target.Quantity + source.Quantity      
WHEN NOT MATCHED THEN      
    INSERT (BranchId,ItemCode,Quantity)      
    VALUES (source.BranchId,source.ItemCode,source.Quantity);      
      
-----------------------------------------------------Lumpsum Changes------------------------------------------------------------------       
  ----------------------        
          
          
  INSERT INTO @TEMP_MO_ITEMS_FOR_ADMISSION (BranchId,ItemCode,Quantity)        
  SELECT A.I_Centre_Id,B.Fld_KPMG_ItemCode,[dbo].[Func_KPMG_MO_QtyByItem](B.Fld_KPMG_ItemCode,A.I_Course_ID,A.I_Centre_Id)        
  FROM T_Course_Center_Detail A INNER JOIN  Tbl_KPMG_SM_List B ON A.I_Course_ID=B.Fld_KPMG_CourseId        
  INNER JOIN T_Center_Hierarchy_Name_Details D  ON A.I_Centre_Id=D.I_Center_ID        
  INNER JOIN Tbl_KPMG_BranchConfiguration BRC ON D.S_Center_Name=BRC.fld_kpmg_BranchName        
  AND ( B.Fld_KPMG_I_Installment_No=1 OR B.Fld_KPMG_I_Installment_No=2)        
  AND B.Fld_KPMG_IsValid='Y' AND Fld_KPMG_IsEnable='Y'        
  AND [dbo].[Func_KPMG_MO_QtyByItem](B.Fld_KPMG_ItemCode,A.I_Course_ID,A.I_Centre_Id)>0        
  -- TEST        
  --WHERE A.I_Centre_Id = 3        
          
          
          
  --INSERT INTO @TEMP_MO_ITEMS_FOR_SPL_SM (BranchId,ItemCode,Quantity)          
  --SELECT C.I_Centre_Id,E.Fld_KPMG_ItemCode,[dbo].[Func_KPMG_MO_QtyWithBuffer](COUNT(Fld_KPMG_ItemCode)) FROM  Tbl_KPMG_StudentExaminationDetails A        
  --  INNER JOIN T_Student_Detail B ON A.Fld_KPMG_StudentDetailId=B.S_Student_ID        
  --  AND A.Fld_KPMG_IsMoveOrderCreated='N'        
  --  INNER JOIN T_Student_Center_Detail C ON C.I_Student_Detail_ID=B.I_Student_Detail_ID        
  --  INNER JOIN T_Center_Hierarchy_Name_Details F  ON C.I_Centre_Id=F.I_Center_ID        
  --  INNER JOIN Tbl_KPMG_BranchConfiguration BRC ON F.S_Center_Name=BRC.fld_kpmg_BranchName        
  --  INNER JOIN Tbl_KPMG_SpecialExamination D ON A.Fld_KPMG_ExaminationId=D.Fld_KPMG_ExaminationId        
  --  INNER JOIN Tbl_KPMG_SM_List E ON D.FLd_Kpmg_SM_Id=E.Fld_KPMG_SM_Id        
  --  AND E.Fld_KPMG_IsValid='Y' AND E.Fld_KPMG_IsEnable='Y'           
  --  GROUP BY C.I_Centre_Id,E.Fld_KPMG_ItemCode         
          
           
          
  INSERT INTO @TEMP_CENTERS        
  SELECT DISTINCT BranchId FROM @TEMP_MO_ITEMS_FOR_INSTALLMENT        
  UNION        
  SELECT DISTINCT BranchId FROM @TEMP_MO_ITEMS_FOR_ADMISSION        
          
          
  SELECT @MINCOUNT=1, @MAXCOUNT=MAX(UUID) FROM @TEMP_CENTERS        
  WHILE(@MINCOUNT<=@MAXCOUNT)        
  BEGIN        
  DECLARE @GENID INT        
  DECLARE @BRACNHID INT        
  SELECT @BRACNHID= BranchId from @TEMP_CENTERS where UUID = @MINCOUNT        
 INSERT INTO Tbl_KPMG_MoMaster(Fld_KPMG_Branch_Id,Fld_KPMG_Context) SELECT @BRACNHID,'BRANCH_TO_CCT'        
 Select @GENID = @@IDENTITY        
         
 UPDATE Tbl_KPMG_StudentInstallment SET MoveOrderId=@GENID,IsMoveOrderCreted='Y' WHERE BranchId=@BRACNHID AND IsMoveOrderCreted='P'         
 INSERT INTO Tbl_KPMG_MoItems(Fld_KPMG_Mo_Id,Fld_KPMG_Itemcode,Fld_KPMG_Quantity)        
 SELECT @GENID,ItemCode,Quantity from @TEMP_MO_ITEMS_FOR_INSTALLMENT         
 WHERE BranchId=@BRACNHID        
         
 INSERT INTO Tbl_KPMG_MoItems(Fld_KPMG_Mo_Id,Fld_KPMG_Itemcode,Fld_KPMG_Quantity)        
 SELECT @GENID,ItemCode,Quantity from @TEMP_MO_ITEMS_FOR_ADMISSION         
 WHERE BranchId=@BRACNHID        
         
 INSERT INTO Tbl_KPMG_MoItems(Fld_KPMG_Mo_Id,Fld_KPMG_Itemcode,Fld_KPMG_Quantity)        
 SELECT @GENID,ItemCode,Quantity from @TEMP_MO_ITEMS_FOR_SPL_SM         
 WHERE BranchId=@BRACNHID        
           
 --INSERT INTO Tbl_KPMG_LoadAmount (Fld_KPMG_Branch_Id,Fld_KPMG_Itemcode,Fld_KPMG_Amount,Fld_KPMG_Mo_Id)        
 --SELECT @BRACNHID,Fld_KPMG_Itemcode,Fld_KPMG_Quantity,Fld_KPMG_Mo_Id        
 --FROM Tbl_KPMG_MoItems WHERE Fld_KPMG_Mo_Id = @GENID        
 INSERT INTO Tbl_KPMG_LoadAmount (Fld_KPMG_Branch_Id,Fld_KPMG_Itemcode,Fld_KPMG_Amount,Fld_KPMG_Mo_Id)        
 SELECT @BRACNHID,Fld_KPMG_Itemcode,Fld_KPMG_Quantity,Fld_KPMG_Mo_Id        
 FROM Tbl_KPMG_MoItems WHERE Fld_KPMG_Mo_Id = @GENID        
         
 SET @MINCOUNT=@MINCOUNT+1        
         
  END        
  --UPDATE Tbl_KPMG_StudentExaminationDetails SET Fld_KPMG_IsMoveOrderCreated='Y' WHERE Fld_KPMG_IsMoveOrderCreated='N'        
  --exec KPMG_uspMO_LoadAllocation         
          
 --INSERT INTO @TempTable(ItemCode)        
 --SELECT DISTINCT(ld.Fld_KPMG_Itemcode) FROM Tbl_KPMG_LoadAmount ld         
 --JOIN Tbl_KPMG_MoMaster mo ON mo.Fld_KPMG_Mo_Id = ld.Fld_KPMG_Mo_Id         
 --WHERE mo.Fld_KPMG_Status = '0' AND ISNULL(mo.Fld_KPMG_GrnNumber,0) > 0        
 --AND ISNULL(ld.FLd_KPMG_AmountLeft,0) > 0        
      
 --DECLARE @_counter INT         
 --DECLARE @_rowCount INT        
 --DECLARE @_ItemCode VARCHAR(100)        
 --SET @_counter = 1        
 --SELECT @_rowCount  = COUNT(1) FROM @TempTable        
 --WHILE(@_counter <= @_rowCount)        
 --BEGIN        
 -- SELECT @_ItemCode = ItemCode FROM @TempTable WHERE Id = @_counter        
 -- exec KPMG_uspAllocateItemsAgainstMoveOrder @_ItemCode        
 -- SET @_counter = @_counter  + 1        
 --END        
          
          
         
         
END TRY        
BEGIN CATCH        
         
 DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int        
        
 SELECT @ErrMsg = ERROR_MESSAGE(),        
   @ErrSeverity = ERROR_SEVERITY()        
        
 RAISERROR(@ErrMsg, @ErrSeverity, 1)        
END CATCH
