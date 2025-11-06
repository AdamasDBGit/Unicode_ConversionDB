CREATE PROCEDURE [REPORT].[NewAdmissionList]
(

@dtStart DATETIME,
@dtEnd DATETIME,
@iBrandId INT,    
@sHierarchyList VARCHAR(MAX))

AS
BEGIN

DECLARE @StdCode AS VARCHAR(100)


SET @StdCode =(select DISTINCT RIGHT(YEAR(DATEADD(yyyy,0,Dt_BatchStartDate)),2) FROM T_Student_Batch_Master
 WHERE DATEDIFF(dd,@dtStart,Dt_BatchStartDate)>=0 AND DATEDIFF(dd,@dtEnd,Dt_BatchStartDate)<=0  )


SELECT S_Student_ID,A.S_First_Name,A.S_Middle_Name,A.S_Last_Name,A.S_Mobile_No,A.S_Guardian_Name,S_Batch_Name,S_Route_No,S_PickupPoint_Name,'DB' Scholar FROM T_Student_Detail A INNER JOIN T_Student_Center_Detail B
ON A.I_Student_Detail_ID=B.I_Student_Detail_ID AND B.I_Status=1 AND B.I_Centre_Id IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList) 
INNER JOIN T_Student_Batch_Details C ON C.I_Student_ID=A.I_Student_Detail_ID AND C.I_Status=1
INNER JOIN T_Enquiry_Regn_Detail G ON G.I_Enquiry_Regn_ID=A.I_Enquiry_Regn_ID
INNER JOIN T_Student_Batch_Master D ON D.I_Batch_ID=C.I_Batch_ID
LEFT JOIN T_BusRoute_Master E ON E.I_Route_ID=A.I_Route_ID
LEFT JOIN T_Transport_Master F ON F.I_PickupPoint_ID=A.I_Transport_ID
WHERE S_Student_ID LIKE @StdCode+'%'
AND
G.S_Form_No LIKE '081%'

UNION ALL
SELECT S_Student_ID,A.S_First_Name,A.S_Middle_Name,A.S_Last_Name,A.S_Mobile_No,A.S_Guardian_Name,S_Batch_Name,S_Route_No,S_PickupPoint_Name,'DS' Scholar FROM T_Student_Detail A INNER JOIN T_Student_Center_Detail B
ON A.I_Student_Detail_ID=B.I_Student_Detail_ID AND B.I_Status=1 AND B.I_Centre_Id IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList) 
INNER JOIN T_Student_Batch_Details C ON C.I_Student_ID=A.I_Student_Detail_ID AND C.I_Status=1
INNER JOIN T_Enquiry_Regn_Detail G ON G.I_Enquiry_Regn_ID=A.I_Enquiry_Regn_ID
INNER JOIN T_Student_Batch_Master D ON D.I_Batch_ID=C.I_Batch_ID
LEFT JOIN T_BusRoute_Master E ON E.I_Route_ID=A.I_Route_ID
LEFT JOIN T_Transport_Master F ON F.I_PickupPoint_ID=A.I_Transport_ID
WHERE S_Student_ID LIKE @StdCode+'%'
AND
G.S_Form_No LIKE '082%'
ORDER BY Scholar,S_Student_ID

END
