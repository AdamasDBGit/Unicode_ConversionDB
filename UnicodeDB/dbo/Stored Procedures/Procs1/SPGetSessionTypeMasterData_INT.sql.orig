-- =============================================

-- =============================================
CREATE  PROCEDURE [dbo].[SPGetSessionTypeMasterData_INT]
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
		I_Session_Type_ID		AS Id,
		S_Session_Type_Name		AS SessionTypeName,
		I_Status				AS [Status],
		0						AS [IsForUpdate]
		FROM [dbo].[T_Session_Type_Master]
		WHERE
		I_Session_Type_ID>@MaxID
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN
	SELECT DISTINCT
	Id,
	SessionTypeName,
	[Status],
	CASE WHEN Id>@MaxID THEN 0 ELSE 1 END AS [IsForUpdate]
	FROM
	(

		SELECT 
		I_Session_Type_ID		AS Id,
		S_Session_Type_Name		AS SessionTypeName,
		I_Status				AS [Status]
		--1						AS [IsForUpdate]
		FROM [dbo].[T_Session_Type_Master]		
		WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
		UNION
		SELECT 
		I_Session_Type_ID		AS Id,
		S_Session_Type_Name		AS SessionTypeName,
		I_Status				AS [Status]
		--0						AS [IsForUpdate]
		FROM [dbo].[T_Session_Type_Master]
		WHERE
		I_Session_Type_ID>@MaxID
	) AS A


	END
	ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT 
		I_Session_Type_ID		AS Id,
		S_Session_Type_Name		AS SessionTypeName,
		I_Status				AS [Status],
		1						AS [IsForUpdate]
		FROM [dbo].[T_Session_Type_Master]		
		WHERE CAST(Dt_Upd_On AS DATE)>@VarDate
	END
	ELSE IF @MaxID=0 AND @VarDate IS  NULL
	BEGIN
		SELECT 
		I_Session_Type_ID		AS Id,
		S_Session_Type_Name		AS SessionTypeName,
		I_Status				AS [Status],
		0						AS [IsForUpdate]
		FROM [dbo].[T_Session_Type_Master]		
	END
END
