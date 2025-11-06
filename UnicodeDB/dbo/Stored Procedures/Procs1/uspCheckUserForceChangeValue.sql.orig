CREATE PROC [dbo].[uspCheckUserForceChangeValue]
(
@sLoginID VARCHAR(500),
@sPassword VARCHAR(200)
)
AS 
BEGIN
	
	SET NOCOUNT ON	
	
	SELECT ISNULL(B_Force_Password_Change,0) B_Force_Password_Change FROM T_User_Master
	WHERE S_Login_ID = @sLoginID
	AND S_Password = @sPassword
	AND I_Status = 1
	
END
