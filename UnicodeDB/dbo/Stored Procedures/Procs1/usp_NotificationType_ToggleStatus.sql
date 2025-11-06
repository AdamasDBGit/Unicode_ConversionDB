
CREATE   PROCEDURE dbo.usp_NotificationType_ToggleStatus
    @NotificationTypeID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE T_ERP_NotificationType
    SET I_Status = CASE WHEN I_Status = 1 THEN 0 ELSE 1 END
    OUTPUT inserted.I_Status
    WHERE I_NotificationType_ID = @NotificationTypeID;
END;
