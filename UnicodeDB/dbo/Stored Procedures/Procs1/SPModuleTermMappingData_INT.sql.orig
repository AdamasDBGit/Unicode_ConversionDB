-- =============================================

-- =============================================
--SPModuleTermMappingData null,0
CREATE  PROCEDURE [dbo].[SPModuleTermMappingData_INT]
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
		[I_Module_Term_ID]	AS [Id]	,
		[I_Term_ID]			AS [TermId]	,
		[I_Module_ID]		AS [ModuleId]	,
		[I_Sequence]		AS [Sequence]	,
		--[Dt_Valid_From]		AS [ValidFrom],
		--[Dt_Valid_To]		AS [ValidTo]	,
		I_Status			AS [Status],												
		0					AS [IsForUpdate]	
		FROM [dbo].[T_Module_Term_Map]
		WHERE [I_Module_Term_ID]>@MaxID
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN

	SELECT 
	[Id]	,
	[TermId]	,
	[ModuleId]	,
	[Sequence]	,
	--[ValidFrom],
	--[ValidTo]	,
	[Status],
	CASE WHEN [Id]>@MaxID THEN 0 ELSE 1 END [IsForUpdate]
	FROM
	(
		SELECT 
		[I_Module_Term_ID]	AS [Id]	,
		[I_Term_ID]			AS [TermId]	,
		[I_Module_ID]		AS [ModuleId]	,
		[I_Sequence]		AS [Sequence]	,
		--[Dt_Valid_From]		AS [ValidFrom],
		--[Dt_Valid_To]		AS [ValidTo]	,
		I_Status			AS [Status]
			
		FROM [dbo].[T_Module_Term_Map]
		WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
		UNION
		SELECT 
		[I_Module_Term_ID]	AS [Id]	,
		[I_Term_ID]			AS [TermId]	,
		[I_Module_ID]		AS [ModuleId]	,
		[I_Sequence]		AS [Sequence]	,
		--[Dt_Valid_From]		AS [ValidFrom],
		--[Dt_Valid_To]		AS [ValidTo]	,
		I_Status			AS [Status]												
		
		FROM [dbo].[T_Module_Term_Map]
		WHERE [I_Module_Term_ID]>@MaxID
	)AS A
	END
	ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT 
		[I_Module_Term_ID]	AS [Id]	,
		[I_Term_ID]			AS [TermId]	,
		[I_Module_ID]		AS [ModuleId]	,
		[I_Sequence]		AS [Sequence]	,
		--[Dt_Valid_From]		AS [ValidFrom],
		--[Dt_Valid_To]		AS [ValidTo]	,
		I_Status			AS [Status],
		1					AS [IsForUpdate]	
		FROM [dbo].[T_Module_Term_Map]
		WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
	END
	ELSE IF @MaxID=0 AND @VarDate IS  NULL
	BEGIN
		SELECT 
		[I_Module_Term_ID]	AS [Id]	,
		[I_Term_ID]			AS [TermId]	,
		[I_Module_ID]		AS [ModuleId]	,
		[I_Sequence]		AS [Sequence]	,
		--[Dt_Valid_From]		AS [ValidFrom],
		--[Dt_Valid_To]		AS [ValidTo]	,
		I_Status			AS [Status],
		0					AS [IsForUpdate]	
		FROM [dbo].[T_Module_Term_Map]
	END
END
