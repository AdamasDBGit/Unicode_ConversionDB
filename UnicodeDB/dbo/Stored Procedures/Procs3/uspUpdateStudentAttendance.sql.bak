
CREATE PROCEDURE [dbo].[uspUpdateStudentAttendance]

AS

BEGIN TRY

DECLARE @TStudentAttendance TABLE      
  (      
   I_Student_Detail_ID INT,
   I_TimeTable_ID int
  )       
 

INSERT INTO @TStudentAttendance    
  (   
  I_Student_Detail_ID,
   I_TimeTable_ID  
  )	
	
select Z.I_Student_Detail_ID,z.I_TimeTable_ID
--,DATEDIFF(MINUTE,Start_Time,Arrival_Time) AS 'arrive',
--DATEDIFF(MINUTE,End_Time,Departure_Time) AS 'depart'
 from
(
SELECT A.I_Centre_Id,F.centercode ,A.I_Student_Detail_ID,D.I_TimeTable_ID,B.S_Student_ID,c.I_Batch_ID,D.Dt_Actual_Date,D.Dt_Schedule_Date,D.I_Module_ID,D.I_Session_ID,D.I_Room_ID,D.S_Session_Name, 
dateadd(day, datediff(day, 0, E.Dt_Start_Time) * -1, E.Dt_Start_Time) as Start_Time ,
ISNULL(dateadd(day, datediff(day, 0, F.[ArrivalTime]) * -1, F.[ArrivalTime]),'') as Arrival_Time,
dateadd(day, datediff(day, 0, E.Dt_End_Time) * -1, E.Dt_End_Time) as End_Time,
ISNULL(dateadd(day, datediff(day, 0, F.DepartureTime) * -1, F.DepartureTime),'') as Departure_Time,
E.I_TimeSlot_ID 
FROM [dbo].[T_Student_Center_Detail] A
inner join [dbo].[T_Student_Detail] B
on A.I_Student_Detail_ID=B.I_Student_Detail_ID
inner join [dbo].[T_Student_Batch_Details] C
on C.[I_Student_ID]=A.I_Student_Detail_ID
inner join [dbo].[T_TimeTable_Master] D
on D.I_Batch_ID=C.I_Batch_ID
inner join [dbo].T_Center_Timeslot_Master E
on E.I_TimeSlot_ID=D.I_TimeSlot_ID
inner join [dbo].[T_Temp_Attdn_Table] F
on B.S_Student_ID=F.stdID 
--and A.I_Centre_Id = F.centercode 
where A.I_Centre_Id in (select distinct centercode from [dbo].[T_Temp_Attdn_Table] ) and C.I_Status=1
and D.Dt_Schedule_Date=DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))--only considering the classes to be held on current date
) as z

where (Arrival_Time = '1900-01-01 00:00:00.000' or DATEDIFF(MINUTE,Start_Time,Arrival_Time) <0)
-- and (Departure_Time='1900-01-01 00:00:00.000' or DATEDIFF(MINUTE,End_Time,Departure_Time) >0)


--following statement will check the record exists and then merge the table

--MERGE [dbo].[T_Student_Attendance]  AS tmp
--USING (select * from @TStudentAttendance) AS tsa
--ON tsa.I_Student_Detail_ID = tmp.I_Student_Detail_ID and tsa.I_TimeTable_ID = tmp.I_TimeTable_ID 
--WHEN MATCHED THEN UPDATE SET tmp.I_Student_Detail_ID=tmp.I_Student_Detail_ID
--WHEN NOT MATCHED THEN
--INSERT(I_Student_Detail_ID,I_TimeTable_ID)
--VALUES(tsa.I_Student_Detail_ID,tsa.I_TimeTable_ID);
insert into [dbo].[T_Student_Attendance](I_Student_Detail_ID,I_TimeTable_ID) 
select tsa.I_Student_Detail_ID,tsa.I_TimeTable_ID from @TStudentAttendance as tsa 
where not exists ( select tmp.I_Student_Detail_ID,tmp.I_TimeTable_ID from  [dbo].[T_Student_Attendance]as tmp where  tsa.I_Student_Detail_ID=tmp.I_Student_Detail_ID and tsa.I_TimeTable_ID=tmp.I_TimeTable_ID)


 drop table [dbo].[T_Temp_Attdn_Table]

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
