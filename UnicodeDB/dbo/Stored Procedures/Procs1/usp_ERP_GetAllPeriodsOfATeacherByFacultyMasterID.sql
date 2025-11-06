--exec [usp_ERP_GetAllPeriodsOfATeacherByFacultyMasterID] 1066,null,null,null
CREATE PROCEDURE [dbo].[usp_ERP_GetAllPeriodsOfATeacherByFacultyMasterID]     
(    
 -- Add the parameters for the stored procedure here    
 @FacultyMasterID INT = NULL,    
 @DayID INT = NULL,    
 @Date datetime = NULL,    
 @BrandID int = NULL  ,  
 ----Add Filter SessionID-------  
 @sessionID int=null  
)    
AS    
BEGIN    
 BEGIN TRY    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
 If @BrandID is Null  
 Begin  
 set @BrandID = (select top 1 I_Brand_ID from T_Faculty_Master   
 where I_Faculty_Master_ID=@FacultyMasterID)    
 End  
 DECLARE @isHoliday int,@holidayName nvarchar(MAX)    
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
  Left Join T_School_Academic_Session_Master ASM on ASM.I_Brand_ID=TE.I_Brand_ID   
  where I_Event_Category_ID=2 and TE.I_Brand_ID=@BrandID  and I_EventFor=3    
  and FM.I_Faculty_Master_ID=@FacultyMasterID   
  -----add Session ID Filter  
  and ASM.I_School_Session_ID=@sessionID  
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
 Select 1 from #Holiday_DayCount where DateRange=FORMAT(@Date, 'yyyy-MM-dd')      
 )      
 Begin      
 --Select STRING_AGG(S_Event_Name,',') tset from #Holiday_DayCount where DateRange=@InputDate    
 set @isHoliday = 1    
 set @holidayName = (SELECT STUFF((SELECT ',' + S_Event_Name FROM #Holiday_DayCount where DateRange=FORMAT(@Date, 'yyyy-MM-dd') FOR XML PATH('')), 1, 1, '' ) AS CombinedValues)    
     
 End      
     
       
      
 drop table #Holiday_DayCount      
    
    -- Insert statements for procedure here    
 SELECT     
 CONCAT(TERSD.T_FromSlot, ' - ', TERSD.T_ToSlot) AS TimeRange,    
 TERSD.T_FromSlot AS StarTime,    
 TERSD.T_ToSlot AS EndTime,    
 TWDM.S_Day_Name AS DayName,    
 TERSD.I_Period_No AS PeriodNo,    
 TFM.S_Faculty_Name AS FacultyName,    
 TFM.S_Faculty_Code FacultyCode,    
 TSM.S_Subject_Code SubjectCode,    
 TSM.S_Subject_Name AS SubjectName,    
 TSM.I_Subject_ID AS SubjectID,    
 TSG.S_School_Group_Name AS SchoolGroup,    
 --TC.S_Class_Name AS ClassName,    
CASE 
        WHEN TSS.S_Stream IS NOT NULL THEN CONCAT(TC.S_Class_Name, ' (', TSS.S_Stream, ')')
        ELSE TC.S_Class_Name
    END AS ClassName,    
 TERSD.I_Day_ID AS DayID,    
 TERSH.I_Section_ID,    
 TS.S_Section_Name AS Section,  
 TERSH.I_Stream_ID,
 TSS.S_Stream Stream,
 TESCR.I_Student_Class_Routine_ID AS StudentClassRoutineID,    
 CASE WHEN     
    ( SELECT COUNT(*) FROM T_ERP_Attendance_Entry_Header AS TEAEH WHERE TEAEH.I_Student_Class_Routine_ID = TESCR.I_Student_Class_Routine_ID AND Dt_Date = @Date    
    ) > 0 THEN 1 ELSE 0 END AS IsAttendanceTaken,    
 TFM.S_Faculty_Name TeacherName,    
 @isHoliday IsHoliday,    
 @holidayName Holiday    
    
 --TWDM.S_Day_Name AS Day_Name    
     
    
 FROM    
 T_ERP_Student_Class_Routine TESCR    
 INNER JOIN T_ERP_Routine_Structure_Detail TERSD ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID    
 INNER JOIN T_ERP_Routine_Structure_Header TERSH ON TERSH.I_Routine_Structure_Header_ID = TERSD.I_Routine_Structure_Header_ID    
 INNER JOIN T_Faculty_Master TFM ON TFM.I_Faculty_Master_ID = TESCR.I_Faculty_Master_ID    
 INNER JOIN T_Subject_Master TSM ON TSM.I_Subject_ID = TESCR.I_Subject_ID    
 INNER JOIN T_School_Group TSG ON TSG.I_School_Group_ID = TERSH.I_School_Group_ID    
 INNER JOIN T_Class TC ON TC.I_Class_ID = TERSH.I_Class_ID    
 INNER JOIN T_Week_Day_Master TWDM ON TWDM.I_Day_ID = TERSD.I_Day_ID    
 LEFT JOIN T_Section TS ON TS.I_Section_ID = TERSH.I_Section_ID  --OR TERSH.I_Section_ID is null    
 LEFT JOIN T_Stream TSS ON TSS.I_Stream_ID=TERSH.I_Stream_ID
    
 WHERE     
 (TESCR.I_Faculty_Master_ID =@FacultyMasterID OR @FacultyMasterID IS NULL) AND (TERSD.I_Day_ID =@DayID OR @DayID IS NULL)    
 GROUP BY     
 TERSD.T_FromSlot,     
 TERSD.T_ToSlot,    
 TFM.S_Faculty_Name,     
 TSM.S_Subject_Name,     
 TSG.S_School_Group_Name,    
 TC.S_Class_Name,    
 TERSD.I_Day_ID,    
 TERSH.I_Section_ID,    
 TS.S_Section_Name,    
 TWDM.S_Day_Name,    
 TERSD.I_Period_No,    
 TSM.I_Subject_ID,   
 TERSH.I_Stream_ID,
 TSS.S_Stream,
 TESCR.I_Student_Class_Routine_ID,    
 TERSD.I_Routine_Structure_Detail_ID,    
 TSM.S_Subject_Code,    
 TFM.S_Faculty_Code    
 order by TERSD.I_Day_ID asc
 END TRY    
 BEGIN CATCH    
  DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
    
  SELECT @ErrMsg = ERROR_MESSAGE(),    
    @ErrSeverity = ERROR_SEVERITY()    
  select 0 StatusFlag,@ErrMsg Message    
 END CATCH    
END
