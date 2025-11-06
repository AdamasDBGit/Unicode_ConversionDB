
CREATE   PROCEDURE dbo.usp_NotificationCategory_Get
    @NotificationCategoryID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        I_Event_Category_ID AS NotificationCategoryID,
        S_Event_Category AS NotificationCategoryName,
        I_Status
    FROM T_Event_Category
    WHERE I_Event_Category_ID = @NotificationCategoryID;
END;
