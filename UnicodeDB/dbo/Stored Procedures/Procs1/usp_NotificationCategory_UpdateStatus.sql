
CREATE   PROCEDURE dbo.usp_NotificationCategory_UpdateStatus
    @NotificationCategoryID INT,
    @Status INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE T_Event_Category
    SET I_Status = @Status
    OUTPUT inserted.I_Status
    WHERE I_Event_Category_ID = @NotificationCategoryID;
END;
