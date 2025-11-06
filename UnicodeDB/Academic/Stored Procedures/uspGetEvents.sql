-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <29th aug 2023>
-- Description:	<to get the events>

-- exec [Academic].[uspGetEvents] 107, 2, 5, 2
-- =============================================
CREATE PROCEDURE [Academic].[uspGetEvents]
	-- Add the parameters for the stored procedure here
	@iBrandid INT = null,
	@SchoolGroupID INT = null,
	@ClassID INT = null,
	@flag INT = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	 IF @flag = 1 --advance searched data
    BEGIN
        -- First Select
        SELECT DISTINCT
            TE.I_Event_ID AS EventID,
            TE.I_Event_Category_ID AS EventCategoryID,
            TECA.S_Event_Category AS EventCatagoryName,
            TE.S_Event_Name AS EventName,
            TE.I_Brand_ID AS BrandID,
            CONVERT(date, TE.Dt_StartDate) AS StartDate,
            CONVERT(date, TE.Dt_EndDate) AS EndDate,
            NULLIF(CONVERT(time, TE.Dt_StartTime), '00:00:00') AS StartTime,
            NULLIF(CONVERT(time, TE.Dt_EndTime), '00:00:00') AS EndTime,
            TEC.I_School_Group_ID AS SchoolGroupID,
            TEC.I_Class_ID AS ClassID
        FROM
            [dbo].[T_Event] AS TE
            INNER JOIN T_Event_Class AS TEC ON TE.I_Event_ID = TEC.I_Event_ID
            INNER JOIN T_Event_Category AS TECA ON TE.I_Event_Category_ID = TECA.I_Event_Category_ID
        WHERE
            (TE.I_Brand_ID = @iBrandid OR @iBrandid IS NULL)
			AND TE.I_Status = 1 --AND TEC.Is_Active = 1
            AND (TEC.I_School_Group_ID = @SchoolGroupID OR @SchoolGroupID IS NULL OR @SchoolGroupID = 0)
            AND (TEC.I_Class_ID = @ClassID OR @ClassID IS NULL OR @ClassID = 0)
            --AND (TE.Dt_StartDate = '2024-01-04');
    END
    ELSE IF @flag = 2 --generic calender event data
    BEGIN
        -- Second Select (commented out)
       
        SELECT DISTINCT
            TE.I_Event_ID AS EventID,
            TE.I_Event_Category_ID AS EventCategoryID,
            TECA.S_Event_Category AS EventCatagoryName,
            TE.S_Event_Name AS EventName,
            TE.I_Brand_ID AS BrandID,
            CONVERT(date, TE.Dt_StartDate) AS StartDate,
            CONVERT(date, TE.Dt_EndDate) AS EndDate,
            NULLIF(CONVERT(time, TE.Dt_StartTime), '00:00:00') AS StartTime,
            NULLIF(CONVERT(time, TE.Dt_EndTime), '00:00:00') AS EndTime
            --TEC.I_School_Group_ID AS SchoolGroupID,
            --TEC.I_Class_ID AS ClassID
        FROM
            [dbo].[T_Event] AS TE
            INNER JOIN T_Event_Class AS TEC ON TE.I_Event_ID = TEC.I_Event_ID
            INNER JOIN T_Event_Category AS TECA ON TE.I_Event_Category_ID = TECA.I_Event_Category_ID
        WHERE
            (TE.I_Brand_ID = @iBrandid OR @iBrandid IS NULL)
			AND TE.I_Status = 1 --AND TEC.Is_Active = 1
            --AND (TEC.I_School_Group_ID = @SchoolGroupID OR @SchoolGroupID IS NULL OR @SchoolGroupID = 0)
            --AND (TEC.I_Class_ID = @ClassID OR @ClassID IS NULL OR @ClassID = 0)
            --AND (TE.Dt_StartDate = '2024-01-04');
        
    END

	--SELECT COUNT(TE.I_Event_Category_ID) AS CategoryCount,
	--TE.I_Event_Category_ID AS EventCategoryID,
	--TECA.S_Event_Category AS EventCategoryName INTO #CategoryCount
	--FROM T_Event AS TE
	--inner join T_Event_Category AS TECA ON TE.I_Event_Category_ID = TECA.I_Event_Category_ID
	--inner join T_Event_Class AS TEC ON TE.I_Event_ID = TEC.I_Event_ID

	--WHERE (TE.I_Brand_ID=@iBrandid OR @iBrandid IS NULL) 
	--AND (TEC.I_School_Group_ID = @SchoolGroupID OR @SchoolGroupID IS NULL)
	--AND (TEC.I_Class_ID = @ClassID OR @ClassID IS NULL)
	--GROUP BY TE.I_Event_Category_ID, TECA.S_Event_Category
	--Select * from #CategoryCount 
	--Drop Table #CategoryCount

END
