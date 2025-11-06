CREATE PROCEDURE [dbo].[uspGetCountryIDbyCenterHierarchyID]
	(
		@iSelectedCenterHierarchyId int
	)

AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT I_Country_ID FROM T_Centre_Master 
	WHERE I_Centre_ID = (SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD WHERE 
							TCHD.I_Hierarchy_Detail_ID = @iSelectedCenterHierarchyId  
							AND I_Status <> 0 
							AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
							AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())
						)
END
