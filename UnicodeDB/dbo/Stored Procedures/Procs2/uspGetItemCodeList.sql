
CREATE PROCEDURE [dbo].[uspGetItemCodeList] 
(
	@MoveOrderNo INT
)

AS
	
BEGIN TRY 
	IF (ISNULL(@MoveOrderNo,'')<>'')
		BEGIN 
			IF EXISTS(SELECT 1 FROM Tbl_KPMG_MoItems WHERE Fld_KPMG_Mo_Id= @MoveOrderNo)
				BEGIN
					SELECT DISTINCT Fld_KPMG_MoItem_Id AS ItemId, A.Fld_KPMG_Mo_Id AS MoveOrderId, A.Fld_KPMG_Itemcode as ItemCode ,Fld_KPMG_Quantity AS Quantity FROM Tbl_KPMG_MoItems A
					INNER JOIN Tbl_KPMG_StockMaster B ON A.Fld_KPMG_Itemcode=B.Fld_KPMG_ItemCode
					INNER JOIN Tbl_KPMG_StockDetails C ON C.Fld_KPMG_Stock_Id=B.Fld_KPMG_Stock_Id
					AND A.Fld_KPMG_Mo_Id= @MoveOrderNo
					AND C.Fld_KPMG_isIssued=0
				END
			

	END



END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
