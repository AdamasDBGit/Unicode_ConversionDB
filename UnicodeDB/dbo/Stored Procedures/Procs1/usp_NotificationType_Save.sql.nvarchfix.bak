
CREATE   PROCEDURE dbo.usp_NotificationType_Save
    @NotificationTypeID INT = NULL,
    @NotificationTypeName Nnvarchar(max),
    @BrandId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF ISNULL(@NotificationTypeID, 0) = 0
    BEGIN
        INSERT INTO T_ERP_NotificationType (S_NotificationType_Name, inBrandId)
        VALUES (@NotificationTypeName, @BrandId);

        SELECT CAST(SCOPE_IDENTITY() AS INT) AS NotificationTypeID;
    END
    ELSE
    BEGIN
        UPDATE T_ERP_NotificationType
        SET S_NotificationType_Name = @NotificationTypeName
        WHERE I_NotificationType_ID = @NotificationTypeID;

        SELECT @NotificationTypeID AS NotificationTypeID;
    END
END;
