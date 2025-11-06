CREATE PROCEDURE [ECOMMERCE].[uspUpdateBatchAvailabilityNotification](@ID INT)
AS
BEGIN

	update ECOMMERCE.T_Batch_Availability_Notification set NotifiedOn=GETDATE(),StatusID=0 where ID=@ID and StatusID=1
	


END
