-- =============================================

-- =============================================
-- select * from T_Student_Batch_Master
--SPGetBatchMasterData '2018/08/08',8821
CREATE  PROCEDURE [dbo].[SPGetBatchMasterData_INT]
(
	@UpdateON			Varchar(20) =NULL,
	@MaxID				INT			=NULL
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
		SET @VarDate=CAST(@UpdateON AS DATETIME)
	END	


	 
	IF @MaxID<>0  AND @VarDate IS NULL
	BEGIN

	PRINT('A')
		SELECT 
		[I_Batch_ID]							AS		[Id]		,			
		[S_Batch_Code]							AS		[BatchCode]	,		
		[I_Course_ID]							AS		[CourseId]	,		
		[I_Delivery_Pattern_ID]					AS		[DeliveryPatternId]	,
		[I_TimeSlot_ID]							AS		[TimeSlotId]	,		
		 Convert( varchar, Dt_BatchStartDate ,103 ) AS BatchStartDate, --'dd/MM/yyyy' 
		 Convert( varchar, Dt_Course_Expected_End_Date ,103 ) AS CourseExpectedEndDate, --'dd/MM/yyyy' 
    	 Convert( varchar, Dt_Course_Actual_End_Date , 103) AS CourseActualEndDate, --'dd/MM/yyyy' 
		 [S_Batch_Name]							AS		[BatchName]		,	
		 [b_IsApproved]							AS		[IsApproved]	,		
		 [I_Status]								AS		[Status]	,			
		Convert(varchar, Dt_BatchIntroductionDate , 103) AS BatchIntroductionDate,--'dd/MM/yyyy' 
		[s_BatchIntroductionTime]				AS		[BatchIntroductionTime],
		0										AS		[IsForUpdate]	

		FROM [dbo].[T_Student_Batch_Master]
		WHERE [I_Batch_ID]>@MaxID
	END
	ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
	BEGIN
	PRINT('B')
		SELECT 
		[I_Batch_ID]							AS		[Id]		,			
		[S_Batch_Code]							AS		[BatchCode]	,		
		[I_Course_ID]							AS		[CourseId]	,		
		[I_Delivery_Pattern_ID]					AS		[DeliveryPatternId]	,
		[I_TimeSlot_ID]							AS		[TimeSlotId]	,		
		Convert( varchar, Dt_BatchStartDate , 103 ) AS BatchStartDate,
		Convert( varchar, Dt_Course_Expected_End_Date , 103 ) AS CourseExpectedEndDate,
    	Convert( varchar, Dt_Course_Actual_End_Date , 103) AS CourseActualEndDate,
		[S_Batch_Name]							AS		[BatchName]		,	
		[b_IsApproved]							AS		[IsApproved]	,		
		[I_Status]								AS		[Status]	,			
		Convert( varchar, Dt_BatchIntroductionDate , 103 ) AS BatchIntroductionDate,
		[s_BatchIntroductionTime]				AS		[BatchIntroductionTime],
		1										AS		[IsForUpdate]	
		FROM [dbo].[T_Student_Batch_Master]	
		WHERE CAST(Dt_Upd_On AS DATE)>@VarDate
	END
	ELSE IF @MaxID=0 AND @VarDate IS  NULL
	BEGIN
	PRINT('C')
		SELECT  
		[I_Batch_ID]							AS		[Id]		,			
		[S_Batch_Code]							AS		[BatchCode]	,		
		[I_Course_ID]							AS		[CourseId]	,		
		[I_Delivery_Pattern_ID]					AS		[DeliveryPatternId]	,
		[I_TimeSlot_ID]							AS		[TimeSlotId]	,		
		Convert( varchar, Dt_BatchStartDate ,103 ) AS BatchStartDate,
		Convert( varchar, Dt_Course_Expected_End_Date , 103 ) AS CourseExpectedEndDate,
    	Convert( varchar, Dt_Course_Actual_End_Date , 103 ) AS CourseActualEndDate,
		[S_Batch_Name]							AS		[BatchName]		,	
		[b_IsApproved]							AS		[IsApproved]	,		
		[I_Status]								AS		[Status]	,			
	 	Convert( varchar, Dt_BatchIntroductionDate , 103) AS BatchIntroductionDate,
		[s_BatchIntroductionTime]				AS		[BatchIntroductionTime],
		0										AS		[IsForUpdate]	
		FROM [dbo].[T_Student_Batch_Master]	
	
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN
 PRINT('D')

		SELECT DISTINCT
		[Id]		,			
		[BatchCode]	,		
		[CourseId]	,		
		[DeliveryPatternId]	,
		[TimeSlotId]	,		
		Convert( varchar, [BatchStartDate] , 103 )	AS	[BatchStartDate],
		Convert( varchar, [CourseExpectedEndDate] ,103 )	AS	[CourseExpectedEndDate],
		Convert( varchar,[CourseActualEndDate] , 103 )	AS	[CourseActualEndDate],
		[BatchName]		,	
		[IsApproved]	,		
		[Status]	,			
		Convert( varchar, [BatchIntroductionDate] , 103 )	AS	[BatchIntroductionDate],
		[BatchIntroductionTime],
		CASE WHEN [Id]>@MaxID THEN 0 ELSE 1 END AS [IsForUpdate]	
		FROM
		(
			SELECT 
			[I_Batch_ID]							AS		[Id]		,			
			[S_Batch_Code]							AS		[BatchCode]	,		
			[I_Course_ID]							AS		[CourseId]	,		
			[I_Delivery_Pattern_ID]					AS		[DeliveryPatternId]	,
			[I_TimeSlot_ID]							AS		[TimeSlotId]	,		
		   ISNULL(Convert( varchar, Dt_BatchStartDate ,103 ),Dt_BatchStartDate) AS BatchStartDate,
		   ISNULL(Convert( varchar, Dt_Course_Expected_End_Date , 103 ),Dt_Course_Expected_End_Date  ) AS CourseExpectedEndDate,
    	   ISNULL( Convert( varchar, Dt_Course_Actual_End_Date , 103 ),Dt_Course_Actual_End_Date ) AS CourseActualEndDate,
			[S_Batch_Name]							AS		[BatchName]		,	
			[b_IsApproved]							AS		[IsApproved]	,		
			[I_Status]								AS		[Status]	,			
		    ISNULL( Convert( varchar, Dt_BatchIntroductionDate , 103 ),Dt_BatchIntroductionDate  ) AS BatchIntroductionDate,
			[s_BatchIntroductionTime]				AS		[BatchIntroductionTime]
			--1										AS		[IsForUpdate]	
			FROM [dbo].[T_Student_Batch_Master]	
			WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
			UNION 
			SELECT 
			[I_Batch_ID]							AS		[Id]		,			
			[S_Batch_Code]							AS		[BatchCode]	,		
			[I_Course_ID]							AS		[CourseId]	,		
			[I_Delivery_Pattern_ID]					AS		[DeliveryPatternId]	,
			[I_TimeSlot_ID]							AS		[TimeSlotId]	,		
		 
			ISNULL( Convert( varchar, Dt_BatchStartDate , 103 ) ,Dt_BatchStartDate) AS BatchStartDate,
		    ISNULL( Convert( varchar, Dt_Course_Expected_End_Date ,103),Dt_Course_Expected_End_Date ) AS CourseExpectedEndDate,
    	    ISNULL(Convert( varchar, Dt_Course_Actual_End_Date ,103 ),Dt_Course_Actual_End_Date ) AS CourseActualEndDate,


			[S_Batch_Name]							AS		[BatchName]		,	
			[b_IsApproved]							AS		[IsApproved]	,		
			[I_Status]								AS		[Status]	,			
	 
		    ISNULL( Convert(varchar,Dt_BatchIntroductionDate ,103 ), Dt_BatchIntroductionDate) AS BatchIntroductionDate,
			[s_BatchIntroductionTime]				AS		[BatchIntroductionTime]
			--0										AS		[IsForUpdate]	

			FROM [dbo].[T_Student_Batch_Master]
			WHERE [I_Batch_ID]>@MaxID
		)AS A
	END
END
