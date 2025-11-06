-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: 03/01/2007
-- Description:	Loads all the user type 
-- =============================================
CREATE PROCEDURE [dbo].[uspGetUserType]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

    SELECT I_User_Type_ID, S_User_Type_Code, S_User_Type_Desc
	FROM dbo.T_User_Type_Master
END
