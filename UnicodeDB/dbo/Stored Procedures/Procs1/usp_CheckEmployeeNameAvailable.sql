
-- Check Employee Name Availability
CREATE PROCEDURE [dbo].[usp_CheckEmployeeNameAvailable]
    @sEmployeeName NVARCHAR(200),
    @UserID INT = NULL
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM T_ERP_User
        WHERE S_First_Name + ' ' + ISNULL(S_Middle_Name,'') + ' ' + ISNULL(S_Last_Name,'') = @sEmployeeName
          AND I_Status = 1
          AND (@UserID IS NULL OR I_User_ID <> @UserID)
    )
        SELECT 0; -- Taken
    ELSE
        SELECT 1; -- Available
END
