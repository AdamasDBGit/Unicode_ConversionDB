
CREATE PROCEDURE [dbo].[KPMG_uspGetNotificationMessages]

@BranchId varchar(255)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT Id as SlNo,NotificationMessage,TaskMessage,ISNULL(ItemAmount,'') as ItemAmount from tbl_KPMG_Notifications
	
	
END
