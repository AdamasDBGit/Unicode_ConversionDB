-- =============================================

-- =============================================
CREATE  PROCEDURE [dbo].[SPGetCenterBatchDetailsData_INT]
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
		I_Batch_ID				AS BatchId,
		I_Centre_Id				AS CentreId,
		I_Min_Strength			AS MinStrength,
		Max_Strength			AS MaxStrength,
		I_Status				AS [Status],
		0						AS [IsForUpdate]	
		FROM
		[dbo].[T_Center_Batch_Details]
		WHERE I_Batch_ID>@MaxID
	END
	ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT 
		I_Batch_ID				AS BatchId,
		I_Centre_Id				AS CentreId,
		I_Min_Strength			AS MinStrength,
		Max_Strength			AS MaxStrength,
		I_Status				AS [Status],
		1						AS [IsForUpdate]	
		FROM
		[dbo].[T_Center_Batch_Details]		
		WHERE CAST(Dt_Upd_On AS DATE)>@VarDate
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT
		DISTINCT
		BatchId,
		CentreId,
		MinStrength,
		MaxStrength,
		[Status],
		CASE WHEN BatchId>@MaxID THEN 1 ELSE 0 END AS [IsForUpdate]
		FROM
		(
			SELECT 
			I_Batch_ID				AS BatchId,
			I_Centre_Id				AS CentreId,
			I_Min_Strength			AS MinStrength,
			Max_Strength			AS MaxStrength,
			I_Status				AS [Status]
				
			FROM
			[dbo].[T_Center_Batch_Details]		
			WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
			UNION
			SELECT 
			I_Batch_ID				AS BatchId,
			I_Centre_Id				AS CentreId,
			I_Min_Strength			AS MinStrength,
			Max_Strength			AS MaxStrength,
			I_Status				AS [Status]
			
			FROM
			[dbo].[T_Center_Batch_Details]
			WHERE I_Batch_ID>@MaxID
		)AS A
	END
	ELSE IF @MaxID=0 AND @VarDate IS  NULL
	BEGIN
		SELECT 
		I_Batch_ID				AS BatchId,
		I_Centre_Id				AS CentreId,
		I_Min_Strength			AS MinStrength,
		Max_Strength			AS MaxStrength,
		I_Status				AS [Status],
		0						AS [IsForUpdate]	
		FROM
		[dbo].[T_Center_Batch_Details]
	END
END
