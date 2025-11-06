CREATE  PROCEDURE [dbo].[SPGetModuleMasterData_INT]
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
		[I_Module_ID]				AS [Id],
		[I_Skill_ID]				AS [SkillId],
		[I_Brand_ID]				AS [BrandId],
		[S_Module_Code]				AS [ModuleCode],
		[S_Module_Name]				AS [ModuleName],
		[I_No_Of_Session]			AS [NoOfSession],
		[I_Status]					AS [Status],
		0							AS [IsForUpdate]	
		FROM
		[dbo].[T_Module_Master]				
		WHERE [I_Module_ID]>@MaxID
	END
	ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT 
		[I_Module_ID]				AS [Id],
		[I_Skill_ID]				AS [SkillId],
		[I_Brand_ID]				AS [BrandId],
		[S_Module_Code]				AS [ModuleCode],
		[S_Module_Name]				AS [ModuleName],
		[I_No_Of_Session]			AS [NoOfSession],
		[I_Status]					AS [Status],
		1							AS [IsForUpdate]	
		FROM
		[dbo].[T_Module_Master]				
		WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN

	SELECT DISTINCT
	[Id],
	[SkillId],
	[BrandId],
	[ModuleCode],
	[ModuleName],
	[NoOfSession],
	[Status],
	CASE WHEN [Id]>@MaxID THEN 0 ELSE 1 END AS IsForUpdate
	FROM
		(
			SELECT 
			[I_Module_ID]				AS [Id],
			[I_Skill_ID]				AS [SkillId],
			[I_Brand_ID]				AS [BrandId],
			[S_Module_Code]				AS [ModuleCode],
			[S_Module_Name]				AS [ModuleName],
			[I_No_Of_Session]			AS [NoOfSession],
			[I_Status]					AS [Status]
			--1							AS [IsForUpdate]	
			FROM
			[dbo].[T_Module_Master]				
			WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
			UNION
			SELECT 
			[I_Module_ID]				AS [Id],
			[I_Skill_ID]				AS [SkillId],
			[I_Brand_ID]				AS [BrandId],
			[S_Module_Code]				AS [ModuleCode],
			[S_Module_Name]				AS [ModuleName],
			[I_No_Of_Session]			AS [NoOfSession],
			[I_Status]					AS [Status]
			--0							AS [IsForUpdate]	
			FROM
			[dbo].[T_Module_Master]				
			WHERE [I_Module_ID]>@MaxID
		)AS A

	END
	ELSE IF @MaxID=0 AND @VarDate IS  NULL
	BEGIN
		SELECT 
		[I_Module_ID]				AS [Id],
		[I_Skill_ID]				AS [SkillId],
		[I_Brand_ID]				AS [BrandId],
		[S_Module_Code]				AS [ModuleCode],
		[S_Module_Name]				AS [ModuleName],
		[I_No_Of_Session]			AS [NoOfSession],
		[I_Status]					AS [Status],
		0							AS [IsForUpdate]	
		FROM
		[dbo].[T_Module_Master]	
	END
END
