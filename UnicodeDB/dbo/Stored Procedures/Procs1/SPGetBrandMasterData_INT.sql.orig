-- =============================================

-- =============================================
CREATE  PROCEDURE [dbo].[SPGetBrandMasterData_INT]
(
	@UpdateON			Varchar(20) =NULL,
	@MaxID				INT			=NULL
)
AS
BEGIN
	DECLARE @VarDate	DATE;
	IF @UpdateON IS NOT NULL
	BEGIN
		SET @VarDate=CAST(@UpdateON AS DATE)
	END
	ELSE
	BEGIN
		SET @VarDate=NULL
	END
		IF @MaxID<>0 AND @VarDate IS NULL
		BEGIN
			SELECT 
			I_Brand_ID		AS Id,
			S_Brand_Code	AS BrandCode,
			S_Brand_Name	AS BrandName,			
			I_Status		AS [Status],
			0				AS IsForUpdate
			FROM 
			[T_Brand_Master]
			WHERE
			I_Brand_ID>@MaxID
		END
		ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
		BEGIN
			SELECT 
			I_Brand_ID		AS Id,
			S_Brand_Code	AS BrandCode,
			S_Brand_Name	AS BrandName,			
			I_Status		AS [Status],
			1				AS IsForUpdate
			FROM 
			[T_Brand_Master]
			WHERE
			CAST([Dt_Upd_On] AS DATE)>=@VarDate
		END
		ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
		BEGIN
			SELECT
			Id,
			BrandCode,
			BrandName,		
			[Status],
			CASE WHEN Id>@MaxID THEN 0 ELSE 1 END AS IsForUpdate
			FROM
			(
				SELECT 
				I_Brand_ID		AS Id,
				S_Brand_Code	AS BrandCode,
				S_Brand_Name	AS BrandName,			
				I_Status		AS [Status]
				
				FROM 
				[T_Brand_Master]
				WHERE
				CAST([Dt_Upd_On] AS DATE)>=@VarDate
				UNION
				SELECT 
				I_Brand_ID		AS Id,
				S_Brand_Code	AS BrandCode,
				S_Brand_Name	AS BrandName,			
				I_Status		AS [Status]
				
				FROM 
				[T_Brand_Master]
				WHERE
				I_Brand_ID>@MaxID
			) AS A
		END
		ELSE
		BEGIN
			SELECT 
			I_Brand_ID		AS Id,
			S_Brand_Code	AS BrandCode,
			S_Brand_Name	AS BrandName,			
			I_Status		AS [Status],
			0				AS IsForUpdate
			FROM 
			[T_Brand_Master]
		END
		


END
