CREATE PROCEDURE [dbo].[uspGetUserInstances] 

-- Add the parameters for the stored procedure here

@iHierarchyDetailID INT

AS
BEGIN

	SELECT	*			
	FROM dbo.T_User_Hierarchy_Details 
	WHERE I_Hierarchy_Detail_ID = @iHierarchyDetailID
	AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())
	AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())

END
