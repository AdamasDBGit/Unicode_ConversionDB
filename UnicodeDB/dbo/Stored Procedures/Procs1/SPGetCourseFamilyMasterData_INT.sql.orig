--SPGetCourseFamilyMasterData_INT '2018/08/17',52
CREATE  PROCEDURE [dbo].[SPGetCourseFamilyMasterData_INT]
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
		[I_CourseFamily_ID]		AS	Id,
		[S_CourseFamily_Name]	AS	[CourseFamilyName]	,			
		[I_Brand_ID]			AS 	[BrandId],
		[I_Status]				AS	[Status]	,
		0						AS	[IsForUpdate]	
		FROM [T_CourseFamily_Master] 
		WHERE [I_CourseFamily_ID]>@MaxID
	END
	ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT 
		[I_CourseFamily_ID]		AS	Id,
		[S_CourseFamily_Name]	AS	[CourseFamilyName]	,			
		[I_Brand_ID]			AS 	[BrandId],
		[I_Status]				AS	[Status]	,
		1						AS	[IsForUpdate]		
		FROM [T_CourseFamily_Master] 
		WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN

	   
		SELECT DISTINCT
		Id,
		[CourseFamilyName]	,	
		[BrandId],
		[Status]	,
		--CASE WHEN Id>@MaxID THEN 1 ELSE 0 END AS [IsForUpdate]	
		CASE WHEN Id>@MaxID THEN 0 ELSE 1 END AS [IsForUpdate]	
		FROM	
		(
			SELECT 
			[I_CourseFamily_ID]		AS	Id,
			[S_CourseFamily_Name]	AS	[CourseFamilyName]	,			
			[I_Brand_ID]			AS 	[BrandId],
			[I_Status]				AS	[Status]	
			--1						AS	[IsForUpdate]		
			FROM [T_CourseFamily_Master] 
			WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
			UNION
			SELECT 		
			[I_CourseFamily_ID]		AS	Id,
			[S_CourseFamily_Name]	AS	[CourseFamilyName]	,			
			[I_Brand_ID]			AS 	[BrandId],
			[I_Status]				AS	[Status]	
			--0						AS	[IsForUpdate]	
			FROM [T_CourseFamily_Master] 
			WHERE [I_CourseFamily_ID]>@MaxID
		)AS A


	END
	ELSE IF @MaxID=0 AND @VarDate IS  NULL
	BEGIN
		SELECT 		
		[I_CourseFamily_ID]		AS	Id,
		[S_CourseFamily_Name]	AS	[CourseFamilyName]	,			
		[I_Brand_ID]			AS 	[BrandId],
		[I_Status]				AS	[Status]	,
		0						AS	[IsForUpdate]		
		FROM [T_CourseFamily_Master]
	END
END
