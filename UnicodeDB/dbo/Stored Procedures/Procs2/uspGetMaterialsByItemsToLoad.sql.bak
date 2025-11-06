CREATE PROCEDURE [dbo].[uspGetMaterialsByItemsToLoad]   
(  
 @ItemCode NVARCHAR(MAX),  
 @MoveOrderNo INT,  
 @Context NVARCHAR(50)  
)  
  
AS  
 DECLARE @TEMPTABLE TABLE(SLNo INT IDENTITY(1,1),StockId INT ,BarCode NVARCHAR(255),StockDetailId INT,IsIssued INT,ItemCode NVARCHAR(255),IsRequired CHAR(1) default 'N')  
 DECLARE @ItemAmountTable Table (Id int identity, ItemCode varchar(255))  
 DECLARE @INT_STOCK_ID INT  
 --DECLARE @CHAR_ISCHILD_REVMO INT  
BEGIN TRY   
IF(@Context='LOAD')  
BEGIN  
  
 --SET @CHAR_ISCHILD_REVMO = 'N'  
 INSERT INTO @ItemAmountTable (ItemCode)  
 SELECT Fld_KPMG_Itemcode FROM Tbl_KPMG_LoadAmount  
 WHERE Fld_KPMG_Mo_Id =@MoveOrderNo  AND Fld_KPMG_Amount <> 0  
   
   
   
 IF (ISNULL(@ItemCode,'')<>'')  
  BEGIN   
  --IF(@ItemCode<>'-None-')  
  -- BEGIN  
     
  INSERT INTO @TEMPTABLE(StockId  , StockDetailId ,BarCode,IsIssued,ItemCode )  
    
  SELECT DISTINCT a.Fld_KPMG_Stock_Id AS StockId,a.Fld_KPMG_StockDet_Id AS StockDetailId,a.Fld_KPMG_Barcode AS BarCode,a.Fld_KPMG_isIssued AS IsIssued,  
  b.Fld_KPMG_ItemCode AS ItemCode  
  FROM Tbl_KPMG_StockDetails a INNER JOIN Tbl_KPMG_StockMaster b on  a.Fld_KPMG_Stock_Id =b.Fld_KPMG_Stock_Id  
  JOIN @ItemAmountTable C on b.Fld_KPMG_ItemCode = C.ItemCode  
  AND B.Fld_KPMG_FromBranch_Id=0 and b.Fld_KPMG_Branch_Id=0  
  AND a.Fld_KPMG_Status=1    
  and b.Fld_KPMG_ItemCode = case  @ItemCode WHEN '-None-' THEN b.Fld_KPMG_ItemCode ELSE @ItemCode END  
    
   
   
    
  -- delete   
  DELETE A FROM @TEMPTABLE A   
  INNER JOIN  Tbl_KPMG_ReverseMOItems B on A.ItemCode = B.Fld_KPMG_ItemCode AND A.BarCode = B.Fld_KPMG_BarCode  
  join Tbl_KPMG_MoMaster C on B.Fld_KPMG_MoId = C.Fld_KPMG_Mo_Id  
  WHERE B.Fld_KPMG_Status = 5 AND B.Fld_KPMG_MoId <> @MoveOrderNo AND C.Fld_KPMG_Mo_Id <> @MoveOrderNo  
  AND C.Fld_KPMG_Status = 0  
    
  IF EXISTS(SELECT 1 FROM Tbl_KPMG_ReverseMOItems WHERE Fld_KPMG_MoId = @MoveOrderNo)  
   AND EXISTS (SELECT 1 FROM Tbl_KPMG_MoMaster WHERE Fld_KPMG_Mo_Id = @MoveOrderNo AND Fld_KPMG_Status = 0)  
  BEGIN       
   print 111  
   UPDATE A SET  IsRequired = 'Y'  
   FROM @TEMPTABLE A JOIN  Tbl_KPMG_ReverseMOItems B  
   on A.BarCode = B.Fld_KPMG_BarCode AND A.ItemCode = B.Fld_KPMG_ItemCode  
   WHERE B.Fld_KPMG_MoId = @MoveOrderNo  
      
   DECLARE @nodeCount INT  
   DECLARE @i_code varchar(50)  
   DECLARE @cntr INT  
   DECLARE @totalItemCount INT  
   DECLARE @EXTRA_ITEMCOUNT INT  
   SELECT @nodeCount =  COUNT(1) FROM @ItemAmountTable  
   WHERE ItemCode  = case  @ItemCode WHEN '-None-' THEN ItemCode ELSE @ItemCode END   
   SET @cntr = 1  
   WHILE @cntr <= @nodeCount  
   BEGIN  
      
    SELECT @i_code = ItemCode FROM @ItemAmountTable WHERE  Id = @cntr  
    SELECT @totalItemCount = Fld_KPMG_Amount FROM Tbl_KPMG_LoadAmount WHERE Fld_KPMG_Itemcode = @i_code  
    SELECT @EXTRA_ITEMCOUNT = @totalItemCount -   
     (SELECT COUNT(1) FROM Tbl_KPMG_ReverseMOItems WHERE Fld_KPMG_MoId = @MoveOrderNo  
      AND Fld_KPMG_ItemCode = @i_code AND Fld_KPMG_Status = 5)      
      
    UPDATE TOP(@EXTRA_ITEMCOUNT) @TEMPTABLE SET IsRequired = 'Y'  
    WHERE ItemCode = @i_code AND IsRequired = 'N'  
      
      
    SET @cntr = @cntr + 1  
   END  
   DELETE FROM @TEMPTABLE WHERE IsRequired = 'N'  
  END      
        
     
  --END  
    
  --ELSE  
  --BEGIN  
  --  INSERT INTO @TEMPTABLE(StockId  , StockDetailId ,BarCode,IsIssued ,ItemCode)  
        
  --  SELECT a.Fld_KPMG_Stock_Id AS StockId,a.Fld_KPMG_StockDet_Id AS StockDetailId,a.Fld_KPMG_Barcode AS BarCode,a.Fld_KPMG_isIssued AS IsIssued,  
  --  b.Fld_KPMG_ItemCode As ItemCode  
  --   from Tbl_KPMG_StockDetails a inner join Tbl_KPMG_StockMaster b on  a.Fld_KPMG_Stock_Id =b.Fld_KPMG_Stock_Id   
  --  JOIN @ItemAmountTable C on b.Fld_KPMG_ItemCode = C.ItemCode  
  --  AND B.Fld_KPMG_FromBranch_Id=0 and b.Fld_KPMG_Branch_Id=0  
  --  AND a.Fld_KPMG_Status=1  
        
    
  --END  
    
  
 END  
  
