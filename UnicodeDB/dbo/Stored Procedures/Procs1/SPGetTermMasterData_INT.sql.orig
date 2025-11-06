-- =============================================

-- =============================================
CREATE  PROCEDURE [dbo].[SPGetTermMasterData_INT]
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
		I_Term_ID				AS Id,
		I_Brand_ID				AS BrandId,
		S_Term_Code				AS TermCode,
		S_Term_Name				AS TermName,
		I_Total_Session_Count	AS TotalSessionCount,
		[I_Status]				AS [Status],
		0						AS [IsForUpdate]	
		FROM
		[dbo].[T_Term_Master]				
		WHERE I_Term_ID>@MaxID
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT 
		Id,
		BrandId,
		TermCode,
		TermName,
		TotalSessionCount,
		[Status],
		CASE WHEN Id>@MaxID THEN 0 ELSE 1 END AS IsForUpdate
		FROM
		(
			SELECT 
			I_Term_ID				AS Id,
			I_Brand_ID				AS BrandId,
			S_Term_Code				AS TermCode,
			S_Term_Name				AS TermName,
			I_Total_Session_Count	AS TotalSessionCount,
			[I_Status]				AS [Status]
			--1						AS	[IsForUpdate]	
			FROM
			[dbo].[T_Term_Master]	
			WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
			UNION
			SELECT 
			I_Term_ID				AS Id,
			I_Brand_ID				AS BrandId,
			S_Term_Code				AS TermCode,
			S_Term_Name				AS TermName,
			I_Total_Session_Count	AS TotalSessionCount,
			[I_Status]				AS [Status]
			--0						AS [IsForUpdate]	
			FROM
			[dbo].[T_Term_Master]				
			WHERE I_Term_ID>@MaxID
		)AS A
	END
	ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT 
		I_Term_ID				AS Id,
		I_Brand_ID				AS BrandId,
		S_Term_Code				AS TermCode,
		S_Term_Name				AS TermName,
		I_Total_Session_Count	AS TotalSessionCount,
		[I_Status]				AS [Status],
		1						AS	[IsForUpdate]	
		FROM
		[dbo].[T_Term_Master]	
		WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
	END
	ELSE IF @MaxID=0 AND @VarDate IS  NULL
	BEGIN
		SELECT 
		I_Term_ID				AS Id,
		I_Brand_ID				AS BrandId,
		S_Term_Code				AS TermCode,
		S_Term_Name				AS TermName,
		I_Total_Session_Count	AS TotalSessionCount,
		[I_Status]				AS [Status],
		0						AS [IsForUpdate]	
		FROM
		[dbo].[T_Term_Master]	
	END
END
