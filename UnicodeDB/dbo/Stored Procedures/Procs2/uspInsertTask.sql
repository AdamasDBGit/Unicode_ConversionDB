CREATE PROCEDURE [dbo].[uspInsertTask] 
(
	@iTaskMasterId int,
	@sTaskDescription NVARCHAR(max) = null,
	@sQueryString NVARCHAR(max) = null,
	@iHierarchyMasterId int,
	@sHierarchyChain NVARCHAR(max),
	@iStatus int,
	@swfInstanceId NVARCHAR(max) = null,
	@sKeyValue xml,
	@dDueDate datetime
)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @iTaskDetailId int
	DECLARE @iDocHandle int
	DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT
	DECLARE	@KeyValueXml XML 
	DECLARE @sKey nvarchar(max) 
	DECLARE @sValue nvarchar(max)

	BEGIN TRANSACTION

	INSERT INTO T_Task_Details
	(
		I_Task_Master_Id,
		S_Task_Description,
		S_Querystring,
		I_Status,
		I_Hierarchy_Master_ID,
		S_Hierarchy_Chain,
		S_Wf_Instanceid,
		Dt_Due_date,
		Dt_Created_Date
	)
	VALUES
	(
		@iTaskMasterId,
		@sTaskDescription,
		@sQueryString,
		@iStatus,
		@iHierarchyMasterId,
		@sHierarchyChain,
		@swfInstanceId,
		@dDueDate,
		GETDATE()
	)
	
	SET @iTaskDetailId = @@IDENTITY
	
	SET @AdjPosition = 1
	SET @AdjCount = @sKeyValue.value('count((KeyValueList/KeyValue))','int')

	WHILE(@AdjPosition<=@AdjCount)
	BEGIN
		--Get the Adjustment node for the Current Position
			SET @KeyValueXml = @sKeyValue.query('/KeyValueList/KeyValue[position()=sql:variable("@AdjPosition")]')
			SELECT	@sKey = T.a.value('@S_Key','nvarchar(max)'),
					@sValue = T.a.value('@S_Value','nvarchar(max)')		
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

	SELECT @iTaskDetailId
	

	COMMIT TRANSACTION
	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH


