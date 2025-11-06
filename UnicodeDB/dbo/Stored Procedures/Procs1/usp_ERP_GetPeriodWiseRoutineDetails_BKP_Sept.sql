
-- =============================================        
-- Author:  <Author,,Name>        
-- Create date: <Create Date,,>        
-- Description: <Description,,>        
        
--exec [dbo].[usp_ERP_GetPeriodWiseRoutineDetails] 2, 3, 5, null, 1        
--exec [dbo].[usp_ERP_GetPeriodWiseRoutineDetails] null, null, null, null, null        
--exec [dbo].[usp_ERP_GetPeriodWiseRoutineDetails] 1, 5, 7, null, null        
      
-- =============================================        
CREATE PROCEDURE [dbo].[usp_ERP_GetPeriodWiseRoutineDetails_BKP_Sept]        
 -- Add the parameters for the stored procedure here        
 (        
  @sessionID INT = NULL,   @schoolGroupID INT = NULL,   @classID INT  = NULL,   @streamID INT = NULL,     @sectionID INT = NULL        
 )        
AS        
BEGIN        
 -- SET NOCOUNT ON added to prevent extra result sets from        
 -- interfering with SELECT statements.        
 SET NOCOUNT ON;        
        
    -- Insert statements for procedure here        
 SELECT         
 --TERSH.I_Routine_Structure_Header_ID AS HeaderID,        
 TERSD.I_Day_ID AS DayID,        
 TWDM.S_Day_Name AS DayName,        
 TERSD.I_Period_No AS PeriodNo,        
 TERSH.I_Total_Periods AS TotalPeriods,        
 TERSD.I_Routine_Structure_Detail_ID AS RoutineStructureID,        
        
 ISNULL(CONVERT(NVARCHAR, TERSD.T_FromSlot, 108), '') + ' - ' + ISNULL(CONVERT(NVARCHAR, TERSD.T_ToSlot, 108), '') AS PeriodTime,        
 --TERSD.T_FromSlot AS StartingTime,        
 --TERSD.T_ToSlot AS EndTime,        
 --TERSH.T_Start_Slot AS FirstStartingTime,        
 --TERSH.T_Duration AS PeriodDuration,        
 --TERSH.T_Period_Gap AS PeriodBufferTime,        
 TERSD.I_Is_Break AS IsBreak,        
 TESCR.I_Faculty_Master_ID AS FacultyID,        
 TFM.S_Faculty_Name AS FacultyName,        
 TESCR.I_Subject_ID AS SubjectID,        
 TSM.S_Subject_Name AS SubjectName,    
 TSM.I_TotalNoOfClasses AS TotalNoOfClass,    
 TESCR.S_Class_Type AS ClassType,      
 TERSH.I_Routine_Structure_Header_ID      
 into #GetPeriodWiseRoutineDetails      
        
 From         
 T_ERP_Routine_Structure_Header TERSH        
 inner join T_ERP_Routine_Structure_Detail TERSD ON TERSD.I_Routine_Structure_Header_ID = TERSH.I_Routine_Structure_Header_ID        
 left join T_ERP_Student_Class_Routine TESCR ON TESCR.I_Routine_Structure_Detail_ID = TERSD.I_Routine_Structure_Detail_ID         
 inner join T_Week_Day_Master TWDM ON TWDM.I_Day_ID = TERSD.I_Day_ID        
 left join T_Faculty_Master TFM ON TFM.I_Faculty_Master_ID = TESCR.I_Faculty_Master_ID --OR TESCR.I_Faculty_Master_ID IS NULL        
 left join T_Subject_Master TSM ON TSM.I_Subject_ID = TESCR.I_Subject_ID --OR TESCR.I_Subject_ID IS NULL         
        
 Where         
 (TERSH.I_School_Session_ID=@sessionID)        
 AND (TERSH.I_School_Group_ID=@schoolGroupID)        
 AND (TERSH.I_Class_ID=@classID OR @classID IS NULL)        
 AND (TERSH.I_Stream_ID=@streamID OR @streamID IS NULL)        
 AND (TERSH.I_Section_ID=@sectionID OR @sectionID IS NULL)        
 --AND (TESCR.I_Subject_ID = TSM.I_Subject_ID OR TESCR.I_Subject_ID IS NULL)        
 --AND (TESCR.I_Faculty_Master_ID = TFM.I_Faculty_Master_ID OR TESCR.I_Faculty_Master_ID IS NULL)        
 --AND TESCR.I_Faculty_Master_ID IS NULL        
 --AND TESCR.I_Subject_ID IS NULL        
 --order by TERSD.I_Day_ID     
declare @Routine_Structure_HeaderID int      
set @Routine_Structure_HeaderID = (select top 1 I_Routine_Structure_Header_ID from #GetPeriodWiseRoutineDetails)       
      
create table #Get_TotalSubject_Allocation      
(I_Routine_Structure_Header_ID int, I_Subject_ID int, S_Subject_Name varchar(100), WeeklyAllocatedcount int, Total_Yearly_Allocated int, HolidayCount int, Actual_Subject_Allocation int)      
insert into #Get_TotalSubject_Allocation(I_Routine_Structure_Header_ID, I_Subject_ID, S_Subject_Name, WeeklyAllocatedcount, Total_Yearly_Allocated, HolidayCount, Actual_Subject_Allocation)      
      
exec ERP_Usp_Get_TotalSubject_Allocation @Routine_Structure_HeaderID      
      
select a.*, b.Actual_Subject_Allocation from #GetPeriodWiseRoutineDetails a      
left join #Get_TotalSubject_Allocation b on a.I_Routine_Structure_Header_ID = b.I_Routine_Structure_Header_ID --and a.DayID = b.I_Day_ID      
and a.SubjectID = b.I_Subject_ID      
     order by a.DayID asc ,a.PeriodTime asc
      
END
