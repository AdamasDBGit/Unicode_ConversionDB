CREATE PROCEDURE [dbo].[uspInsertTaskList] 
(	
	@sTaskListXML xml
)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @TaskListPosition SMALLINT, @TaskListCount SMALLINT
	DECLARE @TaskListXML XML
	DECLARE @iTaskMasterId int
	DECLARE @sTaskDescription varchar(500)
	DECLARE @sQueryString varchar(100)
	DECLARE @iStatus int
	DECLARE @swfInstanceId varchar(500)
	DECLARE @dDueDate datetime
	DECLARE @iHierarchyMasterID INT
	DECLARE @sHierarchyChain varchar(100)
	DECLARE @sKeyValue xml	
		
	DECLARE @iTaskDetailId int
	DECLARE @iDocHandle int
	DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT
	DECLARE	@KeyValueXml XML 
	DECLARE @sKey VARCHAR(50) 
	DECLARE @sValue VARCHAR(100)

	BEGIN TRANSACTION
	
	SET @TaskListPosition = 1
	SET @TaskListCount = @sTaskListXML.value('count((TaskList/Task))','int')
	
	WHILE (@TaskListPosition<=@TaskListCount)
	-- Loop for each task in the TaskList xml
	BEGIN
			--Get the Task node for the Current Position
			SET @TaskListXML = @sTaskListXML.query('/TaskList/Task[position()=sql:variable("@TaskListPosition")]')
			SELECT @iTaskMasterId = Task.a.value('@TaskMasterID','INT'),
				   @sTaskDescription = Task.a.value('@Description','varchar(500)'),
				   @sQueryString = Task.a.value('@Querystring','varchar(100)'),
				   @iStatus = Task.a.value('@Status','int'),
				   @swfInstanceId = Task.a.value('@WfInstanceID','varchar(500)'),
				   @dDueDate = Task.a.value('@DueDate','datetime'),
				   @iHierarchyMasterID = Task.a.value('@HierarchyMasterID','INT'),
				   @sHierarchyChain = Task.a.value('@HierarchyChain','varchar(100)')		   
				  -- @sKeyValue = Task.a.value('@KeyValueList','xml')
			FROM @TaskListXML.nodes('/Task') Task(a)
			
			INSERT INTO T_Task_Details
			(
				I_Task_Master_Id,
				S_Task_Description,
				S_Querystring,
				I_Hierarchy_Master_ID,
				S_Hierarchy_Chain,
				I_Status,
				S_Wf_Instanceid,
				Dt_Due_date,
				Dt_Created_Date
			)
			VALUES
			(
				@iTaskMasterId,
				@sTaskDescription,
				@sQueryString,
				@iHierarchyMasterID,
				@sHierarchyChain,
				@iStatus,
				@swfInstanceId,
				@dDueDate,
				GETDATE()
			)			
			
			SET @iTaskDetailId = @@IDENTITY
			SET @sKeyValue = @TaskListXML.query('/Task/KeyValueList')
			SET @AdjPosition = 1
			SET @AdjCount = @sKeyValue.value('count((KeyValueList/KeyValue))','int')

			WHILE(@AdjPosition<=@AdjCount)
			BEGIN
				--Get the Adjustment node for the Current Position
					SET @KeyValueXml = @sKeyValue.query('/KeyValueList/KeyValue[position()=sql:variable("@AdjPosition")]')
					SELECT	@sKey = T.a.value('@S_Key','varchar(50)'),
							@sValue = T.a.value('@S_Value','varchar(100)')		
					FROM @KeyValueXml.nodes('/KeyValue') T(a)
					
					INSERT INTO T_Task_Mapping
					(
						I_Task_Details_Id,
						S_Key,
						S_Value
					)
					Values (@iTaskDetailId, @sKey, @sValue )
				SET @AdjPosition = @AdjPosition + 1
			END
			
			SET @TaskListPosition = @TaskListPosition + 1
	END
	
	COMMIT TRANSACTION
	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
