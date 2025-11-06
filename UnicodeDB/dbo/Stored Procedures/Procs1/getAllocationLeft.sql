-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  

-- exec getAllocationLeft 42, 12
-- =============================================  
CREATE PROCEDURE [dbo].[getAllocationLeft]  
 -- Add the parameters for the stored procedure here  
 (  
  @HeaderID int,  
  @SubjectID int   
 )  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 create table #Get_TotalSubject_Allocation      
 (I_Routine_Structure_Header_ID int, I_Subject_ID int, S_Subject_Name varchar(100), WeeklyAllocatedcount int, Total_Yearly_Allocated int, HolidayCount int, Actual_Subject_Allocation int)      
 insert into #Get_TotalSubject_Allocation(I_Routine_Structure_Header_ID, I_Subject_ID, S_Subject_Name, WeeklyAllocatedcount, Total_Yearly_Allocated, HolidayCount, Actual_Subject_Allocation)      
      
 exec ERP_Usp_Get_TotalSubject_Allocation @HeaderID   
  
 select t1.I_Subject_ID,
 --t1.Actual_Subject_Allocation,  
 --TSM.I_TotalNoOfClasses,  
 TSM.I_TotalNoOfClasses-t1.Actual_Subject_Allocation as AllocationLeft  
 from T_Subject_Master TSM  
 left join #Get_TotalSubject_Allocation t1 on TSM.I_Subject_ID = t1.I_Subject_ID  
 where t1.I_Subject_ID=@SubjectID  
END
