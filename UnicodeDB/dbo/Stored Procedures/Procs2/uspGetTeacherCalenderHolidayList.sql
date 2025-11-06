CREATE PROCEDURE [dbo].[uspGetTeacherCalenderHolidayList]
(
	@iBrandID int = null,
	@iClassID int = null
)
AS

BEGIN
DECLARE @start datetime;
DECLARE @end datetime;

SET @start = (
    SELECT TOP 1 Dt_Session_Start_Date 
    FROM T_School_Academic_Session_Master WHERE I_Current_Session = 1 
    and I_Brand_ID = @iBrandID 
    ORDER BY I_School_Session_ID DESC
);

SET @end = (
    SELECT TOP 1 Dt_Session_End_Date 
    FROM T_School_Academic_Session_Master WHERE I_Current_Session = 1 
    and I_Brand_ID = @iBrandID 
    ORDER BY I_School_Session_ID DESC
);
print @start
print @end
SELECT 
    CASE 
        WHEN DATEDIFF(DAY, TE.Dt_StartDate, TE.Dt_EndDate) = 0 
            THEN DATEADD(DAY, ROW_NUMBER() OVER(PARTITION BY TE.I_Event_ID ORDER BY I.Id) - 1, TE.Dt_StartDate) 
        ELSE DATEADD(DAY, ROW_NUMBER() OVER(PARTITION BY TE.I_Event_ID ORDER BY I.Id) - 1, TE.Dt_StartDate)
    END AS Date,
    TE.S_Event_Name AS HolidayName,
    TEV.S_Event_Category AS HolidayType,
    TE.I_Event_ID,
    CASE 
        WHEN DATEDIFF(DAY, TE.Dt_StartDate, TE.Dt_EndDate) = 0 
            THEN SUBSTRING(DATENAME(dw, DATEADD(DAY, ROW_NUMBER() OVER(PARTITION BY TE.I_Event_ID ORDER BY I.Id) - 1, TE.Dt_StartDate)), 1, 3)
        ELSE SUBSTRING(DATENAME(dw, DATEADD(DAY, ROW_NUMBER() OVER(PARTITION BY TE.I_Event_ID ORDER BY I.Id) - 1, TE.Dt_StartDate)), 1, 3)
    END AS Day,
    TE.I_Brand_ID AS BrandID
FROM T_Event TE 
JOIN T_INCR I ON I.Id <= (DATEDIFF(DAY, TE.Dt_StartDate, TE.Dt_EndDate) + 1) 
INNER JOIN T_Event_Category TEV ON TE.I_Event_Category_ID = TEV.I_Event_Category_ID
WHERE 
    TE.I_Brand_ID = @iBrandID 
    AND TE.I_Event_Category_ID = 2 AND TE.I_EventFor in (2,3)
    AND (
        (TE.Dt_StartDate BETWEEN @start AND @end) 
        OR (TE.Dt_EndDate BETWEEN @start AND @end)
        OR (TE.Dt_StartDate <= @start AND TE.Dt_EndDate >= @end)
    )
ORDER BY TE.I_Event_ID;

END

