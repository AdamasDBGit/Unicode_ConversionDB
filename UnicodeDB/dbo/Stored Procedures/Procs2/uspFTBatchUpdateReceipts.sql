CREATE PROCEDURE [dbo].[uspFTBatchUpdateReceipts]
 
AS
BEGIN

	UPDATE dbo.T_Receipt_Header SET S_Fund_Transfer_Status = 'Y' WHERE S_Fund_Transfer_Status = 'N' AND I_Status = 1
	UPDATE dbo.T_Receipt_Header SET S_Fund_Transfer_Status = 'N' WHERE S_Fund_Transfer_Status = 'Y' AND I_Status = 0

END
