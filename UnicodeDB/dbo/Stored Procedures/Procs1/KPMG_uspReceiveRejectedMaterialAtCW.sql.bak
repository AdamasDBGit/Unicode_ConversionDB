
CREATE PROCEDURE [dbo].[KPMG_uspReceiveRejectedMaterialAtCW]
(		
@MoveOrderNo INT,
@Context NVARCHAR(100),
@MoveOrderXML XML,
@OracleMoveOrderXML XML=''

)
AS
BEGIN Try

	DECLARE @MATERIAL_TEMP TABLE(BarCode NVARCHAR(255),CourseName NVARCHAR(255),ItemCode NVARCHAR(255),MoveOrderNo INT, Slno NVARCHAR(255),Defaulter NVARCHAR(255))
	DECLARE @TBL_STOCK TABLE(UUID INT IDENTITY(1,1),ItemCode NVARCHAR(255),Quantity INT,OracleMoNumber NVARCHAR (255),OracleMoLineId NVARCHAR (255)) 
	DECLARE @TEMP_ORACLE_MO TABLE(OracleMoLineId INT ,OracleMoNumber INT,SMSMoId INT,SMSMoLineNo INT)
	DECLARE @COUNT INT
	DECLARE @BranchId INTEGER 	
	DECLARE @ITEM_CODE INTEGER 
	DECLARE @nodeCount INT
	DECLARE @loopCount INT
	DECLARE @GENID INT
	DECLARE @GEN_MOV_ID INT
	DECLARE @MoType VARCHAR(50)
	

	INSERT INTO @TEMP_ORACLE_MO(OracleMoLineId,OracleMoNumber,SMSMoId,SMSMoLineNo)
	SELECT 
		T.c.value('OracleMoLineId[1]', 'INT') ,
		T.c.value('OracleMoNumber[1]', 'NVARCHAR(255)') ,
		T.c.value('SMSMoId[1]', 'INT') ,                        
		T.c.value('SMSMoLineNo[1]', 'INT')                                                                      
	FROM    @OracleMoveOrderXML.nodes('/ROOT/OracleMoveOrder') T ( c )   
	                
	                
	INSERT INTO @MATERIAL_TEMP(BarCode,CourseName,ItemCode,MoveOrderNo,Slno,Defaulter)
	SELECT 
		T.c.value('BarCode[1]', 'NVARCHAR(255)') ,
		T.c.value('courseName[1]', 'NVARCHAR(255)') ,
		T.c.value('itemCode[1]', 'NVARCHAR(255)') ,
		@MoveOrderNo ,
		T.c.value('slno[1]', 'NVARCHAR(255)'),
		T.c.value('defaulter[1]', 'NVARCHAR(255)')                                                                      
	FROM    @MoveOrderXML.nodes('/ROOT/Material') T ( c )   



	SELECT @BranchId= Fld_KPMG_Branch_Id,@MoType = Fld_KPMG_Status from Tbl_KPMG_MoMaster
	where Fld_KPMG_Mo_Id=@MoveOrderNo AND Fld_KPMG_Status = 0
	IF ISNULL(@MoType,'') <> 'REV_MO'
	BEGIN
		DECLARE @ErrMsg1 NVARCHAR(4000) ,  
        @ErrSeverity1 INT            
		SELECT  @ErrMsg1 = ERROR_MESSAGE() ,  
				@ErrSeverity1 = ERROR_SEVERITY()            
		RAISERROR(@ErrMsg1, @ErrSeverity1, 1)  
	END
	
	
	INSERT INTO @TBL_STOCK(ItemCode,Quantity)
	SELECT ItemCode ,COUNT(*)  FROM    @MATERIAL_TEMP   GROUP BY ItemCode


	UPDATE A SET  A.OracleMoNumber=C.OracleMoNumber,A.OracleMoLineId=C.OracleMoLineId   
	FROM @TBL_STOCK A INNER JOIN Tbl_KPMG_MoItems B ON A.ItemCode=B.Fld_KPMG_Itemcode AND B.Fld_KPMG_Mo_Id=@MoveOrderNo
	INNER JOIN @TEMP_ORACLE_MO C ON B.Fld_KPMG_Mo_Id=C.SMSMoId AND B.Fld_KPMG_MoItem_Id=C.SMSMoLineNo
	
	             
	IF @Context='RECEIVE'
	BEGIN

		SELECT @nodeCount= MAX(UUID) FROM @TBL_STOCK 
		SELECT @loopCount= MIN(UUID) FROM @TBL_STOCK 
		select @nodeCount,@loopCount
		WHILE @loopCount <= @nodeCount
		BEGIN
						
			select @ITEM_CODE=ItemCode from @TBL_STOCK where UUID=@loopCount
			
			INSERT INTO Tbl_KPMG_StockMaster(Fld_KPMG_ItemCode,Fld_KPMG_Branch_Id,Fld_KPMG_IsMo,Fld_KPMG_FromBranch_Id,Fld_KPMG_LastRecvDate,Fld_KPMG_Mo_Id)
			VALUES(@ITEM_CODE,0,1,0,GETDATE(),@MoveOrderNo)
			SELECT @GENID=@@IDENTITY
			
			UPDATE A SET Fld_KPMG_Stock_Id=@GENID--, A.Fld_KPMG_Status=3 
			FROM Tbl_KPMG_StockDetails A
			INNER JOIN @MATERIAL_TEMP B ON A.Fld_KPMG_Barcode=B.BarCode
			AND B.ItemCode=@ITEM_CODE 
			--select * from Tbl_KPMG_ReverseMOItems
			
			UPDATE A SET A.Fld_KPMG_Status=B.Fld_KPMG_Status
			FROM Tbl_KPMG_StockDetails A
			INNER JOIN Tbl_KPMG_ReverseMOItems B ON A.Fld_KPMG_Barcode=B.Fld_KPMG_BarCode
			AND B.Fld_KPMG_ItemCode=@ITEM_CODE AND B.Fld_KPMG_MoId = @MoveOrderNo
			INNER JOIN @MATERIAL_TEMP C ON B.Fld_KPMG_BarCode=C.BarCode
										
			set @loopCount=@loopCount+1
		END			 				
		
	END
	
	
	--- check to generate move order for the rejected items for branch
	--DECLARE @totalPrinterDfltCnt INT
	--DECLARE @RcvPrinterDfltCnt INT
	
	--SELECT @totalPrinterDfltCnt =COUNT(1)  FROM Tbl_KPMG_ReverseMOItems WHERE  Fld_KPMG_MoId = @MoveOrderNo AND Fld_KPMG_Status IN (4,5)
	--SELECT @RcvPrinterDfltCnt = COUNT(1) FROM Tbl_KPMG_StockDetails WHERE Fld_KPMG_Stock_Id IN
	-- ( SELECT Fld_KPMG_Stock_Id FROM Tbl_KPMG_StockMaster
	--	WHERE Fld_KPMG_Mo_Id = @MoveOrderNo and Fld_KPMG_FromBranch_Id = 0 AND Fld_KPMG_Branch_Id = 0 )
	-- AND Fld_KPMG_Status IN (4,5)
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	DECLARE @TotalMoItemCount INT
	DECLARE @CurrentBranchItemCount INT
		
	SELECT @TotalMoItemCount = sum(Fld_KPMG_Quantity) from Tbl_KPMG_MoItems where Fld_KPMG_Mo_Id = @MoveOrderNo  

	SELECT @CurrentBranchItemCount =  COUNT(1) FROM Tbl_KPMG_StockDetails WHERE Fld_KPMG_Stock_Id IN (
	SELECT Fld_KPMG_Stock_Id FROM Tbl_KPMG_StockMaster
	WHERE Fld_KPMG_Mo_Id = @MoveOrderNo and Fld_KPMG_FromBranch_Id = 0 AND Fld_KPMG_Branch_Id = 0 )	
	AND Fld_KPMG_Status IN (4,5)
	
				
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
	--IF ISNULL(@totalPrinterDfltCnt,0) = ISNULL(@RcvPrinterDfltCnt,1)
	--   --AND NOT EXISTS (SELECT 1 FROM Tbl_KPMG_ReverseMOItems where Fld_KPMG_ParentMoId = @MoveOrderNo )
	--BEGIN
	IF ISNULL(@CurrentBranchItemCount,0) = ISNULL(@TotalMoItemCount,1)		
	BEGIN	
		-- close reverse move order
		
		----- notification --		
		DELETE FROM  tbl_KPMG_Notifications WHERE UniqueKey = 'Tbl_KPMG_StockMaster' + CONVERT(varchar(50),@MoveOrderNo) AND BranchId = @BranchId
		----- notification --
		
		INSERT INTO Tbl_KPMG_MoMaster(Fld_KPMG_Branch_Id,Fld_KPMG_ISCollected,Fld_KPMG_Context)
		VALUES (@BranchId,'Y','BRANCH_TO_CCT')
		SET @GEN_MOV_ID=@@IDENTITY
		
		INSERT INTO Tbl_KPMG_MoItems(Fld_KPMG_Mo_Id,Fld_KPMG_Itemcode,Fld_KPMG_Quantity)
		SELECT @GEN_MOV_ID,Fld_KPMG_ItemCode,COUNT(1) FROM Tbl_KPMG_ReverseMOItems WHERE Fld_KPMG_MoId =@MoveOrderNo
		GROUP BY Fld_KPMG_ItemCode
		
		UPDATE Tbl_KPMG_ReverseMOItems SET Fld_KPMG_ParentMoId = @MoveOrderNo
		WHERE Fld_KPMG_MoId = @MoveOrderNo
		
		UPDATE Tbl_KPMG_ReverseMOItems SET Fld_KPMG_MoId = @GEN_MOV_ID
		WHERE Fld_KPMG_ParentMoId = @MoveOrderNo				
		
		
		UPDATE Tbl_KPMG_MoMaster SET Fld_KPMG_Status=1 where Fld_KPMG_Mo_Id=@MoveOrderNo
		
		------------- activate mo if no item is printer defaulter -----------
		IF NOT EXISTS(SELECT 1 FROM Tbl_KPMG_ReverseMOItems WHERE Fld_KPMG_MoId = @GEN_MOV_ID AND Fld_KPMG_Status = 5)
		BEGIN
			INSERT INTO Tbl_KPMG_LoadAmount (Fld_KPMG_Branch_Id, Fld_KPMG_Itemcode,Fld_KPMG_Amount,Fld_KPMG_Mo_Id)
			SELECT  @BranchId,Fld_KPMG_Itemcode,Fld_KPMG_Quantity,@GEN_MOV_ID
			FROM Tbl_KPMG_MoItems WHERE Fld_KPMG_Mo_Id = @GEN_MOV_ID
			
			UPDATE Tbl_KPMG_MoMaster SET Fld_KPMG_ISCollected = 'N' WHERE Fld_KPMG_Mo_Id = @GEN_MOV_ID
		END
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
