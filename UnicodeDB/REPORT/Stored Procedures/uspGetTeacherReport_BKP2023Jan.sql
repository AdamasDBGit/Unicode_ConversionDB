
CREATE PROCEDURE [REPORT].[uspGetTeacherReport_BKP2023Jan]
(

@dtStartDate AS DateTime,
@dtEndDate AS DateTIME,
@iEmployeeID AS INT =null,
@iBrandId INT,    
@sHierarchyList VARCHAR(MAX),
@sBatchID VARCHAR(MAX)=null
)
AS
BEGIN

if (@sBatchID is not null)
begin

SELECT 
FN2.InstanceChain,
FN1.CenterName,
A.I_TimeSlot_ID,
CONVERT(VARCHAR(100),Dt_Start_Time,108)+' - '+CONVERT(VARCHAR(100),Dt_End_Time,108) AS SLOT,
S_Course_Name,
S_Batch_Name,
S_Session_Name,
C.I_Employee_ID,
F.S_First_Name+' '+ISNULL(F.S_Middle_Name,' ')+' '+F.S_Last_Name AS FACULTY,
S_Room_No,
S_Center_Name,
CONVERT(DATE,B.Dt_Schedule_Date) AS CLASS_DATE,
--COUNT(I.I_Homework_ID) AS HOMEWORK_CHECKED
CONVERT(DATE,B.Dt_Schedule_Date) AS SCHEDULE_DATE



FROM 
T_Center_Timeslot_Master A
LEFT JOIN T_TimeTable_Master B ON A.I_TimeSlot_ID=B.I_TimeSlot_ID AND B.I_Status=1

INNER JOIN T_TimeTable_Faculty_Map C ON C.I_TimeTable_ID=B.I_TimeTable_ID --AND C.B_Is_Actual=0
INNER JOIN T_Student_Batch_Master D ON D.I_Batch_ID=B.I_Batch_ID
INNER JOIN T_Course_Master E ON E.I_Course_ID=D.I_Course_ID
INNER JOIN T_Employee_Dtls F ON F.I_Employee_ID=C.I_Employee_ID
INNER JOIN T_Room_Master G ON G.I_Room_ID=B.I_Room_ID
INNER JOIN T_Center_Hierarchy_Name_Details H ON H.I_Center_ID=B.I_Center_ID
INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
ON H.I_Center_Id=FN1.CenterID
INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
--LEFT JOIN EXAMINATION.T_Homework_Submission I ON I.I_Employee_ID=C.I_Employee_ID




 WHERE 
 --B.I_Center_ID IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList) 
 --AND
 Dt_Schedule_Date BETWEEN @dtStartDate AND @dtEndDate
 AND
C.I_Employee_ID=ISNULL(@iEmployeeID,C.I_Employee_ID)
 and D.I_Batch_ID in
 (
 select CAST(Val as int) from fnString2Rows(@sBatchID,',')
 )
--AND
--I.Dt_Return_Date BETWEEN @dtStartDate AND @dtEndDate
--GROUP BY
--A.I_TimeSlot_ID,
--CONVERT(VARCHAR(100),Dt_Start_Time,108)+' - '+CONVERT(VARCHAR(100),Dt_End_Time,108),
--S_Course_Name,
--S_Batch_Name,
--S_Session_Name,
--F.S_First_Name+' '+ISNULL(F.S_Middle_Name,' ')+' '+F.S_Last_Name,
--S_Room_No,
--S_Center_Name

 ORDER BY CONVERT(DATE,B.Dt_Schedule_Date),D.S_Batch_Name,F.S_First_Name+' '+ISNULL(F.S_Middle_Name,' ')+' '+F.S_Last_Name,I_TimeSlot_ID
end
else
begin

SELECT 
FN2.InstanceChain,
FN1.CenterName,
A.I_TimeSlot_ID,
CONVERT(VARCHAR(100),Dt_Start_Time,108)+' - '+CONVERT(VARCHAR(100),Dt_End_Time,108) AS SLOT,
S_Course_Name,
S_Batch_Name,
S_Session_Name,
C.I_Employee_ID,
F.S_First_Name+' '+ISNULL(F.S_Middle_Name,' ')+' '+F.S_Last_Name AS FACULTY,
S_Room_No,
S_Center_Name,
CONVERT(DATE,B.Dt_Schedule_Date) AS CLASS_DATE,
--COUNT(I.I_Homework_ID) AS HOMEWORK_CHECKED
CONVERT(DATE,B.Dt_Schedule_Date) AS SCHEDULE_DATE



FROM 
T_Center_Timeslot_Master A
LEFT JOIN T_TimeTable_Master B ON A.I_TimeSlot_ID=B.I_TimeSlot_ID AND B.I_Status=1

INNER JOIN T_TimeTable_Faculty_Map C ON C.I_TimeTable_ID=B.I_TimeTable_ID --AND C.B_Is_Actual=0
INNER JOIN T_Student_Batch_Master D ON D.I_Batch_ID=B.I_Batch_ID
INNER JOIN T_Course_Master E ON E.I_Course_ID=D.I_Course_ID
INNER JOIN T_Employee_Dtls F ON F.I_Employee_ID=C.I_Employee_ID
INNER JOIN T_Room_Master G ON G.I_Room_ID=B.I_Room_ID
INNER JOIN T_Center_Hierarchy_Name_Details H ON H.I_Center_ID=B.I_Center_ID
INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
ON H.I_Center_Id=FN1.CenterID
INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
--LEFT JOIN EXAMINATION.T_Homework_Submission I ON I.I_Employee_ID=C.I_Employee_ID




 WHERE 
 --B.I_Center_ID IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList) 
 --AND
 Dt_Schedule_Date BETWEEN @dtStartDate AND @dtEndDate
 AND
C.I_Employee_ID=ISNULL(@iEmployeeID,C.I_Employee_ID)
 --and D.I_Batch_ID in
 --(
 --select CAST(Val as int) from fnString2Rows(@sBatchID,',')
 --)
--AND
--I.Dt_Return_Date BETWEEN @dtStartDate AND @dtEndDate
--GROUP BY
--A.I_TimeSlot_ID,
--CONVERT(VARCHAR(100),Dt_Start_Time,108)+' - '+CONVERT(VARCHAR(100),Dt_End_Time,108),
--S_Course_Name,
--S_Batch_Name,
--S_Session_Name,
--F.S_First_Name+' '+ISNULL(F.S_Middle_Name,' ')+' '+F.S_Last_Name,
--S_Room_No,
--S_Center_Name

 ORDER BY CONVERT(DATE,B.Dt_Schedule_Date),D.S_Batch_Name,F.S_First_Name+' '+ISNULL(F.S_Middle_Name,' ')+' '+F.S_Last_Name,I_TimeSlot_ID


end



 END
