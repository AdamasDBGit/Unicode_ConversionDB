
CREATE   PROCEDURE dbo.usp_NotificationType_Get
    @NotificationTypeID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        I_NotificationType_ID AS NotificationTypeID,
        S_NotificationType_Name AS NotificationTypeName,
        I_Status,
        IsDefaultProvided,
        inBrandId
    FROM T_ERP_NotificationType
    WHERE I_NotificationType_ID = @NotificationTypeID;
END;
