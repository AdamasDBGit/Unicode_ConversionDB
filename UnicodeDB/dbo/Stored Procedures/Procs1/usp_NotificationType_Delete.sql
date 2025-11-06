
CREATE   PROCEDURE dbo.usp_NotificationType_Delete
    @NotificationTypeID INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM T_ERP_NotificationType
    WHERE I_NotificationType_ID = @NotificationTypeID;

    SELECT @@ROWCOUNT AS RowsAffected;
END;
