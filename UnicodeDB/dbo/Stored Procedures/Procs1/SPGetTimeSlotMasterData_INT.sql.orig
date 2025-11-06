-- =============================================

-- =============================================
CREATE  PROCEDURE [dbo].[SPGetTimeSlotMasterData_INT]
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
		[I_TimeSlot_ID]		AS Id,
		[I_Brand_ID]		AS BrandId,
		[I_Center_ID]		AS CenterId,
		[Dt_Start_Time]		AS StartTime,
		[Dt_End_Time]		AS EndTime,
		[I_Status]			AS [Status],
		0					AS [IsForUpdate]
		FROM 
		[T_Center_Timeslot_Master]				
		WHERE
		[I_TimeSlot_ID]>@MaxID
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT
		Id,
		BrandId,
		CenterId,
		StartTime,
		EndTime,
		[Status],
		CASE WHEN [Id]>@MaxID THEN 0 ELSE 1 END  AS  [IsForUpdate]
		FROM
		(
			SELECT 
			[I_TimeSlot_ID]		AS Id,
			[I_Brand_ID]		AS BrandId,
			[I_Center_ID]		AS CenterId,
			[Dt_Start_Time]		AS StartTime,
			[Dt_End_Time]		AS EndTime,
			[I_Status]			AS [Status]		
			FROM 
			[T_Center_Timeslot_Master]		
			WHERE CAST(Dt_Updt_On AS DATE)>@VarDate
			UNION
			SELECT 
			[I_TimeSlot_ID]		AS Id,
			[I_Brand_ID]		AS BrandId,
			[I_Center_ID]		AS CenterId,
			[Dt_Start_Time]		AS StartTime,
			[Dt_End_Time]		AS EndTime,
			[I_Status]			AS [Status]		
			FROM 
			[T_Center_Timeslot_Master]		
			WHERE
			[I_TimeSlot_ID]>@MaxID
		)AS A
	END
	ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
	BEGIN
			SELECT 
			[I_TimeSlot_ID]		AS Id,
			[I_Brand_ID]		AS BrandId,
			[I_Center_ID]		AS CenterId,
			[Dt_Start_Time]		AS StartTime,
			[Dt_End_Time]		AS EndTime,
			[I_Status]			AS [Status],
			1					AS [IsForUpdate]		
			FROM 
			[T_Center_Timeslot_Master]		
			WHERE CAST(Dt_Updt_On AS DATE)>@VarDate
	END
	ELSE IF @MaxID=0 AND @VarDate IS  NULL
	BEGIN
		SELECT 
			[I_TimeSlot_ID]		AS Id,
			[I_Brand_ID]		AS BrandId,
			[I_Center_ID]		AS CenterId,
			[Dt_Start_Time]		AS StartTime,
			[Dt_End_Time]		AS EndTime,
			[I_Status]			AS [Status],
			0					AS [IsForUpdate]		
			FROM 
			[T_Center_Timeslot_Master]		
	END
END
