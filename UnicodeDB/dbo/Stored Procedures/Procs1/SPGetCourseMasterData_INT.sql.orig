-- =============================================

-- =============================================
CREATE  PROCEDURE [dbo].[SPGetCourseMasterData_INT]
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
		I_Course_ID			AS Id,
		I_CourseFamily_ID	AS [CourseFamilyId],
		I_Brand_ID			AS [BrandId],		
		S_Course_Code       AS [CourseCode],
		S_Course_Name       AS [CourseName],
		S_Course_Desc       AS [CourseDesc],
		I_Status			AS [Status],
		0					AS	[IsForUpdate]	
		FROM [dbo].[T_Course_Master]
		WHERE I_Course_ID>@MaxID
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT DISTINCT
		Id,
		[CourseFamilyId],
		[BrandId],	
		[CourseCode],
		[CourseName],
		[CourseDesc],
		[Status],
		CASE WHEN Id>@MaxID THEN 0 ELSE 1 END AS  [IsForUpdate]	
		FROM
		(
			SELECT 
			I_Course_ID			AS Id,
			I_CourseFamily_ID	AS [CourseFamilyId],
			I_Brand_ID			AS [BrandId],	
			S_Course_Code       AS [CourseCode],
			S_Course_Name       AS [CourseName],
			S_Course_Desc       AS [CourseDesc],
			I_Status			AS [Status]
			--1					AS [IsForUpdate]	
			FROM [dbo].[T_Course_Master]
			WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
			UNION
			SELECT 
			I_Course_ID			AS Id,
			I_CourseFamily_ID	AS [CourseFamilyId],
			I_Brand_ID			AS [BrandId],		
			S_Course_Code       AS [CourseCode],
			S_Course_Name       AS [CourseName],
			S_Course_Desc       AS [CourseDesc],
			I_Status			AS [Status]
			--0					AS	[IsForUpdate]	
			FROM [dbo].[T_Course_Master]
			WHERE I_Course_ID>@MaxID
		)AS A


	END
	ELSE IF @MaxID=0 AND @VarDate IS NOT NULL
	BEGIN
		SELECT 
		I_Course_ID			AS Id,
		I_CourseFamily_ID	AS [CourseFamilyId],
		I_Brand_ID			AS [BrandId],	
		S_Course_Code       AS [CourseCode],
		S_Course_Name       AS [CourseName],
		S_Course_Desc       AS [CourseDesc],
		I_Status			AS [Status],
		1					AS [IsForUpdate]	
		FROM [dbo].[T_Course_Master]
		WHERE CAST(Dt_Upd_On AS DATE)>=@VarDate
	END
	ELSE IF @MaxID=0 AND @VarDate IS  NULL
	BEGIN
		SELECT 
		I_Course_ID			AS Id,
		I_CourseFamily_ID	AS [CourseFamilyId],
		I_Brand_ID			AS [BrandId],	
		S_Course_Code       AS [CourseCode],
		S_Course_Name       AS [CourseName],
		S_Course_Desc       AS [CourseDesc],
		I_Status			AS [Status],
		0					AS [IsForUpdate]	
		FROM [dbo].[T_Course_Master]
	END
END
