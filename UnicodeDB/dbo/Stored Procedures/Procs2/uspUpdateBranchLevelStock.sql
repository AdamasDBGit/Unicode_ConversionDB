
CREATE PROCEDURE [dbo].[uspUpdateBranchLevelStock]
@MoveOrderNo INT,
@Context NVARCHAR(max),
@MoveOrderXML XML,
@OracleMoveOrderXML XML=''
AS

BEGIN TRY 
DECLARE @MATERIAL_TEMP TABLE(BarCode NVARCHAR(max),CourseName NVARCHAR(max),ItemCode NVARCHAR(max),MoveOrderNo INT, Slno NVARCHAR(max),Defaulter NVARCHAR(max))
DECLARE @COUNT INT
DECLARE @BranchId INTEGER 
DECLARE @ITEM_CODE INTEGER 
DECLARE @nodeCount INT
DECLARE @loopCount INT
DECLARE @GENID INT
DECLARE @GEN_MOV_ID INT
DECLARE @TEMP_ORACLE_MO TABLE(OracleMoLineId INT ,OracleMoNumber INT,SMSMoId INT,SMSMoLineNo INT)
DECLARE @TBL_STOCK_REJECTION TABLE(UUID INT IDENTITY(1,1),ItemCode NVARCHAR(max),Quantity INT)
INSERT INTO @TEMP_ORACLE_MO(OracleMoLineId,OracleMoNumber,SMSMoId,SMSMoLineNo)
SELECT 
                        T.c.value('OracleMoLineId[1]', 'INT') ,
                        T.c.value('OracleMoNumber[1]', 'NVARCHAR(max)') ,
                        T.c.value('SMSMoId[1]', 'INT') ,                        
                        T.c.value('SMSMoLineNo[1]', 'INT')                                                                      
                FROM    @OracleMoveOrderXML.nodes('/ROOT/OracleMoveOrder') T ( c )   
                
                
DECLARE @TBL_STOCK TABLE(UUID INT IDENTITY(1,1),ItemCode NVARCHAR(max),Quantity INT,OracleMoNumber NVARCHAR(max),OracleMoLineId NVARCHAR(max)) 
INSERT INTO @MATERIAL_TEMP(BarCode,CourseName,ItemCode,MoveOrderNo,Slno,Defaulter)
SELECT 
                        T.c.value('BarCode[1]', 'NVARCHAR(max)') ,
                        T.c.value('courseName[1]', 'NVARCHAR(max)') ,
                        T.c.value('itemCode[1]', 'NVARCHAR(max)') ,
                        @MoveOrderNo ,
                        T.c.value('slno[1]', 'NVARCHAR(max)'),
                        T.c.value('defaulter[1]', 'NVARCHAR(max)')                                                                      
                FROM    @MoveOrderXML.nodes('/ROOT/Material') T ( c )   



SELECT @BranchId= Fld_KPMG_Branch_Id from Tbl_KPMG_MoMaster where Fld_KPMG_Mo_Id=@MoveOrderNo
	INSERT INTO @TBL_STOCK(ItemCode,Quantity)
	SELECT ItemCode ,COUNT(*)  FROM    @MATERIAL_TEMP   GROUP BY ItemCode
   
   
UPDATE A SET  A.OracleMoNumber=C.OracleMoNumber,A.OracleMoLineId=C.OracleMoLineId   FROM @TBL_STOCK A INNER JOIN Tbl_KPMG_MoItems B ON A.ItemCode=B.Fld_KPMG_Itemcode AND B.Fld_KPMG_Mo_Id=@MoveOrderNo
INNER JOIN @TEMP_ORACLE_MO C ON B.Fld_KPMG_Mo_Id=C.SMSMoId AND B.Fld_KPMG_MoItem_Id=C.SMSMoLineNo
   
             
IF @Context='RECEIVE'
BEGIN



	SELECT @nodeCount= MAX(UUID) FROM @TBL_STOCK 
    SELECT @loopCount= MIN(UUID) FROM @TBL_STOCK 
    select @nodeCount,@loopCount
	WHILE @loopCount <= @nodeCount
	BEGIN
		
		PRINT 1
		select @ITEM_CODE=ItemCode from @TBL_STOCK where UUID=@loopCount
		INSERT INTO Tbl_KPMG_StockMaster(Fld_KPMG_ItemCode,Fld_KPMG_Branch_Id,Fld_KPMG_IsMo,Fld_KPMG_FromBranch_Id,Fld_KPMG_LastRecvDate,Fld_KPMG_Mo_Id)
		VALUES(@ITEM_CODE,@BranchId,1,@BranchId,GETDATE(),@MoveOrderNo)
		SELECT @GENID=@@IDENTITY
		PRINT @GENID
		UPDATE A SET Fld_KPMG_Stock_Id=@GENID, A.Fld_KPMG_Status=3 FROM Tbl_KPMG_StockDetails A INNER JOIN @MATERIAL_TEMP B ON A.Fld_KPMG_Barcode=B.BarCode
		AND B.ItemCode=@ITEM_CODE 
		
		
		
		
		set @loopCount=@loopCount+1
	END	
	 
	
	INSERT INTO Tbl_KPMG_StudyMaterialStatus( Fld_KPMG_MaterialBarCode,Fld_KPMG_OkStatus)
	SELECT Fld_KPMG_Barcode,1 FROM Tbl_KPMG_StockDetails tbStockDtl INNER JOIN @MATERIAL_TEMP tblTemp
	ON tblTemp.BarCode=tbStockDtl.Fld_KPMG_Barcode
	
END

IF @Context='REJECT'
BEGIN
SELECT @nodeCount= MAX(UUID) FROM @TBL_STOCK 
    SELECT @loopCount= MIN(UUID) FROM @TBL_STOCK 
    select @nodeCount,@loopCount
    DECLARE @defaulter nvarchar(max)
    
	WHILE @loopCount <= @nodeCount
	BEGIN
		
		PRINT 1
		select @ITEM_CODE=ItemCode from @TBL_STOCK where UUID=@loopCount		
		
		INSERT INTO Tbl_KPMG_StockMaster(Fld_KPMG_ItemCode,Fld_KPMG_Branch_Id,Fld_KPMG_IsMo,Fld_KPMG_FromBranch_Id,Fld_KPMG_LastRecvDate,Fld_KPMG_Mo_Id)
		--VALUES(@ITEM_CODE,0,1,0,GETDATE())
		VALUES(@ITEM_CODE,@BranchId,1,@BranchId,GETDATE(),@MoveOrderNo)
		SELECT @GENID=@@IDENTITY
		
		UPDATE A SET Fld_KPMG_Stock_Id=@GENID, 
		A.Fld_KPMG_Status= ( CASE B.Defaulter WHEN 'Rice' THEN 4 ELSE 5 END)
		 FROM Tbl_KPMG_StockDetails A INNER JOIN @MATERIAL_TEMP B ON A.Fld_KPMG_Barcode=B.BarCode
		AND B.ItemCode=@ITEM_CODE 
					
		--IF EXISTS(SELECT 1 FROM @MATERIAL_TEMP WHERE Defaulter='Rice' AND ItemCode=@ITEM_CODE)
		--BEGIN
		--	INSERT INTO Tbl_KPMG_StockMaster(Fld_KPMG_ItemCode,Fld_KPMG_Branch_Id,Fld_KPMG_IsMo,Fld_KPMG_FromBranch_Id,Fld_KPMG_LastRecvDate,Fld_KPMG_Mo_Id)
		--	--VALUES(@ITEM_CODE,0,1,0,GETDATE())
		--	VALUES(@ITEM_CODE,@BranchId,1,@BranchId,GETDATE(),@MoveOrderNo)
		--	SELECT @GENID=@@IDENTITY
			
		--	UPDATE A SET Fld_KPMG_Stock_Id=@GENID, A.Fld_KPMG_Status=4 FROM Tbl_KPMG_StockDetails A INNER JOIN @MATERIAL_TEMP B ON A.Fld_KPMG_Barcode=B.BarCode
		--	AND B.ItemCode=@ITEM_CODE 
		--END
		
		--ELSE IF EXISTS(SELECT 1 FROM @MATERIAL_TEMP WHERE Defaulter='Printer' AND ItemCode=@ITEM_CODE)
		--BEGIN
		--	INSERT INTO Tbl_KPMG_StockMaster(Fld_KPMG_ItemCode,Fld_KPMG_Branch_Id,Fld_KPMG_IsMo,Fld_KPMG_FromBranch_Id,Fld_KPMG_LastRecvDate,Fld_KPMG_Mo_Id)
		--	--VALUES(@ITEM_CODE,0,1,@BranchId,GETDATE())
		--	VALUES(@ITEM_CODE,@BranchId,1,@BranchId,GETDATE(),@MoveOrderNo)
		--	SELECT @GENID=@@IDENTITY
			
		--	UPDATE A SET Fld_KPMG_Stock_Id=@GENID, A.Fld_KPMG_Status=5 FROM Tbl_KPMG_StockDetails A INNER JOIN @MATERIAL_TEMP B ON A.Fld_KPMG_Barcode=B.BarCode
		--	AND B.ItemCode=@ITEM_CODE 
		--END
		
		
		set @loopCount=@loopCount+1
	END	
	
	
