CREATE PROCEDURE [dbo].[USP_ERP_GetGuardMaster_Details]
    @I_Guard_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM T_ERP_GuardMaster
    WHERE I_Guard_ID = @I_Guard_ID;
END;