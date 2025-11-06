-- SPGetSessionModuleMapData_INT '2018/08/17',279430
CREATE  PROCEDURE [dbo].[SPGetSessionModuleMapData_INT]
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
		[I_Session_Module_ID]		AS [Id]				,
		[I_Module_ID]				AS [ModuleId]		,
		[I_Session_ID]				AS [SessionId]		,	
		[I_Sequence]				AS [Sequence]		,	
		--[Dt_Valid_From]				AS [ValidFrom]		,	
		--[Dt_Valid_To]				AS [ValidTo]		,	
		[I_Status]					AS [Status]			,
		0							AS [IsForUpdate]	
		FROM 
		[T_Session_Module_Map]	
		WHERE [I_Session_Module_ID]>@MaxID
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN
	 
		SELECT DISTINCT
		[Id]				,
		[ModuleId]		,
		[SessionId]		,	
		[Sequence]		,	
		--[ValidFrom]		,	
		--[ValidTo]		,	
		[Status]		,
		CASE WHEN [Id]>@MaxID THEN 0 ELSE 1 END AS [IsForUpdate]
		FROM
		(
			SELECT
			[I_Session_Module_ID]		AS [Id]				,
			[I_Module_ID]				AS [ModuleId]		,
			[I_Session_ID]				AS [SessionId]		,	
			[I_Sequence]				AS [Sequence]		,	
			[I_Status]					AS [Status]			
			--0							AS [IsForUpdate]	
			FROM 
			[T_Session_Module_Map]																								
			WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
			UNION
			SELECT
			[I_Session_Module_ID]		AS [Id]				,
			[I_Module_ID]				AS [ModuleId]		,
			[I_Session_ID]				AS [SessionId]		,	
			[I_Sequence]				AS [Sequence]		,	
		 	[I_Status]					AS [Status]			
			--0							AS [IsForUpdate]	
			FROM 
			[T_Session_Module_Map]																								
			--WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
			WHERE [I_Session_Module_ID]>@MaxID
		)AS A
	END
	ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT
		[I_Session_Module_ID]		AS [Id]				,
		[I_Module_ID]				AS [ModuleId]		,
		[I_Session_ID]				AS [SessionId]		,	
		[I_Sequence]				AS [Sequence]		,	
		--[Dt_Valid_From]				AS [ValidFrom]		,	
		--[Dt_Valid_To]				AS [ValidTo]		,	
		[I_Status]					AS [Status]			,
		0							AS [IsForUpdate]	
		FROM 
		[T_Session_Module_Map]																								
		WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
	END
	ELSE IF @MaxID=0 AND @VarDate IS  NULL
	BEGIN
	 
		SELECT
		[I_Session_Module_ID]		AS [Id]				,
		[I_Module_ID]				AS [ModuleId]		,
		[I_Session_ID]				AS [SessionId]		,	
		[I_Sequence]				AS [Sequence]		,	
		--[Dt_Valid_From]				AS [ValidFrom]		,	
		--[Dt_Valid_To]				AS [ValidTo]		,	
		[I_Status]					AS [Status]			,
		0							AS [IsForUpdate]	
		FROM 
		[T_Session_Module_Map]	
		WHERE I_Status=1				
	END
END
