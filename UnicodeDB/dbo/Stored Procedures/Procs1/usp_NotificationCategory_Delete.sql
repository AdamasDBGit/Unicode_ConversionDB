
CREATE   PROCEDURE dbo.usp_NotificationCategory_Delete
    @NotificationCategoryID INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM T_Event_Category
    WHERE I_Event_Category_ID = @NotificationCategoryID;

    SELECT @@ROWCOUNT AS RowsAffected;
END;
