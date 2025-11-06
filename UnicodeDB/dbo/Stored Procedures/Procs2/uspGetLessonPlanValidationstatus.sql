CREATE PROCEDURE [dbo].[uspGetLessonPlanValidationstatus]
	-- Add the parameters for the stored procedure here
	@MonthNo int,
	@academicsessionID int,
	@brandID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @StartDate DATE = '2023-04-01'; -- Start date of the date range
	DECLARE @EndDate DATE = '2024-03-31'; -- End date of the date range

	select @StartDate=Dt_Session_Start_Date,@EndDate=Dt_Session_End_Date
	FROM T_School_Academic_Session_Master WHERE I_Current_Session = 1 and I_School_Session_ID=@academicsessionID


	-- Calculate the year based on the given month number
	DECLARE @Year INT;

	IF @MonthNo >= MONTH(@StartDate) AND @MonthNo <= 12
		SET @Year = YEAR(@StartDate);
	ELSE
		SET @Year = YEAR(@EndDate);

	-- Output the calculated year
	--SELECT @Year AS YearFromMonthNumber;


	SELECT 
	CASE WHEN
	MonthFreezeStatus IS NULL THEN 'false' ELSE MonthFreezeStatus.MonthFreezeStatus END as MonthFreezeStatus,
	CASE WHEN
	IsMultipleTiersAllowed IS NULL THEN 'true' ELSE IsMultipleTiersAllowed.IsMultipleTiersAllowed END as IsMultipleTiersAllowed

FROM 
    (SELECT DISTINCT
         SPH.N_help,
         CASE WHEN 
			ISNULL(SPH.N_help,'NA') = 'GRACE_PREVIOUS_MONTHS_NUM_TO_BE_FREZZE' and 
			DATEADD(MONTH, (-1)*SPCH.N_Value, GETDATE()) < DATEFROMPARTS(@Year, @MonthNo, 1)
			THEN 'false'
			ELSE
			'true' END as MonthFreezeStatus,
         SPH.I_Pattern_HeaderID
     FROM 
         T_ERP_Saas_Pattern_Header AS SPH
     INNER JOIN 
         T_ERP_Saas_Pattern_Child_Header SPCH ON SPH.I_Pattern_HeaderID = SPCH.I_Pattern_HeaderID
     WHERE 
         S_Property_Name LIKE '%LessonPlan%' 
         AND S_Screen LIKE '%Lesson Plan%'
         AND SPH.Is_Active = 1 
         AND SPCH.Is_Active = 1 
         AND SPH.I_Brand_ID = @brandID
         AND ISNULL(SPH.N_help, 'NA') = 'GRACE_PREVIOUS_MONTHS_NUM_TO_BE_FREZZE'
         ) AS MonthFreezeStatus
 CROSS JOIN 
    (SELECT DISTINCT
         SPH.N_help,
         CASE WHEN 
	ISNULL(SPH.N_help,'NA') = 'IS_MULTIPLE_TIERS_ALLOWED' and 
	SPCH.N_Value like '%Yes%'
	THEN 'true'
	ELSE
	'false' END as IsMultipleTiersAllowed,
         SPH.I_Pattern_HeaderID
     FROM 
         T_ERP_Saas_Pattern_Header AS SPH
     INNER JOIN 
         T_ERP_Saas_Pattern_Child_Header SPCH ON SPH.I_Pattern_HeaderID = SPCH.I_Pattern_HeaderID
     WHERE 
         S_Property_Name LIKE '%LessonPlan%' 
         AND S_Screen LIKE '%Lesson Plan%'
         AND SPH.Is_Active = 1 
         AND SPCH.Is_Active = 1 
         AND SPH.I_Brand_ID = @brandID
         AND SPH.N_help = 'IS_MULTIPLE_TIERS_ALLOWED') AS IsMultipleTiersAllowed 



END

