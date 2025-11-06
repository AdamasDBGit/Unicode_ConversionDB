CREATE PROCEDURE [dbo].[TeacherRoutineMyClasses_Bkp]  
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 18-09-2023
-- Description:	Teacher Day Wise My Class Routine_Details
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
	TERSD.T_FromSlot,
	TERSD.T_ToSlot,
	TERSH.I_School_Session_ID,
	TWDM.S_Day_Name ,
	TERSD.I_Period_No ,
	TFM.S_Faculty_Name ,
	TSM.S_Subject_Name,
	TSM.I_Subject_ID,
	TSG.S_School_Group_Name,
	TC.S_Class_Name ,
	TERSD.I_Day_ID ,
	TS.S_Section_Name,
	TESCR.I_Student_Class_Routine_ID,
	TEAEH.Dt_CreatedAt,
	CASE WHEN 
    ( SELECT COUNT(*) FROM T_ERP_Attendance_Entry_Header AS TEAEH WHERE TEAEH.I_Student_Class_Routine_ID = TESCR.I_Student_Class_Routine_ID
    ) > 0 THEN 1 ELSE 0 END AS IsAttendance,
	TFM.S_Faculty_Name ,
	COUNT(TEAED.I_Student_Detail_ID) as Total_Student,
	(Case when 
A.I_Attendance_Entry_Header_ID IS NULL 
THEN 0 else 1 
end) as Mark_Attendance,
isnull (A.Presnt,0) As Present, 

(COUNT(TEAED.I_Student_Detail_ID)-isnull (A.Presnt,0)) as Absent

	--TWDM.S_Day_Name AS Day_Name
	

	FROM
	T_ERP_Student_Class_Routine TESCR
	INNER JOIN T_ERP_Routine_Structure_Detail TERSD ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID
	INNER JOIN T_ERP_Routine_Structure_Header TERSH ON TERSH.I_Routine_Structure_Header_ID = TERSD.I_Routine_Structure_Header_ID
	INNER JOIN T_Faculty_Master TFM ON TFM.I_Faculty_Master_ID = TESCR.I_Faculty_Master_ID
	left join T_ERP_Attendance_Entry_Header TEAEH on TEAEH.I_Student_Class_Routine_ID=TESCR.I_Student_Class_Routine_ID --and CAST(TEAEH.Dt_CreatedAt AS DATE) = CAST(@Day AS DATE)
	left join T_ERP_Attendance_Entry_Detail TEAED on TEAED.I_Attendance_Entry_Header_ID=TEAEH.I_Attendance_Entry_Header_ID
	left Join T_Student_Detail TSD on 
TSD.I_Student_Detail_ID=TEAED.I_Student_Detail_ID
inner join T_School_Group_Class TSGC ON TSGC.I_School_Group_ID = TERSH.I_School_Group_ID
inner join T_Student_Class_Section TSCS ON TSCS.I_School_Session_ID = TERSH.I_School_Session_ID AND TSCS.I_School_Group_Class_ID = TSGC.I_School_Group_Class_ID --AND (TSCS.I_Section_ID = TERSH.I_Section_ID OR TSCS.I_Section_ID is null)-- AND (TSCS.I_Stream_ID = TERSH.I_Stream_ID OR TSCS.I_Stream_ID is null)
	AND ((TSCS.I_Section_ID = TERSH.I_Section_ID) OR (TSCS.I_Section_ID IS NULL AND TERSH.I_Section_ID IS NULL))
	AND ((TSCS.I_Stream_ID = TERSH.I_Stream_ID) OR (TSCS.I_Stream_ID IS NULL AND TERSH.I_Stream_ID IS NULL))
---- To generalise the mark attendance part --------------- 

LEFT join 
(Select distinct I_Attendance_Entry_Header_ID, COUNT (I_Student_Detail_ID)As Presnt
from T_ERP_Attendance_Entry_Detail where I_IsPresent=1 
group by I_Attendance_Entry_Header_ID) As A on 
A.I_Attendance_Entry_Header_ID=TEAEH.I_Attendance_Entry_Header_ID 
and 
A.I_Attendance_Entry_Header_ID=TEAED.I_Attendance_Entry_Header_ID
	INNER JOIN T_Subject_Master TSM ON TSM.I_Subject_ID = TESCR.I_Subject_ID
	INNER JOIN T_School_Group TSG ON TSG.I_School_Group_ID = TERSH.I_School_Group_ID
	INNER JOIN T_Class TC ON TC.I_Class_ID = TSGC.I_Class_ID and TC.I_Class_ID = TERSH.I_Class_ID
	LEFT join T_ERP_Student_Subject TESS ON TESS.I_Subject_ID = TESCR.I_Subject_ID and TESS.I_Student_Detail_ID=TSCS.I_Student_Detail_ID
	INNER JOIN T_Week_Day_Master TWDM ON TWDM.I_Day_ID = TERSD.I_Day_ID
	left JOIN T_Section TS ON TS.I_Section_ID = TERSH.I_Section_ID  
	
	WHERE
	(TESCR.I_Faculty_Master_ID =@TeacherID OR @TeacherID IS NULL) AND (TERSD.I_Day_ID =@D) --AND CAST(TEAEH.Dt_CreatedAt AS DATE) = CAST(@Day AS DATE)
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
	TEAEH.Dt_CreatedAt,
	(Case when 
A.I_Attendance_Entry_Header_ID IS NULL 
THEN 0 else 1 
end),
A.Presnt 



END
