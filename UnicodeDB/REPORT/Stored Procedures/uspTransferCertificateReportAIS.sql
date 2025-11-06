CREATE PROCEDURE [REPORT].[uspTransferCertificateReportAIS]
(

@dtStart AS DATETIME,
@dtEnd AS DATETIME,
@iBrandId INT,    
@sHierarchyList VARCHAR(MAX) 
)
AS
BEGIN


CREATE TABLE #temp
(
	STUDENT_CODE VARCHAR(100),
	STUDENT_ID INT,
	FIRST_NAME VARCHAR(100),
	MIDDLE_NAME VARCHAR(100),
	LAST_NAME VARCHAR(100),
	BATCH_NAME VARCHAR(100),
	TC_DATE DATETIME,
	GUARDIAN_NAME VARCHAR(100),
	NARRATION VARCHAR(500)
)

INSERT INTO #temp(STUDENT_ID,TC_DATE,NARRATION)

	SELECT A.I_Student_Detail_ID,Release_Date,S_Remarks FROM T_Transfer_Certificates A INNER JOIN T_Student_Detail B
	ON B.I_Student_Detail_ID=A.I_Student_Detail_ID INNER JOIN T_Student_Center_Detail C
	ON C.I_Student_Detail_ID=B.I_Student_Detail_ID AND B.I_Status=1
	
	 where DATEDIFF(dd,@dtStart,Release_Date)>=0
	 AND
	 DATEDIFF(dd,@dtEnd,Release_Date)<=0
	 
	  AND C.I_Centre_Id IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList) 



UPDATE	T1
SET 
		T1.FIRST_NAME=T2.S_First_Name,
		T1.MIDDLE_NAME =T2.S_Middle_Name,
		T1.LAST_NAME=T2.S_Last_Name,
		T1.STUDENT_CODE=T2.S_Student_ID

FROM
		#temp T1

INNER JOIN

(

		SELECT A.I_Student_Detail_ID,S_First_Name,S_Middle_Name,S_Last_Name,S_Student_ID FROM T_Student_Detail A INNER JOIN T_Student_Center_Detail B
		ON A.I_Student_Detail_ID=B.I_Student_Detail_ID AND B.I_Status=1  AND b.I_Centre_Id IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList) 

) T2

		ON T2.I_Student_Detail_ID=T1.STUDENT_ID


UPDATE	T1
SET 
		T1.BATCH_NAME=T2.S_Batch_Name

FROM
		#temp T1

INNER JOIN

(

		SELECT A.I_Student_Detail_ID,C.S_Batch_Name FROM T_Student_Detail A INNER JOIN T_Student_Batch_Details B 
		ON A.I_Student_Detail_ID=B.I_Student_ID AND B.I_Status=1
		INNER JOIN T_Student_Batch_Master C ON C.I_Batch_ID=B.I_Batch_ID

) T2

		ON T2.I_Student_Detail_ID=T1.STUDENT_ID
		

UPDATE	T1
SET 
		T1.BATCH_NAME=T2.S_Batch_Name

FROM
		#temp T1

INNER JOIN

(

		SELECT A.I_Student_Detail_ID,C.S_Batch_Name FROM T_Student_Detail A INNER JOIN T_Student_Batch_Details B 
		ON A.I_Student_Detail_ID=B.I_Student_ID AND B.I_Status=3
		INNER JOIN T_Student_Batch_Master C ON C.I_Batch_ID=B.I_Batch_ID

) T2

		ON T2.I_Student_Detail_ID=T1.STUDENT_ID


UPDATE	T1
SET 
		T1.GUARDIAN_NAME=T2.S_Guardian_Name

FROM
		#temp T1

INNER JOIN

(

		SELECT B.I_Student_Detail_ID,A.S_Guardian_Name FROM T_Enquiry_Regn_Detail A INNER JOIN T_Student_Detail B
		ON A.I_Enquiry_Regn_ID=B.I_Enquiry_Regn_ID WHERE A.I_Centre_Id IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList) 

) T2

		ON T2.I_Student_Detail_ID=T1.STUDENT_ID







SELECT * FROM #temp


END
