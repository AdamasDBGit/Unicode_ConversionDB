CREATE PROCEDURE [dbo].[uspValidateParentInstance] 
(
	
	@iParentID int
)

AS
BEGIN
	IF EXISTS ( SELECT I_Hierarchy_Detail_ID FROM dbo.T_Hierarchy_Mapping_Details WHERE I_Status =1 AND I_Hierarchy_Detail_ID = @iParentID )
		SELECT 0
	ELSE
		SELECT 1
END
