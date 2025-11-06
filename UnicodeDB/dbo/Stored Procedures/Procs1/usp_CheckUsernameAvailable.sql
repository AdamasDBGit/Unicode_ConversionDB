-- Check Username Availability
CREATE PROCEDURE [dbo].[usp_CheckUsernameAvailable]
    @UserName NVARCHAR(200),
    @UserID INT = NULL
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM T_ERP_User
        WHERE S_Username = @UserName
          AND I_Status = 1
          AND (@UserID IS NULL OR I_User_ID <> @UserID)
    )
        SELECT 0; -- Taken
    ELSE
        SELECT 1; -- Available
END
