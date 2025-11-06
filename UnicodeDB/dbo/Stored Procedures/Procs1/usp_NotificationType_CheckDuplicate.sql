
CREATE   PROCEDURE dbo.usp_NotificationType_CheckDuplicate
    @NotificationTypeID INT = NULL,
    @NotificationTypeName NVARCHAR(max),
    @BrandId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT COUNT(1) AS DuplicateCount
    FROM T_ERP_NotificationType
    WHERE S_NotificationType_Name = @NotificationTypeName
      AND inBrandId = @BrandId
      AND (@NotificationTypeID IS NULL OR I_NotificationType_ID <> @NotificationTypeID);
END;

