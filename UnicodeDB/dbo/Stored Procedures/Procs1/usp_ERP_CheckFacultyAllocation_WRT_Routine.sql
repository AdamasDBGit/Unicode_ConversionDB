-- =============================================            
-- Author:  <Author,,Name>            
-- Create date: <Create Date,,>            
-- Description: <Description,,>            
            
--exec [dbo].[usp_ERP_CheckFacultyAllocation_WRT_Routine] 2, 1, 13          
-- =============================================            
CREATE PROCEDURE [dbo].[usp_ERP_CheckFacultyAllocation_WRT_Routine]             
 -- Add the parameters for the stored procedure here            
 (                
  @DayID INT,                
  @PeriodNo INT,                
  @FacultyID INT   ,    
  @SessionID int    
  --@SectionID INT = NULL              
 )                
AS                
BEGIN                
 -- SET NOCOUNT ON added to prevent extra result sets from                
 -- interfering with SELECT statements.                
 SET NOCOUNT ON;              
  --Declare @DayID INT=2,                
  --@PeriodNo INT=2,                
  --@FacultyID INT=13              
          
  Declare @ClassName Varchar(50)              
  Declare @PrevPeriod int, @Post_Period int        
  Declare @SectionID int  ,@classID int,@Prev_Period int, @Header_ID int, @LastPeriodNo int        
        
  --select top 1 @LastPeriodNo=I_Total_Periods from T_ERP_Routine_Structure_Header     
  --where I_Routine_Structure_Header_ID =@Header_ID      
  --and I_School_Session_ID=@SessionID    
        
 select @ClassName = TC.S_Class_Name, @classID=TERSH.I_Class_ID ,           
 @SectionID = TERSH.I_Section_ID, @Header_ID = TERSH.I_Routine_Structure_Header_ID              
 FROM T_ERP_Student_Class_Routine TESCR                
 left join T_ERP_Routine_Structure_Detail TERSD ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID                
 left join T_ERP_Routine_Structure_Header TERSH on TERSD.I_Routine_Structure_Header_ID = TERSH.I_Routine_Structure_Header_ID              
 left join T_Class TC on TERSH.I_Class_ID = TC.I_Class_ID              
 WHERE (TESCR.I_Faculty_Master_ID = @FacultyID)                
 AND (TERSD.I_Day_ID = @DayID)                
 AND (TERSD.I_Period_No = @PeriodNo)     
 and TERSH.I_School_Session_ID=@SessionID 
 and TERSH.I_Section_ID=@SectionID
   --Select @classID,@SectionID      
     select top 1 @LastPeriodNo=I_Total_Periods 
	 from T_ERP_Routine_Structure_Header     
  where I_Routine_Structure_Header_ID =@Header_ID      
  and I_School_Session_ID=@SessionID    
   Set @Prev_Period=@PeriodNo-1          
   Set @Post_Period=@PeriodNo+1        
   --select @Prev_Period          
   If @classID is  Not null and @SectionID is Not Null         
 -- IF EXISTS(                
 --SELECT                     
 --1,              
 --TERSH.I_Class_ID              
 --FROM T_ERP_Student_Class_Routine TESCR                
 --inner join T_ERP_Routine_Structure_Detail TERSD ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID                
 --left join T_ERP_Routine_Structure_Header TERSH on TERSD.I_Routine_Structure_Header_ID = TERSH.I_Routine_Structure_Header_ID              
 --WHERE (TESCR.I_Faculty_Master_ID = @FacultyID)                
 --AND (TERSD.I_Day_ID = @DayID)                
 --AND (TERSD.I_Period_No = @PeriodNo)                
 --)                
 BEGIN                
 SELECT 1 AS StatusFlag, 'Faculty has already been assigned for Class - ' + Replace(@ClassName,'Class','') + ', Period ' + CAST(@PeriodNo AS varchar(5)) +'For Section '+Convert(varchar(10),@SectionID)+ ' at the same time. ' AS Message    
 --SELECT 0 AS StatusFlag, 'Faculty avaliable for new allocation' AS Message       
 END            
 ---------Checking for Previous period          
 ELSE  IF          
 EXISTS(                
 SELECT                     
 1           
 FROM T_ERP_Student_Class_Routine TESCR                
 inner join T_ERP_Routine_Structure_Detail TERSD ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID                
 left join T_ERP_Routine_Structure_Header TERSH on TERSD.I_Routine_Structure_Header_ID = TERSH.I_Routine_Structure_Header_ID              
 WHERE TESCR.I_Faculty_Master_ID = @FacultyID   
 AND TERSD.I_Day_ID = @DayID               
 AND (TERSD.I_Period_No = @Prev_Period --and TERSH.I_Class_ID=@Prev_ClassID      
 OR TERSD.I_Period_No = @Post_Period)  
  AND TERSH.I_School_Session_ID=@SessionID   )  
 --and @Prev_Period<>1 --OR @Post_Period<>@LastPeriodNo        
           
Begin          
 --SELECT 1 AS StatusFlag, 'Faculty was already been assigned for consecutive period'  AS Message  
  SELECT 0 AS StatusFlag, 'Faculty avaliable for new allocation' AS Message        
          
End          
 Else          
 BEGIN                
 SELECT 0 AS StatusFlag, 'Faculty avaliable for new allocation' AS Message                
 END                
              
END 