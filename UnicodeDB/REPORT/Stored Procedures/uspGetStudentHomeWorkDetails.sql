

CREATE PROCEDURE [REPORT].[uspGetStudentHomeWorkDetails]

(
@sHierarchyList varchar(MAX),    
 @sBrandID VARCHAR(MAX),    
 @sBatchIDs VARCHAR(MAX) = NULL,  
 @dtStartDate datetime,    
 @dtEndDate datetime  
	
)

AS

BEGIN

SELECT 						
F.S_Center_Name,C.S_Batch_Name,H.S_Course_Name,A.S_Student_ID,
A.S_First_Name,ISNULL(A.S_Middle_Name,'') AS "Middle Name",
A.S_Last_Name,A.S_Mobile_No,hwm.S_Homework_Name,hwm.Dt_Crtd_On
,hws.Dt_Submission_Date,hws.Dt_Return_Date,ed.S_First_Name as "FacFistName",ed.S_Middle_Name as "FacMiddleName",ed.S_Last_Name as "FacLastname",ed.S_Phone_No
FROM T_Student_Detail A 
inner join T_Student_Batch_Details B ON A.I_Student_Detail_ID=B.I_Student_ID 
inner join T_Student_Batch_Master C ON C.I_Batch_ID=B.I_Batch_ID 
inner join T_Center_Batch_Details E ON E.I_Batch_ID=C.I_Batch_ID 
inner join T_Center_Hierarchy_Name_Details F ON F.I_Center_ID=E.I_Centre_Id
inner join T_Course_Master H ON C.I_Course_ID=H.I_Course_ID
inner join EXAMINATION.T_Homework_Master hwm on hwm.I_Batch_ID=B.I_Batch_ID
left join EXAMINATION.T_Homework_Submission hws on hws.I_Student_Detail_ID=A.I_Student_Detail_ID
and hwm.I_Homework_ID=hws.I_Homework_ID
left outer join dbo.T_Employee_Dtls ed on ed.I_Employee_ID=hws.I_Employee_ID
where B.I_Status=1 and
--B.I_Batch_ID LIKE COALESCE(@ibatchID,B.I_Batch_ID)
--and F.I_Center_ID LIKE COALESCE(@icenterID,F.I_Center_ID)
(@sBatchIDs IS NULL OR B.I_Batch_ID IN (SELECT Val FROM dbo.fnString2Rows(@sBatchIDs,','))) 
AND F.I_Center_ID IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@sBrandID AS INT)) CenterList)
--and hwm.Dt_Crtd_On between COALESCE(@Crdtdate1,hwm.Dt_Crtd_On) and COALESCE(@Crdtdate2,hwm.Dt_Crtd_On) 
AND DATEDIFF(dd,hwm.Dt_Crtd_ON,@dtStartDate) <= 0  
AND DATEDIFF(dd,hwm.Dt_Crtd_ON,@dtEndDate) >= 0  
--and hws.Dt_Submission_Date between COALESCE(@SubmDate1,hws.Dt_Submission_Date) and COALESCE(@SubmDate2,hws.Dt_Submission_Date) 
--and hws.Dt_Return_Date between COALESCE(@RetrnDate1,hws.Dt_Return_Date) and COALESCE(@RetrnDate2,hws.Dt_Return_Date) 
order by F.S_Center_Name,H.S_Course_Name,C.S_Batch_Name,A.S_Student_ID,hwm.S_Homework_Name

end
