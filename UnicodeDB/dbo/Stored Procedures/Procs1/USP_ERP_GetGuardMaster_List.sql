CREATE PROCEDURE [dbo].[USP_ERP_GetGuardMaster_List]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM T_ERP_GuardMaster
    ORDER BY I_Guard_ID DESC;
END;
