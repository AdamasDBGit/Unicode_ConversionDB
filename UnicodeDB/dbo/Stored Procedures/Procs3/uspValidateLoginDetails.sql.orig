CREATE PROCEDURE [dbo].[uspValidateLoginDetails]
(
	@vLoginID VARCHAR(200),
	@iUserID INT
)
AS
BEGIN
	SELECT * FROM [dbo].[T_User_Master] AS TUM 
	WHERE [TUM].[S_Login_ID] = @vLoginID
	AND [TUM].[I_User_ID] != @iUserID
END
