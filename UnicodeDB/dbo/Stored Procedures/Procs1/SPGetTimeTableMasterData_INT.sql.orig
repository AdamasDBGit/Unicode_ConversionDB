-- =============================================

-- =============================================
--SPGetTimeTableMasterData null,0,'2018/08/01'
CREATE  PROCEDURE [dbo].[SPGetTimeTableMasterData_INT]
(
	@UpdateON			         Varchar(20) =NULL,
	@MaxID				         INT		 =NULL,
	@RecordFetchStartDate        nvarchar(10) =null
)
AS
BEGIN
	DECLARE @VarDate	DATE;

	IF @UpdateON='' OR @UpdateON IS NULL
	BEGIN
		SET @VarDate=NULL
	END
	ELSE
	BEGIN
		SET @VarDate=CAST(@UpdateON AS DATE)
	END


	IF @RecordFetchStartDate ='' OR @RecordFetchStartDate IS NULL
	BEGIN
	 SET  @RecordFetchStartDate=null
	END
	ELSE
	 BEGIN
	  SET @RecordFetchStartDate=CAST(@RecordFetchStartDate AS DATE)
	 END



	IF @MaxID<>0  AND @VarDate IS NULL
	BEGIN
		SELECT
		[I_TimeTable_ID]						AS Id,						
		[I_Center_ID]							AS CenterId,	
		--[Dt_Schedule_Date]						AS ScheduleDate,
		Convert( varchar, Dt_Schedule_Date,103)   AS ScheduleDate,
		[I_TimeSlot_ID]							AS TimeSlotId,						
		[I_Batch_ID]							AS BatchId,							
		[I_Room_ID]								AS RoomId,						
		[I_Skill_ID]							AS SkillId,		
		[S_Remarks]								AS Remarks,	
		[I_Term_ID]								AS TermId,	
		[I_Module_ID]							AS ModuleId,										
		[I_Session_ID]							AS SessionId,						
		[S_Session_Name]						AS SessionName,							
		[S_Session_Topic]						AS SessionTopic,											
		--[Dt_Actual_Date]						AS ActualDate,	
		Convert( varchar,Dt_Actual_Date,103)     AS ActualDate,																						
		[I_Is_Complete]							AS IsComplete,					
		[I_Sub_Batch_ID]						AS SubBatchId,						
		[I_SessionTopic_Completed_Status_ID]	AS SessionTopicCompletedStatusId,	
		[I_ClassTest_Status_ID]					AS ClassTestStatusId,			
		[I_Status]								AS [Status]	,
		0										AS [IsForUpdate]				
		FROM [dbo].[T_TimeTable_Master]
		WHERE
		[I_TimeTable_ID]>@MaxID
		AND CAST(Dt_Schedule_Date AS DATE)>=@RecordFetchStartDate
		AND [I_Batch_ID] IS NOT NULL
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT DISTINCT
		Id,						
		CenterId,	
		ScheduleDate,						
		TimeSlotId,						
		BatchId,							
		RoomId,						
		SkillId,		
		Remarks,	
		TermId,	
		ModuleId,							
		SessionId,						
		SessionName,							
		SessionTopic,						
		ActualDate,							
		IsComplete,					
		SubBatchId,						
		SessionTopicCompletedStatusId,	
		ClassTestStatusId,			
		[Status]	,
		CASE WHEN Id>@MaxID THEN 0 ELSE 1 END AS  [IsForUpdate]	
		FROM
		(
			SELECT
			[I_TimeTable_ID]						AS Id,						
			[I_Center_ID]							AS CenterId,	
			--[Dt_Schedule_Date]					AS ScheduleDate,	
			Convert( varchar,Dt_Schedule_Date,103)   AS ScheduleDate,					
			[I_TimeSlot_ID]							AS TimeSlotId,						
			[I_Batch_ID]							AS BatchId,							
			[I_Room_ID]								AS RoomId,						
			[I_Skill_ID]							AS SkillId,		
			[S_Remarks]								AS Remarks,	
			[I_Term_ID]								AS TermId,	
			[I_Module_ID]							AS ModuleId,										
			[I_Session_ID]							AS SessionId,						
			[S_Session_Name]						AS SessionName,							
			[S_Session_Topic]						AS SessionTopic,											
			--[Dt_Actual_Date]						AS ActualDate,	
			Convert( varchar,Dt_Actual_Date,103)     AS ActualDate,																						
			[I_Is_Complete]							AS IsComplete,					
			[I_Sub_Batch_ID]						AS SubBatchId,						
			[I_SessionTopic_Completed_Status_ID]	AS SessionTopicCompletedStatusId,	
			[I_ClassTest_Status_ID]					AS ClassTestStatusId,			
			[I_Status]								AS [Status]	
			FROM [dbo].[T_TimeTable_Master]			
			WHERE CAST([Dt_Updt_On] AS DATE)>=@VarDate
			AND CAST(Dt_Schedule_Date AS DATE)>=@RecordFetchStartDate
			AND [I_Batch_ID] IS NOT NULL
			UNION
			SELECT
			[I_TimeTable_ID]						AS Id,						
			[I_Center_ID]							AS CenterId,	
		--[Dt_Schedule_Date]						AS ScheduleDate,	
			Convert( varchar,Dt_Schedule_Date,103)   AS ScheduleDate,					
			[I_TimeSlot_ID]							AS TimeSlotId,						
			[I_Batch_ID]							AS BatchId,							
			[I_Room_ID]								AS RoomId,						
			[I_Skill_ID]							AS SkillId,		
			[S_Remarks]								AS Remarks,	
			[I_Term_ID]								AS TermId,	
			[I_Module_ID]							AS ModuleId,										
			[I_Session_ID]							AS SessionId,						
			[S_Session_Name]						AS SessionName,							
			[S_Session_Topic]						AS SessionTopic,											
		--[Dt_Actual_Date]						AS ActualDate,	
			Convert( varchar,Dt_Actual_Date,103)     AS ActualDate,																						
			[I_Is_Complete]							AS IsComplete,					
			[I_Sub_Batch_ID]						AS SubBatchId,						
			[I_SessionTopic_Completed_Status_ID]	AS SessionTopicCompletedStatusId,	
			[I_ClassTest_Status_ID]					AS ClassTestStatusId,			
			[I_Status]								AS [Status]	
			FROM [dbo].[T_TimeTable_Master]
			WHERE
			[I_TimeTable_ID]>@MaxID
			AND CAST(Dt_Schedule_Date AS DATE)>=@RecordFetchStartDate
			AND [I_Batch_ID] IS NOT NULL
		)AS A


	END
	ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT
			[I_TimeTable_ID]						AS Id,						
			[I_Center_ID]							AS CenterId,	
		 --[Dt_Schedule_Date]						AS ScheduleDate,	
			Convert( varchar,Dt_Schedule_Date,103)   AS ScheduleDate,				
			[I_TimeSlot_ID]							AS TimeSlotId,						
			[I_Batch_ID]							AS BatchId,							
			[I_Room_ID]								AS RoomId,						
			[I_Skill_ID]							AS SkillId,		
			[S_Remarks]								AS Remarks,	
			[I_Term_ID]								AS TermId,	
			[I_Module_ID]							AS ModuleId,						
			[I_Session_ID]							AS SessionId,						
			[S_Session_Name]						AS SessionName,						
			[S_Session_Topic]						AS SessionTopic,					
	 	  --[Dt_Actual_Date]						AS ActualDate,	
			Convert(varchar,Dt_Actual_Date,103)     AS ActualDate,					
			[I_Is_Complete]							AS IsComplete,					
			[I_Sub_Batch_ID]						AS SubBatchId,						
			[I_SessionTopic_Completed_Status_ID]	AS SessionTopicCompletedStatusId,	
			[I_ClassTest_Status_ID]					AS ClassTestStatusId,			
			[I_Status]								AS [Status]	,
			1										AS [IsForUpdate]			
			FROM [dbo].[T_TimeTable_Master]			
			WHERE CAST([Dt_Updt_On] AS DATE)>=@VarDate
			AND CAST(Dt_Schedule_Date AS DATE)>=@RecordFetchStartDate
			AND [I_Batch_ID] IS NOT NULL
	END
	ELSE IF @MaxID=0 AND @VarDate IS  NULL
	BEGIN
		SELECT  
			[I_TimeTable_ID]						AS Id,						
			[I_Center_ID]							AS CenterId,	
		--[Dt_Schedule_Date]						AS ScheduleDate,	
			Convert( varchar,Dt_Schedule_Date,103)   AS ScheduleDate,				
			[I_TimeSlot_ID]							AS TimeSlotId,						
			[I_Batch_ID]							AS BatchId,							
			[I_Room_ID]								AS RoomId,						
			[I_Skill_ID]							AS SkillId,		
			[S_Remarks]								AS Remarks,	
			[I_Term_ID]								AS TermId,	
			[I_Module_ID]							AS ModuleId,						
			[I_Session_ID]							AS SessionId,						
			[S_Session_Name]						AS SessionName,						
			[S_Session_Topic]						AS SessionTopic,					
			--[Dt_Actual_Date]						AS ActualDate,	
			Convert( varchar,Dt_Actual_Date,103)     AS ActualDate,					
			[I_Is_Complete]							AS IsComplete,					
			[I_Sub_Batch_ID]						AS SubBatchId,						
			[I_SessionTopic_Completed_Status_ID]	AS SessionTopicCompletedStatusId,	
			[I_ClassTest_Status_ID]					AS ClassTestStatusId,			
			[I_Status]								AS [Status]	,
			0										AS [IsForUpdate]			
			FROM [dbo].[T_TimeTable_Master]	
			where CAST(Dt_Schedule_Date AS DATE)>=@RecordFetchStartDate
			AND [I_Batch_ID] IS NOT NULL
	END
END
