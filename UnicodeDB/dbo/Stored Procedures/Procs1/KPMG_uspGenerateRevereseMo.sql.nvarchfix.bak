
CREATE PROCEDURE [dbo].[KPMG_uspGenerateRevereseMo]
	
AS   
	BEGIN Try	
		DECLARE @TEMP_STOCK TABLE(Id INT Identity,StockId INT, BranchId INT , ItemCode nvarchar(max))
		DECLARE @TEMP_BRANCH_ITEMS TABLE(Id INT Identity, BranchId INT , ItemCode nvarchar(max))
		DECLARE @TEMP_BARCODECHECK TABLE (Id INT IDENTITY, ItemCode nvarchar(max), BarCode nvarchar(max), MoId INT , ParentMoId INT, FldStatus nvarchar(max))
		
		DECLARE @ROW_CNT INT
		DECLARE @COUNTER INT
		
		
		INSERT INTO @TEMP_STOCK (StockId,BranchId,ItemCode)
		SELECT  mst1.Fld_KPMG_Stock_Id ,mst1.Fld_KPMG_Branch_Id,mst1.Fld_KPMG_ItemCode FROM Tbl_KPMG_StockDetails dtl
		JOIN Tbl_KPMG_StockMaster mst1	
			ON mst1.Fld_KPMG_Stock_Id = dtl.Fld_KPMG_Stock_Id
		JOIN Tbl_KPMG_StockMaster mst2
			ON mst1.Fld_KPMG_FromBranch_Id = mst2.Fld_KPMG_FromBranch_Id AND mst1.Fld_KPMG_Branch_Id = mst2.Fld_KPMG_Branch_Id
		WHERE  mst1.Fld_KPMG_FromBranch_Id <> 0 AND mst2.Fld_KPMG_Branch_Id <> 0 AND  dtl.Fld_KPMG_Status IN (4,5)
		group by  mst1.Fld_KPMG_Stock_Id ,mst1.Fld_KPMG_Branch_Id,mst1.Fld_KPMG_ItemCode
		
		INSERT INTO @TEMP_BRANCH_ITEMS (BranchId)
		select BranchId FROM @TEMP_STOCK group by BranchId
		
		--select * from @TEMP_STOCK
		--select * from @TEMP_BRANCH_ITEMS
		
		
			
		DECLARE @RejectedItemCnt INT
		DECLARE @ThrshldCount INT
		DECLARE @Stock_Id INT
		DECLARE @Branch_Id INT
		DECLARE @Item_Code nvarchar(max)
		DECLARE @GEN_MOV_ID INT
		print '1'
		SELECT @ROW_CNT = COUNT(1) FROM @TEMP_BRANCH_ITEMS
		SET @COUNTER = 1
		WHILE @COUNTER <= @ROW_CNT
		BEGIN
			SET @RejectedItemCnt = 0
			SET @ThrshldCount = 5
			SELECT @Branch_Id = BranchId FROM @TEMP_BRANCH_ITEMS WHERE Id = @COUNTER
			
			SELECT @ThrshldCount = fld_kpmg_GenMoCount FROM Tbl_KPMG_BranchConfiguration WHERE fld_kpmg_BranchId = ISNULL(@Branch_Id,0)			
			SELECT @RejectedItemCnt = COUNT (1) FROM Tbl_KPMG_StockDetails WHERE Fld_KPMG_Stock_Id IN 
			(SELECT StockId FROM @TEMP_STOCK WHERE BranchId = @Branch_Id)
			AND Fld_KPMG_Status in (4,5)
			print @RejectedItemCnt
			print @ThrshldCount
			IF ISNULL(@RejectedItemCnt,0) >= ISNULL(@ThrshldCount,5)
			BEGIN
				
				INSERT INTO @TEMP_BARCODECHECK ( ItemCode , BarCode , MoId  , ParentMoId , FldStatus )
				SELECT mst.Fld_KPMG_ItemCode,dtl.Fld_KPMG_Barcode,@GEN_MOV_ID,@GEN_MOV_ID,dtl.Fld_KPMG_Status 
				FROM Tbl_KPMG_StockMaster mst
				JOIN Tbl_KPMG_StockDetails dtl on mst.Fld_KPMG_Stock_Id =  dtl.Fld_KPMG_Stock_Id
				WHERE mst.Fld_KPMG_Stock_Id in (SELECT StockId FROM @TEMP_STOCK WHERE BranchId = @Branch_Id)
				AND dtl.Fld_KPMG_Status IN (4,5)
				--AND dtl.Fld_KPMG_Barcode NOT IN 
				--	(SELECT B.Fld_KPMG_BarCode FROM Tbl_KPMG_MoMaster A JOIN Tbl_KPMG_ReverseMOItems B ON A.Fld_KPMG_Mo_Id = B.Fld_KPMG_MoId 
				--	 WHERE A.Fld_KPMG_Status <> 1 )
				--select * from @TEMP_BARCODECHECK
				IF EXISTS (SELECT 1 FROM @TEMP_BARCODECHECK)
				BEGIN
				----------- generate REVERSE MO -------------------
					INSERT INTO Tbl_KPMG_MoMaster(Fld_KPMG_Branch_Id,Fld_KPMG_ISCollected,Fld_KPMG_Context)
					VALUES (@Branch_Id,'Y','REV_MO')
					SET @GEN_MOV_ID = @@IDENTITY
					print 1111
					INSERT INTO Tbl_KPMG_ReverseMOItems (Fld_KPMG_ItemCode,Fld_KPMG_BarCode,Fld_KPMG_MoId,Fld_KPMG_ParentMoId,Fld_KPMG_Status)
					SELECT ItemCode , BarCode , @GEN_MOV_ID,@GEN_MOV_ID, FldStatus  FROM @TEMP_BARCODECHECK 
					--SELECT mst.Fld_KPMG_ItemCode,dtl.Fld_KPMG_Barcode,@GEN_MOV_ID,@GEN_MOV_ID,dtl.Fld_KPMG_Status 
					--FROM Tbl_KPMG_StockMaster mst
					--JOIN Tbl_KPMG_StockDetails dtl on mst.Fld_KPMG_Stock_Id =  dtl.Fld_KPMG_Stock_Id
					--WHERE mst.Fld_KPMG_Stock_Id in (SELECT StockId FROM @TEMP_STOCK WHERE BranchId = @Branch_Id)
					--AND dtl.Fld_KPMG_Status IN (4,5)
					
					INSERT INTO Tbl_KPMG_MoItems(Fld_KPMG_Mo_Id,Fld_KPMG_Itemcode,Fld_KPMG_Quantity)	
					SELECT @GEN_MOV_ID,Fld_KPMG_ItemCode,COUNT(1) FROM  Tbl_KPMG_ReverseMOItems WHERE Fld_KPMG_MoId = @GEN_MOV_ID
					GROUP BY Fld_KPMG_ItemCode															
					
					UPDATE A SET A.Fld_KPMG_Status = 7 FROM Tbl_KPMG_StockDetails A JOIN @TEMP_BARCODECHECK B 
					ON A.Fld_KPMG_Barcode =  B.BarCode
					
					UPDATE Tbl_KPMG_MoMaster SET Fld_KPMG_ISCollected='N' WHERE Fld_KPMG_Mo_Id=@GEN_MOV_ID
				END
				delete from @TEMP_BARCODECHECK
			END
			
			SET @COUNTER = @COUNTER + 1
		END
		
	END TRY
	BEGIN CATCH            
	--Error occurred:              

		DECLARE @ErrMsg Nnvarchar(max) ,  
		@ErrSeverity INT            
		SELECT  @ErrMsg = ERROR_MESSAGE() ,  
			@ErrSeverity = ERROR_SEVERITY()            
		RAISERROR(@ErrMsg, @ErrSeverity, 1)            
	END CATCH
