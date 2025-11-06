
CREATE PROCEDURE [dbo].[uspGetMaterialsByItems] 
(
	@ItemCode VARCHAR(50),
	@MoveOrderNo INT
)

AS
	DECLARE @TEMPTABLE TABLE(SLNo INT IDENTITY(1,1),StockId INT ,BarCode NVARCHAR(255),StockDetailId INT,IsIssued INT,ItemCode NVARCHAR(255))
	DECLARE @INT_STOCK_ID INT
BEGIN TRY 
	IF (ISNULL(@ItemCode,'')<>'')
		BEGIN 
		IF(@ItemCode<>'-None-')
			BEGIN
			
			
			--SELECT @INT_STOCK_ID = Fld_KPMG_Stock_Id FROM Tbl_KPMG_StockMaster WHERE   Fld_KPMG_ItemCode= @ItemCode AND Fld_KPMG_Mo_Id=@MoveOrderNo
			--	IF (ISNULL(@INT_STOCK_ID,0)<>0)							 
			--		BEGIN
			--			INSERT INTO @TEMPTABLE(StockId  , StockDetailId ,BarCode,IsIssued )
			--			SELECT  Fld_KPMG_Stock_Id AS StockId,Fld_KPMG_StockDet_Id AS StockDetailId,Fld_KPMG_Barcode AS BarCode,Fld_KPMG_isIssued AS IsIssued FROM Tbl_KPMG_StockDetails WHERE  Fld_KPMG_Stock_Id=@INT_STOCK_ID and Fld_KPMG_isIssued=0
			--		END	
			
			INSERT INTO @TEMPTABLE(StockId  , StockDetailId ,BarCode,IsIssued,ItemCode )
						--SELECT  Fld_KPMG_Stock_Id AS StockId,Fld_KPMG_StockDet_Id AS StockDetailId,Fld_KPMG_Barcode AS BarCode,Fld_KPMG_isIssued AS IsIssued FROM Tbl_KPMG_StockDetails 
						--WHERE  Fld_KPMG_Stock_Id IN(SELECT Fld_KPMG_Stock_Id FROM Tbl_KPMG_StockMaster WHERE Fld_KPMG_ItemCode=@ItemCode and   Fld_KPMG_Mo_Id=@MoveOrderNo) and Fld_KPMG_isIssued=0
						
						select a.Fld_KPMG_Stock_Id AS StockId,a.Fld_KPMG_StockDet_Id AS StockDetailId,a.Fld_KPMG_Barcode AS BarCode,a.Fld_KPMG_isIssued AS IsIssued,
						b.Fld_KPMG_ItemCode As ItemCode
						 from Tbl_KPMG_StockDetails a inner join Tbl_KPMG_StockMaster b on  a.Fld_KPMG_Stock_Id =b.Fld_KPMG_Stock_Id and
						b.Fld_KPMG_Mo_Id=@MoveOrderNo
						and b.Fld_KPMG_ItemCode=@ItemCode
			
		END
		
		ELSE
		BEGIN
				INSERT INTO @TEMPTABLE(StockId  , StockDetailId ,BarCode,IsIssued ,ItemCode)
						--SELECT  Fld_KPMG_Stock_Id AS StockId,Fld_KPMG_StockDet_Id AS StockDetailId,Fld_KPMG_Barcode AS BarCode,Fld_KPMG_isIssued AS IsIssued FROM Tbl_KPMG_StockDetails 
						--WHERE  Fld_KPMG_Stock_Id IN(SELECT Fld_KPMG_Stock_Id FROM Tbl_KPMG_StockMaster WHERE   Fld_KPMG_Mo_Id=@MoveOrderNo) and Fld_KPMG_isIssued=0
						select a.Fld_KPMG_Stock_Id AS StockId,a.Fld_KPMG_StockDet_Id AS StockDetailId,a.Fld_KPMG_Barcode AS BarCode,a.Fld_KPMG_isIssued AS IsIssued,
						b.Fld_KPMG_ItemCode As ItemCode
						 from Tbl_KPMG_StockDetails a inner join Tbl_KPMG_StockMaster b on  a.Fld_KPMG_Stock_Id =b.Fld_KPMG_Stock_Id and
						b.Fld_KPMG_Mo_Id=@MoveOrderNo
						
		
		END
		SELECT SLNo  ,BarCode ,StockDetailId ,IsIssued,ItemCode FROM @TEMPTABLE

	END



END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
