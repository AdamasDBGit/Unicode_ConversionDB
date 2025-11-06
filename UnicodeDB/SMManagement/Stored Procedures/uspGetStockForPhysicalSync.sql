CREATE PROCEDURE [SMManagement].[uspGetStockForPhysicalSync]
(
	@ItemCode VARCHAR(MAX),
	@StockCount INT
)
AS
BEGIN

	insert into SMManagement.T_StockvsPhysical_Temp
	select TOP(@StockCount) ItemCode,ItemDescription,Barcode,StockID,StatusID 
	from 
	SMManagement.T_Stock_Master
	where
	ItemCode=@ItemCode and StatusID=1
	order by StockID DESC


END
