CREATE  PROCEDURE [dbo].[TeacherRoutineMyClasses]            
-- =============================================          
-- Author: Tridip Chatterjee          
-- Create date: 18-09-2023          
-- Description: Teacher Day Wise My Class Routine_Details          
-- exec [TeacherRoutineMyClasses] 1066,'2024-09-02'          
-- =============================================          
-- Add the parameters for the stored procedure here          
@TeacherID int,          
@Day date         
        
AS          
BEGIN          
 -- SET NOCOUNT ON added to prevent extra result sets from          
 SET NOCOUNT ON;          
 declare @D int          
 Set @D=(          
    select I_Day_ID from           
    T_Week_Day_Master where S_Day_Name =(SELECT DATENAME(dw,@Day)))          
          
 SELECT           
 --CONCAT(TERSD.T_FromSlot, ' - ', TERSD.T_ToSlot) AS TimeRange,          
         
 TERSD.T_FromSlot ,          
 TERSD.T_ToSlot,          
 TERSH.I_School_Session_ID,          
 TWDM.S_Day_Name ,          
 TERSD.I_Period_No ,          
 TFM.S_Faculty_Name,          
 TFM.I_Faculty_Master_ID,          
 TSM.S_Subject_Name,          
 TSM.I_Subject_ID ,          
 TSG.S_School_Group_Name,          
 TSG.I_School_Group_ID,          
 TC.S_Class_Name,          
 TC.I_Class_ID,          
 TERSD.I_Day_ID,          
 TS.S_Section_Name,          
 TESCR.I_Student_Class_Routine_ID ,          
        
 CASE WHEN           
    ( SELECT COUNT(*) FROM T_ERP_Attendance_Entry_Header AS TEAEH WHERE TEAEH.I_Student_Class_Routine_ID = TESCR.I_Student_Class_Routine_ID AND TEAEH.I_Faculty_Master_ID=TFM.I_Faculty_Master_ID AND CAST(TEAEH.Dt_Date as date) = CAST(getdate() as date)    
  
    
      
    ) > 0 THEN 1 ELSE 0 END AS IsAttendance,          
 CASE WHEN           
 --   ( SELECT COUNT(*) FROM T_ERP_Teacher_Time_Plan AS TETTP         
 --inner join        
 --  T_ERP_Subject_Structure_Plan as SSP on TETTP.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID        
 --  inner join        
 --  T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID        
 --  left join        
 --  T_ERP_Subject_Structure_Plan_Execution_Remarks as SSPER on SSPER.I_Teacher_Time_Plan_ID=TETTP.I_Teacher_Time_Plan_ID        
 --  Inner Join T_ERP_Student_Class_Routine SCR ON SCR.I_Student_Class_Routine_ID=TETTP.I_Student_Class_Routine_ID  
  
 --WHERE TETTP.I_Student_Class_Routine_ID = TESCR.I_Student_Class_Routine_ID   
 --and SSP.I_Month_No=MONTH(@Day) and (@D IS NULL or SSP.I_Day_No =@D)     
 (SELECT COUNT(*) FROM T_ERP_Teacher_Time_Plan AS TETTP         
 inner join        
   T_ERP_Subject_Structure_Plan as SSP on TETTP.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID        
   inner join        
   T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID 
   left join
   T_ERP_Teacher_Time_Plan as TTP on TTP.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID 
   left join        
   T_ERP_Subject_Structure_Plan_Execution_Remarks as SSPER on SSPER.I_Teacher_Time_Plan_ID=TETTP.I_Teacher_Time_Plan_ID        
   Inner Join T_ERP_Student_Class_Routine SCR ON SCR.I_Student_Class_Routine_ID=TETTP.I_Student_Class_Routine_ID  
  
 WHERE TETTP.I_Student_Class_Routine_ID = TESCR.I_Student_Class_Routine_ID and convert(DATE,TTP.Dt_Class_Date) = CONVERT(DATE,@Day)

    ) > 0 THEN 1 ELSE 0 END AS IsLogbook,         
 TFM.S_Faculty_Name TeacherName,          
 TESCRW.S_ClassWork ClassWork          
 ,ttc.TotalStud as Total_Student        
 ,Tersh.I_Stream_ID I_Stream_ID   
 --,STT.S_Stream Stream
          
 --TWDM.S_Day_Name AS Day_Name          
   into #TempClass        
          
 FROM          
 T_ERP_Student_Class_Routine TESCR          
 INNER JOIN T_ERP_Routine_Structure_Detail TERSD ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID          
 INNER JOIN T_ERP_Routine_Structure_Header TERSH ON TERSH.I_Routine_Structure_Header_ID = TERSD.I_Routine_Structure_Header_ID          
 INNER JOIN T_Faculty_Master TFM ON TFM.I_Faculty_Master_ID = TESCR.I_Faculty_Master_ID          
 INNER JOIN T_Subject_Master TSM ON TSM.I_Subject_ID = TESCR.I_Subject_ID          
 INNER JOIN T_School_Group TSG ON TSG.I_School_Group_ID = TERSH.I_School_Group_ID          
 INNER JOIN T_Class TC ON TC.I_Class_ID = TERSH.I_Class_ID          
 INNER JOIN T_Week_Day_Master TWDM ON TWDM.I_Day_ID = TERSD.I_Day_ID          
 iNNER JOIN T_Section TS ON TS.I_Section_ID = TERSH.I_Section_ID           
 left join T_ERP_Student_Class_Routine_Work TESCRW on           
 TESCRW.I_Student_Class_Routine_ID = TESCR.I_Student_Class_Routine_ID           
 and TESCRW.I_Faculty_Master_ID = TESCR.I_Faculty_Master_ID          
 and CAST(TESCRW.Dt_Date as date) = CAST(@Day as date)         
 Left Join T_Stream STT On STT.I_Stream_ID=TERSH.I_Stream_ID or TERSH.I_Stream_ID is null        
 Left Join(        
select A.I_Brand_ID,A.I_School_Session_ID,tc.I_Class_ID,TST.I_Stream_ID,        
count(I_Student_Class_Section_ID)as TotalStud ,TS.I_Section_ID,b.I_School_Group_ID       
from T_Student_Class_Section a        
Inner Join T_School_Group_Class b 
on a.I_School_Group_Class_ID=b.I_School_Group_Class_ID        
Inner Join T_Class TC ON TC.I_Class_ID=B.I_Class_ID        
Inner JOIN T_Section TS ON A.I_Section_ID = TS.I_Section_ID  -- Join T_Section if exists        
LEFT JOIN T_Stream TST ON A.I_Stream_ID = TST.I_Stream_ID     
--where tc.I_Class_ID=15  
Group by A.I_Brand_ID,A.I_School_Session_ID,tc.I_Class_ID,        
          
TST.I_Stream_ID,TS.I_Section_ID,b.I_School_Group_ID            
) as ttc on ttc.I_School_Session_ID= TERSH.I_School_Session_ID        
and ttc.I_Class_ID=TERSH.I_Class_ID     
and ttc.I_Section_ID=TERSH.I_Section_ID 
and ttc.I_School_Group_ID=TSG.I_School_Group_ID
and (ttc.I_Stream_ID=TERSH.I_Stream_ID OR TERSH.I_Stream_ID is null  )  
  
  
 WHERE           
 (TESCR.I_Faculty_Master_ID =@TeacherID ) AND (TERSD.I_Day_ID =@D )          
 GROUP BY           
 TERSD.T_FromSlot,           
 TERSD.T_ToSlot,          
 TFM.S_Faculty_Name,           
 TSM.S_Subject_Name,           
 TSG.S_School_Group_Name,          
 TC.S_Class_Name,          
 TERSD.I_Day_ID,          
 TS.S_Section_Name,          
 TWDM.S_Day_Name,          
 TERSD.I_Period_No,          
 TSM.I_Subject_ID,          
 TESCR.I_Student_Class_Routine_ID,          
 TERSD.I_Routine_Structure_Detail_ID,          
 TERSH.I_School_Session_ID,          
 TC.I_Class_ID,          
 TSG.I_School_Group_ID,          
 TFM.I_Faculty_Master_ID,          
 TESCRW.S_ClassWork  ,        
 ttc.TotalStud,        
 ttc.I_Stream_ID   
 ,TERSH.I_Stream_ID  
 ,ttc.I_Stream_ID
-- ,STT.S_Stream      
          
       select t1.*,TS.S_Stream Stream from #TempClass t1 left join T_Stream TS On TS.I_Stream_ID=t1.I_Stream_ID

	   drop table #TempClass
          
END