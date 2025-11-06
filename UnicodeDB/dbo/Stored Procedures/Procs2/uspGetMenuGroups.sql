-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: 26/12/2006
-- Description:	Gets all menu groups defined in the system
-- =============================================
CREATE PROCEDURE [dbo].[uspGetMenuGroups] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT I_Menu_Group_ID, S_Menu_Group_Name
	FROM dbo.T_Menu_Group_Master 
	WHERE I_Status = 1
	ORDER BY S_Menu_Group_Name
	
END
