CREATE PROCEDURE [dbo].[uspCheckHierarchyMaster]
(
	@iHierarchyId int
)	

AS
BEGIN TRY

	SET NOCOUNT ON;

	SELECT COUNT(*) FROM dbo.T_User_Hierarchy_Details 
		WHERE I_Hierarchy_Detail_ID IN
			(SELECT I_Hierarchy_Detail_ID FROM dbo.T_Hierarchy_Details 
				WHERE I_Hierarchy_Master_ID = @iHierarchyId)
			
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
