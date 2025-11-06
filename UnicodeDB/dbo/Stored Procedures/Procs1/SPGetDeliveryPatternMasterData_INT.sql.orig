-- =============================================

-- =============================================
CREATE  PROCEDURE [dbo].[SPGetDeliveryPatternMasterData_INT]
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
		[I_Delivery_Pattern_ID] AS	[Id]			,
		[S_Pattern_Name]		AS	[PatternName]	,
		[I_No_Of_Session]		AS	[NoOfSession]	,
		[N_Session_Day_Gap]		AS	[SessionDayGap]	,
		[S_DaysOfWeek]			AS	[DaysOfWeek]	,
		I_Status				AS	[Status]		,
		0						AS	[IsForUpdate]	
		FROM
		[dbo].[T_Delivery_Pattern_Master]
		WHERE [I_Delivery_Pattern_ID]>@MaxID
	END
	ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT 
		[I_Delivery_Pattern_ID] AS	[Id]			,
		[S_Pattern_Name]		AS	[PatternName]	,
		[I_No_Of_Session]		AS	[NoOfSession]	,
		[N_Session_Day_Gap]		AS	[SessionDayGap]	,
		[S_DaysOfWeek]			AS	[DaysOfWeek]	,
		I_Status				AS	[Status]		,
		1						AS	[IsForUpdate]	
		FROM
		[dbo].[T_Delivery_Pattern_Master]	
		WHERE CAST(Dt_Upd_On AS DATE)>@VarDate
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT
		DISTINCT						
		[Id]			,
		[PatternName]	,
		[NoOfSession]	,
		[SessionDayGap]	,
		[DaysOfWeek],		
		[Status],
		CASE WHEN [Id]>@MaxID THEN 1 ELSE 0 END AS [IsForUpdate]
		FROM
		(
			SELECT 
			[I_Delivery_Pattern_ID] AS	[Id]			,
			[S_Pattern_Name]		AS	[PatternName]	,
			[I_No_Of_Session]		AS	[NoOfSession]	,
			[N_Session_Day_Gap]		AS	[SessionDayGap]	,
			[S_DaysOfWeek]			AS	[DaysOfWeek]	,
			I_Status				AS	[Status]		,
			1						AS	[IsForUpdate]	
			FROM
			[dbo].[T_Delivery_Pattern_Master]	
			WHERE CAST(Dt_Upd_On AS DATE)>@VarDate
			UNION
			SELECT 
			[I_Delivery_Pattern_ID] AS	[Id]			,
			[S_Pattern_Name]		AS	[PatternName]	,
			[I_No_Of_Session]		AS	[NoOfSession]	,
			[N_Session_Day_Gap]		AS	[SessionDayGap]	,
			[S_DaysOfWeek]			AS	[DaysOfWeek]	,
			I_Status				AS	[Status]		,
			0						AS	[IsForUpdate]	
			FROM
			[dbo].[T_Delivery_Pattern_Master]
			WHERE [I_Delivery_Pattern_ID]>@MaxID
		)AS A
	END
	ELSE IF @MaxID=0 AND @VarDate IS  NULL
	BEGIN
		SELECT 
			[I_Delivery_Pattern_ID] AS	[Id]			,
			[S_Pattern_Name]		AS	[PatternName]	,
			[I_No_Of_Session]		AS	[NoOfSession]	,
			[N_Session_Day_Gap]		AS	[SessionDayGap]	,
			[S_DaysOfWeek]			AS	[DaysOfWeek]	,
			I_Status				AS	[Status]		,
			0						AS	[IsForUpdate]	
		FROM
			[dbo].[T_Delivery_Pattern_Master]
	END
END
