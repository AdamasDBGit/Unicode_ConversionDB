-- =============================================

-- =============================================
CREATE  PROCEDURE [dbo].[SPGetCourseDeliveryMapData_INT]
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
		SET @VarDate=CAST(@UpdateON AS DATE)
	END

	IF @MaxID<>0  AND @VarDate IS NULL
	BEGIN
		SELECT 
		[I_Course_Delivery_ID]			AS [Id]				,
		[I_Delivery_Pattern_ID]			AS [DeliveryPatternId]	,
		[I_Course_ID]					AS [CourseId]			,
		[N_Course_Duration]				AS [CourseDuration]	,
		[I_Status]						AS [Status]		,
		0								AS [IsForUpdate]
		FROM [dbo].[T_Course_Delivery_Map]
		WHERE
		[I_Course_Delivery_ID]>@MaxID
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT
		[Id]				,
		[DeliveryPatternId]	,
		[CourseId]			,
		[CourseDuration]	,
		[Status]			,			
		CASE WHEN [Id]>@MaxID THEN 0 ELSE 1 END  AS  [IsForUpdate]
		FROM
		(
				SELECT 
				[I_Course_Delivery_ID]			AS [Id]				,
				[I_Delivery_Pattern_ID]			AS [DeliveryPatternId]	,
				[I_Course_ID]					AS [CourseId]			,
				[N_Course_Duration]				AS [CourseDuration]	,
				[I_Status]						AS [Status]				
				FROM [dbo].[T_Course_Delivery_Map]								
				WHERE CAST(Dt_Upd_On AS DATE)>@VarDate
				UNION
				SELECT 
				[I_Course_Delivery_ID]			AS [Id]				,
				[I_Delivery_Pattern_ID]			AS [DeliveryPatternId]	,
				[I_Course_ID]					AS [CourseId]			,
				[N_Course_Duration]				AS [CourseDuration]	,
				[I_Status]						AS [Status]															
				FROM [dbo].[T_Course_Delivery_Map]
				WHERE
				[I_Course_Delivery_ID]>@MaxID
		)AS A
	END
	ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT 
		[I_Course_Delivery_ID]			AS [Id]				,
		[I_Delivery_Pattern_ID]			AS [DeliveryPatternId]	,
		[I_Course_ID]					AS [CourseId]			,
		[N_Course_Duration]				AS [CourseDuration]	,
		[I_Status]						AS [Status],
		1								AS [IsForUpdate]				
		FROM [dbo].[T_Course_Delivery_Map]								
		WHERE CAST(Dt_Upd_On AS DATE)>@VarDate
	END
	ELSE IF @MaxID=0 AND @VarDate IS  NULL
	BEGIN
		SELECT 
		[I_Course_Delivery_ID]			AS [Id]				,
		[I_Delivery_Pattern_ID]			AS [DeliveryPatternId]	,
		[I_Course_ID]					AS [CourseId]			,
		[N_Course_Duration]				AS [CourseDuration]	,
		[I_Status]						AS [Status]		,
		0								AS [IsForUpdate]
		FROM [dbo].[T_Course_Delivery_Map]
	END
END
