CREATE PROCEDURE [dbo].[uspGetAllTeacherEventList]
(
	@iBrandID int = null
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
SELECT 
AM.*,
TE.I_Event_ID ID 
,TEC.S_Event_Category EventCategory
,TE.S_Event_Name EventName
,TE.Dt_StartDate StartDate
,TE.Dt_EndDate EndDate
,TE.S_Address Address
,@start SessionStartDate
,@end SessionEndDate
from 
(SELECT
 number,
 DATENAME(MONTH, '1900-' + CAST(number as varchar(2)) + '-1') monthname
FROM master..spt_values
WHERE Type = 'P' and number between 1 and 12
) as AM
left join T_Event TE on AM.number = MONTH(TE.Dt_StartDate) 
and  TE.Dt_StartDate between @start and @end
left join T_Event_Category TEC ON TEC.I_Event_Category_ID = TE.I_Event_Category_ID
--join 
--(
--select I_Event_ID from T_Event_Class 
--where I_Class_ID = @iClassID
--group by I_Event_ID
--) 
--as TECC ON TECC.I_Event_ID = TE.I_Event_ID
where TE.I_Event_Category_ID!=2


END
