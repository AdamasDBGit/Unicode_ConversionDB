
CREATE PROCEDURE [dbo].[KPMG_uspGetOracleMOLineId]
@ItemXmlData	XML,
@MoId	INT
AS

BEGIN TRY 

	DECLARE @MATERIAL_TEMP TABLE(BarCode NVARCHAR(max),CourseName NVARCHAR(max),ItemCode NVARCHAR(max),MoveOrderNo INT, Slno NVARCHAR(max),Defaulter NVARCHAR(max))
	DECLARE @TEMP_TABLE TABLE(Id INT Identity,BarCode nvarchar(max),MoLineId NVARCHAR(max), OracleMoveOrderId NVARCHAR(max), ItemCode nvarchar(max), ItemId nvarchar(max))
	
	INSERT INTO @TEMP_TABLE (OracleMoveOrderId, BarCode, MoLineId,ItemCode, ItemId)
	SELECT Mstr.Fld_KPMG_OracleMoNumber,Dtl.Fld_KPMG_Barcode, Dtl.Fld_KPMG_OracleMoLineId,T.c.value('itemCode[1]', 'NVARCHAR(max)') ,MoItm.Fld_KPMG_MoItem_Id
	FROM Tbl_KPMG_StockDetails Dtl 
	JOIN @ItemXmlData.nodes('/ROOT/Material') T ( c )  on Dtl.Fld_KPMG_Barcode = T.c.value('BarCode[1]', 'NVARCHAR(max)')
	JOIN Tbl_KPMG_MoItems MoItm ON MoItm.Fld_KPMG_Itemcode = T.c.value('itemCode[1]', 'NVARCHAR(max)') 
	JOIN Tbl_KPMG_StockMaster Mstr on Mstr.Fld_KPMG_Stock_Id = Dtl.Fld_KPMG_Stock_Id 
	WHERE Mstr.Fld_KPMG_Mo_Id = @MoId  and MoItm.Fld_KPMG_Mo_Id = @MoId
	
	SELECT * FROM @TEMP_TABLE ORDER BY BarCode
	--INSERT INTO @MATERIAL_TEMP(BarCode,CourseName,ItemCode,MoveOrderNo,Slno,Defaulter)
	--SELECT  T.c.value('BarCode[1]', 'NVARCHAR(255)') ,
	--		T.c.value('courseName[1]', 'NVARCHAR(255)') ,
	--		T.c.value('itemCode[1]', 'NVARCHAR(255)') ,
	--		@MoId ,
	--		T.c.value('slno[1]', 'NVARCHAR(255)'),
	--		T.c.value('defaulter[1]', 'NVARCHAR(255)')                                                                      
 --   FROM    @ItemXmlData.nodes('/ROOT/Material') T ( c )   
    
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

