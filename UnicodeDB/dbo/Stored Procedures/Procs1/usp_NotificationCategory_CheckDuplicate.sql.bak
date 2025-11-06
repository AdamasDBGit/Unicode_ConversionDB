
CREATE   PROCEDURE dbo.usp_NotificationCategory_CheckDuplicate
    @NotificationCategoryID INT = NULL,
    @NotificationCategoryName NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT COUNT(1) AS DuplicateCount
    FROM T_Event_Category
    WHERE S_Event_Category = @NotificationCategoryName
      AND (@NotificationCategoryID IS NULL OR I_Event_Category_ID <> @NotificationCategoryID);
END;
