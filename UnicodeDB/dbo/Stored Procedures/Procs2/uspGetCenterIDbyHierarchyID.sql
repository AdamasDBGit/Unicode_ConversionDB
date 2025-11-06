CREATE PROCEDURE [dbo].[uspGetCenterIDbyHierarchyID]
	(
		@iSelectedHierarchyId int
	)

AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD WHERE 
	TCHD.I_Hierarchy_Detail_ID = @iSelectedHierarchyId  
	AND I_Status <> 0 
	AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())
		
END
