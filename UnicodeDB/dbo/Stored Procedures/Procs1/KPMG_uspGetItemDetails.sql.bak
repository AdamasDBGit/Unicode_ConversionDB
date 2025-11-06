
CREATE PROCEDURE [dbo].[KPMG_uspGetItemDetails]
@MoveOrderNo INT,
@ItemCode NVARCHAR(100)

AS

	BEGIN TRY 
--select * from Tbl_KPMG_MoItems
	SELECT  Fld_KPMG_MoItem_Id AS ItemId FROM Tbl_KPMG_MoItems WHERE Fld_KPMG_Itemcode=@ItemCode AND Fld_KPMG_Mo_Id= @MoveOrderNo
	--SELECT  Fld_KPMG_OracleLineNumber AS ItemId FROM Tbl_KPMG_MoItems WHERE Fld_KPMG_Itemcode=@ItemCode AND Fld_KPMG_Mo_Id= @MoveOrderNo
	END TRY
	BEGIN CATCH
		
		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

		SELECT	@ErrMsg = ERROR_MESSAGE(),
				@ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
