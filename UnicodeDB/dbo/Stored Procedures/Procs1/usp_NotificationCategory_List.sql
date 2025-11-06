
CREATE   PROCEDURE dbo.usp_NotificationCategory_List
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        I_Event_Category_ID AS NotificationCategoryID,
        S_Event_Category AS NotificationCategoryName,
        I_Status,
        IsDefaultProvided
    FROM T_Event_Category;
END;