END


IF @Context='LOAD'
BEGIN

	DECLARE @FromBranchId INT = 0
	DECLARE @ToBranchId INT	= @BranchId
	DECLARE @LoadContext nvarchar(max)
	
	IF EXISTS(SELECT 1 FROM Tbl_KPMG_MoMaster WHERE Fld_KPMG_Mo_Id = @MoveOrderNo)
	BEGIN
		SELECT @LoadContext = Fld_KPMG_Context FROM Tbl_KPMG_MoMaster WHERE Fld_KPMG_Mo_Id = @MoveOrderNo
	END
	
	IF ISNULL(@LoadContext,'') = 'REV_MO'
	BEGIN		
		SET @FromBranchId = @BranchId
		SET @ToBranchId = 0						
	END
		
	SELECT @nodeCount= MAX(UUID) FROM @TBL_STOCK 
    SELECT @loopCount= MIN(UUID) FROM @TBL_STOCK 
    select @nodeCount,@loopCount
	WHILE @loopCount <= @nodeCount
	BEGIN
		DECLARE @OracleMo NVARCHAR(max)
		DECLARE @OracleMoLineNo NVARCHAR(max)							
		PRINT 1
		select @ITEM_CODE=ItemCode,@OracleMo= ISNULL(OracleMoNumber,''),@OracleMoLineNo=ISNULL(OracleMoLineId,'') 
		from @TBL_STOCK where UUID=@loopCount
		
		INSERT INTO Tbl_KPMG_StockMaster(Fld_KPMG_ItemCode,Fld_KPMG_Branch_Id,Fld_KPMG_IsMo,Fld_KPMG_FromBranch_Id,Fld_KPMG_LastRecvDate,Fld_KPMG_Mo_Id,Fld_KPMG_OracleMoNumber)
		VALUES(@ITEM_CODE,@ToBranchId,1,@FromBranchId,GETDATE(),@MoveOrderNo,@OracleMo)
		--VALUES(@ITEM_CODE,@BranchId,1,0,GETDATE(),@MoveOrderNo,@OracleMo)
		
		
		SELECT @GENID=@@IDENTITY
		
		UPDATE A SET Fld_KPMG_Stock_Id=@GENID, A.Fld_KPMG_Status=2,A.Fld_KPMG_OracleMoLineId=@OracleMoLineNo 
		FROM Tbl_KPMG_StockDetails A INNER JOIN @MATERIAL_TEMP B ON A.Fld_KPMG_Barcode=B.BarCode
		AND B.ItemCode=@ITEM_CODE 
		
		UPDATE Tbl_KPMG_LoadAmount SET Fld_KPMG_Amount= (Fld_KPMG_Amount-(SELECT COUNT(*) FROM @MATERIAL_TEMP WHERE ItemCode=@ITEM_CODE))
		WHERE Fld_KPMG_Mo_Id=@MoveOrderNo AND Fld_KPMG_Itemcode=@ITEM_CODE
		
		IF ISNULL(@LoadContext,'') = 'REV_MO'
		BEGIN
			UPDATE A SET Fld_KPMG_IsLoadedFromBranch = 'Y'
			FROM Tbl_KPMG_ReverseMOItems A INNER JOIN @MATERIAL_TEMP B ON A.Fld_KPMG_BarCode=B.BarCode 
			AND B.ItemCode=@ITEM_CODE 						
		END
		
		set @loopCount=@loopCount+1
	END	
	
	IF ISNULL(@GENID,0) > 0
	BEGIN
		DECLARE @msg nvarchar(max)
		DECLARE @tskmsg nvarchar(max)
		DECLARE @brnch_id INT
		DECLARE @brnch_name	nvarchar(max)
		SET @brnch_id = CASE @FromBranchId WHEN 0 THEN @ToBranchId ELSE @FromBranchId END
		SELECT @brnch_name = S_Center_Name FROM T_Center_Hierarchy_Name_Details WHERE I_Center_ID = @brnch_id
		SET @msg =  'Materials has been loaded from ' +  CASE @FromBranchId WHEN 0 THEN 'Central WareHouse' ELSE 'Branch - ' +@brnch_name  END  +' against Move Order MOV_' + CONVERT(varchar(50),@MoveOrderNo)
		SET @tskmsg =  'Receive Materials at  ' +  CASE @FromBranchId WHEN 0 THEN 'Branch - ' +@brnch_name ELSE 'Central WareHouse'  END -- +' against Move Order MOV_' + CONVERT(varchar(50),@MoveOrderNo)
		IF NOT EXISTS (SELECT 1 FROM tbl_KPMG_Notifications WHERE UniqueKey = 'Tbl_KPMG_StockMaster' + CONVERT(varchar(50),@MoveOrderNo) AND BranchId = @brnch_id)
		BEGIN
			INSERT INTO tbl_KPMG_Notifications (NotificationMessage,TaskMessage,UniqueKey,BranchId)
			values ( @msg,
			@tskmsg,
			'Tbl_KPMG_StockMaster' + CONVERT(varchar(50),@MoveOrderNo),
			@brnch_id)
		END
		
	END
	
	
	
	
