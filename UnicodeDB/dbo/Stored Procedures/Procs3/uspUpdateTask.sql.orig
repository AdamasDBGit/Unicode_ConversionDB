CREATE PROCEDURE [dbo].[uspUpdateTask] 
(
	@iTaskDetailId int,
	@iTaskMasterId int,
	@sTaskDescription varchar(500),
	@sQueryString varchar(100),
	@iHierarchyMasterId int,
	@sHierarchyChain varchar(100),
	@iStatus int,
	@swfInstanceId int 
)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE T_Task_Details 
	SET
		I_Task_Master_Id = ISNULL(@iTaskMasterId,I_Task_Master_Id),
		S_Task_Description= ISNULL(@sTaskDescription,S_Task_Description),
		S_Querystring = ISNULL(@sQueryString,S_Querystring),
		I_Status = ISNULL(@iStatus,I_Status),
		S_Wf_Instanceid = ISNULL(@swfInstanceId,S_Wf_Instanceid),
		I_Hierarchy_Master_ID = ISNULL(@iHierarchyMasterId,I_Hierarchy_Master_ID),
		S_Hierarchy_Chain = ISNULL(@sHierarchyChain,S_Hierarchy_Chain)		
	WHERE
		I_Task_Details_Id = @iTaskDetailId
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