END  
ELSE IF (@Context='RECEIVE_AT_BRANCH')  
BEGIN  
 DECLARE @BranchId INT  
 DECLARE @MoType VARCHAR(50)  
 SELECT @BranchId= Fld_KPMG_Branch_Id,@MoType = Fld_KPMG_Context from Tbl_KPMG_MoMaster where Fld_KPMG_Mo_Id=@MoveOrderNo  
 IF ISNULL(@MoType,'') = 'REV_MO'  
 BEGIN  
  SET @BranchId = 0  
 END  
 IF (ISNULL(@ItemCode,'')<>'')  
  BEGIN   
  IF(@ItemCode<>'-None-')  
   BEGIN  
   INSERT INTO @TEMPTABLE(StockId  , StockDetailId ,BarCode,IsIssued,ItemCode )       
        
   SELECT DISTINCT a.Fld_KPMG_Stock_Id AS StockId,a.Fld_KPMG_StockDet_Id AS StockDetailId,a.Fld_KPMG_Barcode AS BarCode,a.Fld_KPMG_isIssued AS IsIssued,  
   b.Fld_KPMG_ItemCode AS ItemCode  
   FROM Tbl_KPMG_StockDetails a inner join Tbl_KPMG_StockMaster b on  a.Fld_KPMG_Stock_Id =b.Fld_KPMG_Stock_Id  
   AND B.Fld_KPMG_Branch_Id=@BranchId  
   AND B.Fld_KPMG_Mo_Id=@MoveOrderNo  
   and b.Fld_KPMG_ItemCode=@ItemCode  
   AND A.Fld_KPMG_Status=2  
        
        
     
  END  
    
  ELSE  
  BEGIN  
    INSERT INTO @TEMPTABLE(StockId  , StockDetailId ,BarCode,IsIssued ,ItemCode)  
        
      SELECT a.Fld_KPMG_Stock_Id AS StockId,a.Fld_KPMG_StockDet_Id AS StockDetailId,a.Fld_KPMG_Barcode AS BarCode,a.Fld_KPMG_isIssued AS IsIssued,  
      b.Fld_KPMG_ItemCode AS ItemCode  
      FROM Tbl_KPMG_StockDetails a inner join Tbl_KPMG_StockMaster b on  a.Fld_KPMG_Stock_Id =b.Fld_KPMG_Stock_Id  
      AND B.Fld_KPMG_Branch_Id=@BranchId  
      AND B.Fld_KPMG_Mo_Id=@MoveOrderNo  
      AND A.Fld_KPMG_Status=2  
        
    
  END  
    
  
 END  
   
END  
  
  
SELECT SLNo  ,BarCode ,StockDetailId ,IsIssued,ItemCode, C.S_Course_Name AS CourseName FROM @TEMPTABLE A  
  INNER JOIN Tbl_KPMG_SM_List B ON A.ItemCode=B.Fld_KPMG_ItemCode   
  INNER JOIN T_Course_Master C ON B.Fld_KPMG_CourseId=C.I_Course_ID ORDER BY BarCode,SLNo  
  
END TRY  
BEGIN CATCH  
   
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH

