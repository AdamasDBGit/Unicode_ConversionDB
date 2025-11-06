-- =============================================

-- =============================================
CREATE  PROCEDURE [dbo].[SPGetSessionMasterData_INT]
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
		[I_Session_ID]			AS Id,
		[I_Session_Type_ID]		AS SessionTypeId,
		[I_Brand_ID]			AS BrandId,
		[S_Session_Code]		AS SessionCode,
		[S_Session_Name]		AS SessionName,
		[N_Session_Duration]	AS SessionDuration,
		[S_Session_Topic]		AS SessionTopic,
		[I_Status]				AS [Status],
		[I_Skill_ID]			AS SkillId,
		0						AS [IsForUpdate]	
		FROM
		[dbo].[T_Session_Master]		
		WHERE [I_Session_ID]>@MaxID
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN

	SELECT DISTINCT
	Id,
	SessionTypeId,
	BrandId,
	SessionCode,
	SessionName,
	SessionDuration,
	SessionTopic,
	[Status],
	SkillId,
	CASE WHEN Id>@MaxID THEN 0 ELSE 1 END  AS IsForUpdate
	FROM
		(
			SELECT 
			[I_Session_ID]			AS Id,
			[I_Session_Type_ID]		AS SessionTypeId,
			[I_Brand_ID]			AS BrandId,
			[S_Session_Code]		AS SessionCode,
			[S_Session_Name]		AS SessionName,
			[N_Session_Duration]	AS SessionDuration,
			[S_Session_Topic]		AS SessionTopic,
			[I_Status]				AS [Status],
			[I_Skill_ID]			AS SkillId
			--1						AS [IsForUpdate]	
			FROM
			[dbo].[T_Session_Master]	
			WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
			UNION
			SELECT 
			[I_Session_ID]			AS Id,
			[I_Session_Type_ID]		AS SessionTypeId,
			[I_Brand_ID]			AS BrandId,
			[S_Session_Code]		AS SessionCode,
			[S_Session_Name]		AS SessionName,
			[N_Session_Duration]	AS SessionDuration,
			[S_Session_Topic]		AS SessionTopic,
			[I_Status]				AS [Status],
			[I_Skill_ID]			AS SkillId
			--1						AS [IsForUpdate]	
			FROM
			[dbo].[T_Session_Master]	
			WHERE [I_Session_ID]>@MaxID
		)AS A
	END
	ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT 
		[I_Session_ID]			AS Id,
		[I_Session_Type_ID]		AS SessionTypeId,
		[I_Brand_ID]			AS BrandId,
		[S_Session_Code]		AS SessionCode,
		[S_Session_Name]		AS SessionName,
		[N_Session_Duration]	AS SessionDuration,
		[S_Session_Topic]		AS SessionTopic,
		[I_Status]				AS [Status],
		[I_Skill_ID]			AS SkillId,
		1						AS [IsForUpdate]	
		FROM
		[dbo].[T_Session_Master]	
		WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
	END
	ELSE IF @MaxID=0 AND @VarDate IS  NULL
	BEGIN
		SELECT 
		[I_Session_ID]			AS Id,
		[I_Session_Type_ID]		AS SessionTypeId,
		[I_Brand_ID]			AS BrandId,
		[S_Session_Code]		AS SessionCode,
		[S_Session_Name]		AS SessionName,
		[N_Session_Duration]	AS SessionDuration,
		[S_Session_Topic]		AS SessionTopic,
		[I_Status]				AS [Status],
		[I_Skill_ID]			AS SkillId,
		0						AS [IsForUpdate]	
		FROM
		[dbo].[T_Session_Master]	
	END
END
