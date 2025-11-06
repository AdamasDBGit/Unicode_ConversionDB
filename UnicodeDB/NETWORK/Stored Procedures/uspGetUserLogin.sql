-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	GETS list for all Payment Types
-- =============================================
CREATE PROCEDURE [NETWORK].[uspGetUserLogin]
@iUserID INT 
AS
BEGIN

	SELECT  S_Login_ID 
		FROM  T_User_Master
		WHERE  I_User_ID=@iUserID

END
