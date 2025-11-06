
CREATE PROCEDURE [dbo].[KPMG_uspUpdateRejectItems]
@Action	varchar(50),
@GridData	xml

AS
BEGIN
	
	SET NOCOUNT ON;
	
	
	--set @loopCount = 1
	--select @nodeCount = COUNT(1) FROM @GridData.nodes('/Root/MaterialItem') COM(Col)
	
	--DECLARE @slNo varchar(100)
	DECLARE @ItemCode varchar(100)
	DECLARE @barCode varchar(100)
	--DECLARE @courseNo varchar(100)
	DECLARE @nodeCount INT
	DECLARE @loopCount INT
	DECLARE @Mo_Id INT
	DECLARE @TBL_STOCK_DTL TABLE(Id INT IDENTITY, ItemCode NVARCHAR(255),BarCode nvarchar(255)) 
	
	DECLARE @STK_ID INT
	DECLARE @BranchId INT
	DECLARE @NEW_MO_ID INT
	---- for received material
	IF (ISNULL(@Action,'') = 'Receive')
	BEGIN
	
		INSERT INTO @TBL_STOCK_DTL(ItemCode,BarCode)
		SELECT  T.c.value('itemCode[1]', 'NVARCHAR(255)'),                  
			   T.c.value('barCode[1]', 'NVARCHAR(255)')
		FROM   @GridData.nodes('/Root/MaterialItem') T ( c )
	
		SET @loopCount = 1
		SELECT @nodeCount =  COUNT(1) FROM @TBL_STOCK_DTL
		WHILE @loopCount <= @nodeCount
		BEGIN
			SELECT @ItemCode = ItemCode,@barCode = BarCode
			FROM @TBL_STOCK_DTL WHERE Id = @loopCount
			
			SELECT @STK_ID = Fld_KPMG_Stock_Id FROM Tbl_KPMG_StockDetails WHERE Fld_KPMG_Barcode = @barCode AND ISNULL(Fld_KPMG_Status,0) =  5
			
			IF EXISTS(SELECT 1 FROM Tbl_KPMG_StockMaster WHERE Fld_KPMG_Stock_Id =  ISNULL(@STK_ID,0) AND Fld_KPMG_Branch_Id = 0 
			 AND Fld_KPMG_FromBranch_Id = 0 AND Fld_KPMG_ItemCode = @ItemCode)
			BEGIN
				UPDATE Tbl_KPMG_StockDetails SET Fld_KPMG_Status = 1 WHERE Fld_KPMG_Stock_Id =  ISNULL(@STK_ID,0)
				AND Fld_KPMG_Barcode = @barCode
				
				SELECT top 1 @Mo_Id = ISNULL(Fld_KPMG_Mo_Id,0) FROM Tbl_KPMG_StockMaster 
				WHERE Fld_KPMG_Stock_Id =  ISNULL(@STK_ID,0) AND Fld_KPMG_Branch_Id = 0 
				AND Fld_KPMG_FromBranch_Id = 0 AND Fld_KPMG_ItemCode = @ItemCode
				
				IF EXISTS (SELECT 1 FROM Tbl_KPMG_ReverseMOItems WHERE Fld_KPMG_BarCode = @barCode AND Fld_KPMG_ItemCode = @ItemCode 
							AND Fld_KPMG_ParentMoId = @Mo_Id AND Fld_KPMG_Status = 5 AND Fld_KPMG_IsReceivedAtCCM = 'N')
				BEGIN	
					SELECT @NEW_MO_ID = Fld_KPMG_MoId FROM Tbl_KPMG_ReverseMOItems 
					WHERE Fld_KPMG_BarCode = @barCode AND Fld_KPMG_ItemCode = @ItemCode 
					AND Fld_KPMG_ParentMoId = @Mo_Id AND Fld_KPMG_Status = 5 AND Fld_KPMG_IsReceivedAtCCM = 'N'
								
					UPDATE Tbl_KPMG_ReverseMOItems  SET Fld_KPMG_IsReceivedAtCCM = 'Y'
					WHERE Fld_KPMG_BarCode = @barCode AND Fld_KPMG_ItemCode = @ItemCode AND Fld_KPMG_ParentMoId = @Mo_Id 
					AND Fld_KPMG_Status = 5
					
					IF EXISTS(SELECT 1 FROM Tbl_KPMG_MoMaster WHERE Fld_KPMG_Mo_Id = @NEW_MO_ID AND Fld_KPMG_Status = 0 
							AND Fld_KPMG_ISCollected = 'Y')
					BEGIN
					
						IF NOT EXISTS(SELECT 1 FROM	Tbl_KPMG_ReverseMOItems WHERE Fld_KPMG_MoId = @NEW_MO_ID AND Fld_KPMG_Status = 5
									AND Fld_KPMG_IsReceivedAtCCM = 'N')
						BEGIN
							-- update move order
							SELECT @BranchId =Fld_KPMG_Branch_Id FROM Tbl_KPMG_MoMaster WHERE Fld_KPMG_Mo_Id = @NEW_MO_ID
							--select * from Tbl_KPMG_MoItems where Fld_KPMG_Mo_Id = 240
							--select * from Tbl_KPMG_LoadAmount
							INSERT INTO Tbl_KPMG_LoadAmount (Fld_KPMG_Branch_Id, Fld_KPMG_Itemcode,Fld_KPMG_Amount,Fld_KPMG_Mo_Id)
							SELECT  @BranchId,Fld_KPMG_Itemcode,Fld_KPMG_Quantity,@NEW_MO_ID
							FROM Tbl_KPMG_MoItems WHERE Fld_KPMG_Mo_Id = @NEW_MO_ID
							
							UPDATE Tbl_KPMG_MoMaster SET Fld_KPMG_ISCollected = 'N' WHERE Fld_KPMG_Mo_Id = @NEW_MO_ID
						END
					END
					
				END
				
			END
			
			
			
			SET @loopCount = @loopCount + 1 
			SET @Mo_Id = 0
			SET @ItemCode =''
			SET @barCode = ''
			print '1'
		END
	  
	END
	
END
