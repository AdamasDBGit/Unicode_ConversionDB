--exec ERP_Usp_Holiday_Check_Faculty_Student '2024-04-01',107,3,3
CREATE Proc [dbo].[ERP_Usp_Holiday_Check_Faculty_Student](  
@InputDate date,  
@BrandID int = null  ,
@FacultyID int = null,
@Eventfor int=null  --3 faculty -2 student
)  
As   
Begin  
--Declare @BrandID int  
--,@InputDate date  
--,@FacultyID int,
--@Eventfor int
--SET @InputDate='2024-03-13'  
--SET @BrandID=107  
--SET @FacultyID=2
--SET @Eventfor=3
  --select * from T_Event
  --select * from T_ERP_Event_Faculty
  
;WITH HDateRanges AS (  
    SELECT  
        Te.Dt_StartDate,  
        TE.Dt_EndDate,  
        ROW_NUMBER() OVER (ORDER BY Dt_StartDate) AS HolidayID ,
		TE.S_Event_Name
    FROM  
        T_Event TE
		Left Join T_ERP_Event_Faculty EF on TE.I_Event_ID=EF.I_Event_ID
		Left Join T_Faculty_Master FM on FM.I_Faculty_Master_ID=EF.I_Faculty_Master_ID
		where I_Event_Category_ID=2 and TE.I_Brand_ID=@BrandID  and I_EventFor=@Eventfor
		and FM.I_Faculty_Master_ID=@FacultyID
)  
  
SELECT  
    HolidayID,  
    DateRange,
	S_Event_Name,
 DATENAME(WEEKDAY, DateRange) AS DayName,  
    COUNT(*) AS DayCount  
 Into #Holiday_DayCount  
FROM  
    HDateRanges  
CROSS APPLY  
    (SELECT TOP (DATEDIFF(DAY, Dt_StartDate, Dt_EndDate) + 1)  
         DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1, Dt_StartDate) AS DateRange  
     FROM  
         master.dbo.spt_values) AS Dates  
GROUP BY  
    HolidayID, DateRange  ,S_Event_Name
ORDER BY  
    HolidayID, DateRange,S_Event_Name;  
	--select * from #Holiday_DayCount

 If Exists(  
 Select 1 from #Holiday_DayCount where DateRange=@InputDate  
 )  
 Begin  
 --Select STRING_AGG(S_Event_Name,',') tset from #Holiday_DayCount where DateRange=@InputDate
 SELECT STUFF((SELECT ',' + S_Event_Name FROM #Holiday_DayCount where DateRange=@InputDate FOR XML PATH('')), 1, 1, '' ) AS CombinedValues;
 End  
 Else  
 Begin  
 Select 'No Holiday for that Day'
 End  
  
 drop table #Holiday_DayCount  
 End