END

IF @Context<>'LOAD'
	BEGIN
	
	declare @TotalMoItemCount INT
	declare @CurrentBranchItemCount INT
		
	SELECT @TotalMoItemCount = sum(Fld_KPMG_Quantity) from Tbl_KPMG_MoItems where Fld_KPMG_Mo_Id = @MoveOrderNo  

	SELECT @CurrentBranchItemCount =  COUNT(1) FROM Tbl_KPMG_StockDetails WHERE Fld_KPMG_Stock_Id IN (
	SELECT Fld_KPMG_Stock_Id FROM Tbl_KPMG_StockMaster
	WHERE Fld_KPMG_Mo_Id = @MoveOrderNo and Fld_KPMG_FromBranch_Id = @BranchId AND Fld_KPMG_Branch_Id = @BranchId )
	AND Fld_KPMG_Status IN (3,4,5)
	
	--- check to close current Move Order/ create new move order
	
----IF EXISTS(SELECT 1 FROM (SELECT  Fld_KPMG_Itemcode,Fld_KPMG_Quantity  FROM Tbl_KPMG_MoItems where Fld_KPMG_Mo_Id=@MoveOrderNo)A INNER JOIN (
----SELECT  tbStckNaster.Fld_KPMG_ItemCode ,COUNT(*) as Quantity   FROM  Tbl_KPMG_StockDetails  tbStckDet 
----INNER JOIN Tbl_KPMG_StockMaster tbStckNaster on
----tbStckDet.Fld_KPMG_Stock_Id=tbStckNaster.Fld_KPMG_Stock_Id
----AND tbStckNaster.Fld_KPMG_Mo_Id=@MoveOrderNo AND tbStckDet.Fld_KPMG_Status IN (3,4,5) GROUP BY tbStckNaster.Fld_KPMG_ItemCode) 
----B ON A.Fld_KPMG_Itemcode=B.Fld_KPMG_ItemCode AND A.Fld_KPMG_Quantity=B.Quantity)
	IF ISNULL(@CurrentBranchItemCount,0) = ISNULL(@TotalMoItemCount,0)
		BEGIN
		
			UPDATE Tbl_KPMG_MoMaster SET Fld_KPMG_Status=1 where Fld_KPMG_Mo_Id=@MoveOrderNo
			DECLARE @brnchId INT
			SELECT @brnchId = Fld_KPMG_Branch_Id FROM Tbl_KPMG_MoMaster where Fld_KPMG_Mo_Id=@MoveOrderNo
			DELETE FROM  tbl_KPMG_Notifications WHERE UniqueKey = 'Tbl_KPMG_StockMaster' + CONVERT(varchar(50),@MoveOrderNo) AND BranchId = @brnchId
			
			
			--IF EXISTS(SELECT 1  FROM Tbl_KPMG_StockDetails dtl join Tbl_KPMG_StockMaster mst 
			--		on dtl.Fld_KPMG_Stock_Id = mst.Fld_KPMG_Stock_Id
			--		where mst.Fld_KPMG_Mo_Id = @MoveOrderNo and mst.Fld_KPMG_Branch_Id = @BranchId 
			--		and mst.Fld_KPMG_FromBranch_Id = @BranchId 
			--		and dtl.Fld_KPMG_Status in (4,5))
			----IF @Context='REJECT'
			--BEGIN
			--	DECLARE @GEN_REV_MOV_ID INT
			--	DECLARE @QUANTITY INT
			--	--SELECT @BranchId= Fld_KPMG_Branch_Id from Tbl_KPMG_MoMaster where Fld_KPMG_Mo_Id=@MoveOrderNo
			--	INSERT INTO @TBL_STOCK_REJECTION(ItemCode,Quantity)
			--	SELECT A.Fld_KPMG_ItemCode,COUNT(*) FROM Tbl_KPMG_StockMaster A INNER JOIN Tbl_KPMG_StockDetails B 
			--	ON A.Fld_KPMG_Stock_Id=B.Fld_KPMG_Stock_Id AND A.Fld_KPMG_Mo_Id=@MoveOrderNo
			--	AND B.Fld_KPMG_Status IN (4,5) GROUP BY A.Fld_KPMG_ItemCode 
				
				
				--INSERT INTO Tbl_KPMG_MoMaster(Fld_KPMG_Branch_Id,Fld_KPMG_ISCollected,Fld_KPMG_Context)
				--VALUES (@BranchId,'Y','REV_MO')
				--SET @GEN_MOV_ID=@@IDENTITY

				
				
				--SELECT @nodeCount= MAX(UUID) FROM @TBL_STOCK_REJECTION 
				--SELECT @loopCount= MIN(UUID) FROM @TBL_STOCK_REJECTION 
				--select @nodeCount,@loopCount
			    
			    
				--WHILE @loopCount <= @nodeCount
				--BEGIN
				--	select @ITEM_CODE=ItemCode,@QUANTITY = Quantity from @TBL_STOCK_REJECTION where UUID=@loopCount
				--	INSERT INTO Tbl_KPMG_MoItems(Fld_KPMG_Mo_Id,Fld_KPMG_Itemcode,Fld_KPMG_Quantity)
				--	VALUES(@GEN_MOV_ID,@ITEM_CODE,@QUANTITY)
										
				--	--INSERT INTO Tbl_KPMG_MoItems(Fld_KPMG_Mo_Id,Fld_KPMG_Itemcode,Fld_KPMG_Quantity)
				--	--VALUES(@GEN_REV_MOV_ID,@ITEM_CODE,@QUANTITY)
				--	SET @loopCount=@loopCount+1
					
				--END
				
				--INSERT INTO Tbl_KPMG_ReverseMOItems (Fld_KPMG_ItemCode,Fld_KPMG_BarCode,Fld_KPMG_MoId,Fld_KPMG_ParentMoId,Fld_KPMG_Status)
				--select mstr.Fld_KPMG_ItemCode,dtl.Fld_KPMG_Barcode,@GEN_MOV_ID,@MoveOrderNo,  dtl.Fld_KPMG_Status
				--from Tbl_KPMG_StockDetails dtl join Tbl_KPMG_StockMaster mstr on dtl.Fld_KPMG_Stock_Id = mstr.Fld_KPMG_Stock_Id
				--AND mstr.Fld_KPMG_Mo_Id = @MoveOrderNo and mstr.Fld_KPMG_Branch_Id  = @BranchId and mstr.Fld_KPMG_FromBranch_Id = @BranchId
				--AND dtl.Fld_KPMG_Status in (4,5)
				
				--UPDATE Tbl_KPMG_MoMaster SET Fld_KPMG_ISCollected='N' WHERE Fld_KPMG_Mo_Id=@GEN_MOV_ID
				
				
			--END

		END
END


 
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

