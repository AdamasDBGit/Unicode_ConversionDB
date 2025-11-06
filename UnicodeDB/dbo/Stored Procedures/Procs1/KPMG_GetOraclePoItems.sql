
CREATE PROCEDURE [dbo].[KPMG_GetOraclePoItems]
@poNumber NVARCHAR(255),
@xml XML
AS
BEGIN TRY 

	SELECT DISTINCT(ISNULL(B.Fld_KPMG_Item_Id,'')) as ItemId,ISNULL(A.OracleLinieId,'')as OracleLineId FROM Tbl_KPMG_PoDetailItems A 
	INNER JOIN Tbl_KPMG_PoDetails B ON A.Fld_KPMG_PoPr_Id=B.Fld_KPMG_PoPr_Id
	CROSS APPLY  @xml.nodes('/Root/ItemCode') T ( c ) 
	WHERE  B.Fld_KPMG_PO_Id = @poNumber AND T.c.value('(.)', 'NVARCHAR(255)') = B.Fld_KPMG_Item_Id	

	



END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
