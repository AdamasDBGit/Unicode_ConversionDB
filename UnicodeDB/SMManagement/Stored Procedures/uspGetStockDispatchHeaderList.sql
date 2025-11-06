CREATE PROCEDURE [SMManagement].[uspGetStockDispatchHeaderList]
AS
BEGIN

SELECT TSDH.StockDispatchHeaderID,TSDH.StockDispatchHeaderName FROM SMManagement.T_Stock_Dispatch_Header AS TSDH WHERE TSDH.IsDispatched<>1 AND TSDH.StatusID=1 AND ISNULL(TSDH.ItemCount,0)>0

END
