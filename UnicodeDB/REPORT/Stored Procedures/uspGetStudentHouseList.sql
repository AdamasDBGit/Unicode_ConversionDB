
CREATE PROCEDURE [REPORT].[uspGetStudentHouseList]	--[REPORT].[uspGetStudentHouseList] 1095,1,107,1
(  
	@iBatchID INT ,
	--@iCenterID INT,
    @iBrandId INT,    
	@sHierarchyList VARCHAR(MAX) 
)  
AS  
BEGIN  

select 
THM.S_House_Name,TSD.S_Student_ID,isnull(TSD.S_First_Name,'') as "S_First_Name",
isnull(TSD.S_Middle_Name,'') as "S_Middle_Name",isnull(TSD.S_Last_Name,'') as "S_Last_Name",
TSBM.S_Batch_Name,TCM.S_Course_Name,TCFM.S_CourseFamily_Name,TCHND.S_Brand_Name,
isnull(TED.S_First_Name,'') as "F_First_Name",
isnull(TED.S_Middle_Name,'') as "F_Middle_Name",
isnull(TED.S_Last_Name,'') as "F_Last_Name"
from T_Student_Detail as TSD 
inner join T_House_Master as THM on TSD.I_House_ID=THM.I_House_ID
inner join T_Student_Batch_Details as TSBD on TSD.I_Student_Detail_ID=TSBD.I_Student_ID
inner join T_Student_Batch_Master as TSBM on TSBD.I_Batch_ID=TSBM.I_Batch_ID
inner join T_Course_Master as TCM on TSBM.I_Course_ID=TCM.I_Course_ID
inner join T_CourseFamily_Master as TCFM on TCM.I_CourseFamily_ID=TCFM.I_CourseFamily_ID
inner join T_Center_Batch_Details as TCBD on TSBM.I_Batch_ID=TCBD.I_Batch_ID
inner join T_Center_Hierarchy_Name_Details as TCHND on TCBD.I_Centre_Id=TCHND.I_Center_ID
left outer join T_Employee_Dtls as TED on TCBD.I_Employee_ID=TED.I_Employee_ID
where 
TSBD.I_Status=1 and
TSBD.I_Batch_ID = @iBatchID and
TSD.I_Status <> 0  and
TCBD.I_Centre_Id IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList)          
order by TSBM.S_Batch_Name,THM.S_House_Name,TSD.S_First_Name

END
