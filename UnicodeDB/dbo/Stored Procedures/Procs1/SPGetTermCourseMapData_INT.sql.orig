-- =============================================

-- =============================================
CREATE  PROCEDURE [dbo].[SPGetTermCourseMapData_INT]
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
		[I_Term_Course_ID]				AS [Id]	,
		[I_Course_ID]					AS [CourseId]			,
		[I_Term_ID]						AS [TermId]		,
		[I_Sequence]					AS [Sequence]		,
		Convert(varchar,[Dt_Valid_From])					AS [ValidFrom]		,
		Convert(varchar,[Dt_Valid_To])					AS [ValidTo]		,
		[I_Status]						AS [Status]		,
		0								AS [IsForUpdate]
		FROM [dbo].[T_Term_Course_Map]
		WHERE
		[I_Term_Course_ID]>@MaxID
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT
		[Id]				,
		[CourseId]		,
		[TermId]			,
		[Sequence]		,
		[ValidFrom]		,
		[ValidTo]		,
		[Status]			,
		
		CASE WHEN [Id]>@MaxID THEN 0 ELSE 1 END  AS  [IsForUpdate]
		FROM
		(
			SELECT 
			[I_Term_Course_ID]				AS [Id]				,
			[I_Course_ID]					AS [CourseId]		,
			[I_Term_ID]						AS [TermId]			,
			[I_Sequence]					AS [Sequence]		,
			Convert(varchar,[Dt_Valid_From])					AS [ValidFrom]		,
		Convert(varchar,[Dt_Valid_To])					AS [ValidTo]		,
			[I_Status]						AS [Status]			
				
			
			FROM [dbo].[T_Term_Course_Map]
			WHERE CAST(Dt_Upd_On AS DATE)>@VarDate
			UNION
			SELECT 
			[I_Term_Course_ID]				AS [Id]				,
			[I_Course_ID]					AS [CourseId]		,
			[I_Term_ID]						AS [TermId]			,
			[I_Sequence]					AS [Sequence]		,
			Convert(varchar,[Dt_Valid_From])					AS [ValidFrom]		,
		Convert(varchar,[Dt_Valid_To])					AS [ValidTo]		,
			[I_Status]						AS [Status]			
			
		
			FROM [dbo].[T_Term_Course_Map]
			WHERE
			[I_Term_Course_ID]>@MaxID
		)AS A
	END
	ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT 
		[I_Term_Course_ID]				AS [Id]	,
		[I_Course_ID]					AS [CourseId]			,
		[I_Term_ID]						AS [TermId]		,
		[I_Sequence]					AS [Sequence]		,
		Convert(varchar,[Dt_Valid_From])					AS [ValidFrom]		,
		Convert(varchar,[Dt_Valid_To])					AS [ValidTo]		,
		[I_Status]						AS [Status]		,
		I_Status				AS [Status],
		1						AS [IsForUpdate]
		FROM [dbo].[T_Term_Course_Map]
		WHERE CAST(Dt_Upd_On AS DATE)>@VarDate
	END
	ELSE IF @MaxID=0 AND @VarDate IS  NULL
	BEGIN
		SELECT 
		[I_Term_Course_ID]				AS [Id]	,
		[I_Course_ID]					AS [CourseId]			,
		[I_Term_ID]						AS [TermId]		,
		[I_Sequence]					AS [Sequence]		,
	Convert(varchar,[Dt_Valid_From])					AS [ValidFrom]		,
		Convert(varchar,[Dt_Valid_To])					AS [ValidTo]		,
		[I_Status]						AS [Status]		,
		0								AS [IsForUpdate]
		FROM [dbo].[T_Term_Course_Map]
	END
END
