create view Tridip_Stu_Daily_Attendance As 
Select  distinct TSD.S_Student_ID AS Student_ID, 

(TSD.S_First_Name+'  '+TSD.S_Middle_Name+'  '+TSD.S_Last_Name) AS Name, 
TSD.S_OrgEmailID AS Email,
TSD.S_Mobile_No AS Mobile_NO,
(Case when 
TSD.I_Status=1 then 'Active' else 'Inactive' end) Student_Status,
TSBM.S_Batch_Name As Batch, 
TSBM.S_Batch_Code AS Batch_ID, 
convert(date,TSBM.Dt_BatchStartDate) AS Batch_Start_Date,

convert(date,TSBM.Dt_Course_Expected_End_Date) AS Batch_End_Date,
TCCM.S_Center_Name As Branch,
TSM.S_Session_Name As Session,
TTM.S_Term_Name As Term,
TMM.S_Module_Name AS Module,
(case when 
TSA.I_Attendance_Detail_ID is not NULL then 'Present' else 'Absent'end) As Attendance,

convert(date,TSA.Dt_Crtd_On) As Attendance_On, 

 convert(date,TTTM.Dt_Schedule_Date) as Class_Schedule_Date, 
 convert (date,TTTM.Dt_Actual_Date) As Class_Actual_Date,

(TED.S_First_Name+' '+ TED.S_Last_Name) as Teacher

from T_TimeTable_Master TTTM 
inner join T_Student_Batch_Master TSBM on TSBM.I_Batch_ID=TTTM.I_Batch_ID
inner join T_Student_Batch_Details TSBD on TSBD.I_Batch_ID=TSBM.I_Batch_ID and 
TSBD.I_Batch_ID=TTTM.I_Batch_ID
inner join T_Student_Detail TSD on TSD.I_Student_Detail_ID=TSBD.I_Student_ID
inner join T_Session_Master TSM on TSM.I_Session_ID=TTTM.I_Session_ID
inner join T_Term_Master TTM on TTM.I_Term_ID=TTTM.I_Term_ID
inner join T_Module_Master TMM on TMM.I_Module_ID=TTTM.I_Module_ID
left join T_Student_Attendance TSA on TSA.I_Student_Detail_ID=TSD.I_Student_Detail_ID
and TTTM.I_TimeTable_ID=TSA.I_TimeTable_ID
inner join T_Centre_Master TCCM on TCCM.I_Centre_Id=TTTM.I_Center_ID
inner join T_TimeTable_Faculty_Map TMFP on TMFP.I_TimeTable_ID=TTTM.I_TimeTable_ID

inner join T_Employee_Dtls TED on TED.I_Employee_ID=TMFP.I_Employee_ID
where convert (date,TTTM.Dt_Schedule_Date)= DATEADD(day, -1, CAST(GETDATE() AS date))
 and TSD.I_Status=1 and TSBD.I_Status=1 
;