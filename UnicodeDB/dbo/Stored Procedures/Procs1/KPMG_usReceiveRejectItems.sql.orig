
CREATE PROCEDURE [dbo].[KPMG_usReceiveRejectItems]
@Action	varchar(50),
@GridData	xml,
@OracleTransactionId varchar(50)

AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @nodeCount INT
	DECLARE @loopCount INT
	
	set @loopCount = 1
	select @nodeCount = COUNT(1) FROM @GridData.nodes('/Root/MaterialItem') COM(Col)
	
	DECLARE @slNo varchar(100)
	DECLARE @ItemCode varchar(100)
	DECLARE @barCode varchar(100)
	DECLARE @courseNo varchar(100)
	DECLARE @TBL_STOCK TABLE(UUID INT IDENTITY(1,1),ItemCode NVARCHAR(255),Quantity INT) 
	DECLARE @TBL_STOCK_DTL TABLE(ItemCode NVARCHAR(255),BarCode nvarchar(255)) 
	
	INSERT INTO @TBL_STOCK_DTL(ItemCode,BarCode)
	SELECT     T.c.value('itemCode[1]', 'NVARCHAR(255)'),                  
               T.c.value('barCode[1]', 'NVARCHAR(255)')                       
                        
    FROM    @GridData.nodes('/Root/MaterialItem') T ( c )
	

	
	---- for received material
	IF (ISNULL(@Action,'') = 'Received')
	BEGIN
	
		--ALTER TABLE Tbl_KPMG_PoDetailItems ADD Fld_KPMG_OracleTransactionId VARCHAR(50) DEFAULT ''
		
		UPDATE A SET Fld_KPMG_Status=2 from Tbl_KPMG_PoDetailItems A INNER JOIN @TBL_STOCK_DTL B ON A.Fld_KPMG_Barcode=B.BarCode
		
		INSERT INTO @TBL_STOCK(ItemCode,Quantity)
		SELECT ItemCode ,COUNT(*)  FROM    @TBL_STOCK_DTL   GROUP BY ItemCode
		--select * from @TBL_STOCK 
	              
		SELECT @nodeCount= MAX(UUID) FROM @TBL_STOCK 
		SELECT @loopCount= MIN(UUID) FROM @TBL_STOCK 
		select @nodeCount,@loopCount
		DECLARE @ITEM_CODE NVARCHAR(255)
		WHILE @loopCount <= @nodeCount
		BEGIN
			DECLARE @GENID INT
			
			select @ITEM_CODE=ItemCode from @TBL_STOCK where UUID=@loopCount
			INSERT INTO Tbl_KPMG_StockMaster(Fld_KPMG_ItemCode,Fld_KPMG_Branch_Id,Fld_KPMG_IsMo,Fld_KPMG_FromBranch_Id,Fld_KPMG_LastRecvDate,Fld_KPMG_Mo_Id)
			VALUES(@ITEM_CODE,0,1,0,GETDATE(),0)
			SELECT @GENID=@@IDENTITY
			
			INSERT INTO Tbl_KPMG_StockDetails (Fld_KPMG_Stock_Id,Fld_KPMG_Barcode)
			SELECT @GENID,  BarCode
					FROM   @TBL_STOCK_DTL
					WHERE  ItemCode=@ITEM_CODE
			
			set @loopCount=@loopCount+1
			
			--exec KPMG_uspInsertLoadAllocation @ITEM_CODE
			SET @ITEM_CODE = ''
		END	
	END
	ELSE IF (ISNULL(@Action,'') = 'UPDATE')
		BEGIN
		UPDATE A SET Fld_KPMG_Status=4,Fld_KPMG_OracleTransactionId=@OracleTransactionId from Tbl_KPMG_PoDetailItems A INNER JOIN @TBL_STOCK_DTL B ON A.Fld_KPMG_Barcode=B.BarCode
		END
	ELSE
	BEGIN
		UPDATE A SET Fld_KPMG_Status=3 from Tbl_KPMG_PoDetailItems a INNER JOIN @TBL_STOCK_DTL B ON A.Fld_KPMG_Barcode=A.Fld_KPMG_Barcode
		print ('Rejected material ')
	END
	
	
END
