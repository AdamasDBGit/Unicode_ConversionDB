
CREATE   PROCEDURE dbo.usp_NotificationCategory_Save
    @NotificationCategoryID INT = NULL,
    @NotificationCategoryName NVARCHAR(max)
AS
BEGIN
    SET NOCOUNT ON;

    IF ISNULL(@NotificationCategoryID, 0) = 0
    BEGIN
        INSERT INTO T_Event_Category (S_Event_Category, I_Status)
        VALUES (@NotificationCategoryName, 1);

        SELECT CAST(SCOPE_IDENTITY() AS INT) AS NotificationCategoryID;
    END
    ELSE
    BEGIN
        UPDATE T_Event_Category
        SET S_Event_Category = @NotificationCategoryName
        WHERE I_Event_Category_ID = @NotificationCategoryID;

        SELECT @NotificationCategoryID AS NotificationCategoryID;
    END
END;

