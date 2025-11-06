CREATE   PROCEDURE dbo.usp_NotificationType_List
    @BrandId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        I_NotificationType_ID AS NotificationTypeID,
        S_NotificationType_Name AS NotificationTypeName,
        I_Status,
        IsDefaultProvided
    FROM T_ERP_NotificationType
    WHERE inBrandId = @BrandId;
END;
