
CREATE PROCEDURE [dbo].[uspGetItemCodeListToLoad] 
(
	@MoveOrderNo INT
)

AS
	
BEGIN TRY 
	IF (ISNULL(@MoveOrderNo,'')<>'')
		BEGIN 
			IF EXISTS(SELECT 1 FROM Tbl_KPMG_MoMaster WHERE Fld_KPMG_Mo_Id= @MoveOrderNo AND Fld_KPMG_Status=0)
				BEGIN
					SELECT DISTINCT Fld_KPMG_MoItem_Id AS ItemId, C.Fld_KPMG_ItemCode_Description AS Description, A.Fld_KPMG_Mo_Id AS MoveOrderId, A.Fld_KPMG_Itemcode as ItemCode ,Fld_KPMG_Quantity AS Quantity
					FROM Tbl_KPMG_MoItems A
					INNER JOIN Tbl_KPMG_MoMaster B ON A.Fld_KPMG_Mo_Id=B.Fld_KPMG_Mo_Id	
					INNER JOIN Tbl_KPMG_SM_List C ON A.Fld_KPMG_Itemcode=C.Fld_KPMG_ItemCode				
					AND B.Fld_KPMG_Mo_Id= @MoveOrderNo
					
					
				END
			

	END



END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
