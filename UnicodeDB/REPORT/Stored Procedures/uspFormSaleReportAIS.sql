CREATE PROCEDURE [REPORT].[uspFormSaleReportAIS]
(
@dtStart DATETIME,
@dtEnd DATETIME,
@iBrandId INT,    
@sHierarchyList VARCHAR(MAX)  
)
AS
BEGIN

CREATE TABLE #Result(

ENQUIRY_ID INT,
RANGE_OF_FORMS VARCHAR(100),
DATE_SOLD DATETIME,
SCHOLAR VARCHAR(50),
SOLD_BY VARCHAR(100),
LOGIN_ID VARCHAR(100),
TOTAL_FORMS_SOLD VARCHAR(100),
TOTAL_COLLECTION INT
)



INSERT INTO #Result(LOGIN_ID,RANGE_OF_FORMS,TOTAL_FORMS_SOLD,DATE_SOLD,TOTAL_COLLECTION,SCHOLAR)
SELECT		--A.I_Enquiry_Regn_ID,
			A.S_Crtd_By,
			MIN(S_Form_No)+' - '+MAX(S_Form_No) As Range_Sold,
			COUNT(S_Form_No)as no_sold,
			Dt_Receipt_Date,
			COUNT(S_Form_No)*1000 as tot_collection,
			'DB' Scholar
			
			FROM T_Enquiry_Regn_Detail A

INNER JOIN T_Receipt_Header B ON A.I_Enquiry_Regn_ID=B.I_Enquiry_Regn_ID AND B.I_Status=1

WHERE B.I_Centre_Id IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList)  AND S_Form_No LIKE '081%' 
 AND DATEDIFF(dd,@dtStart,Dt_Receipt_Date)>=0 AND DATEDIFF(dd,@dtEnd,Dt_Receipt_Date)<=0

GROUP BY A.S_Crtd_By,Dt_Receipt_Date

UNION ALL

SELECT		--A.I_Enquiry_Regn_ID,
			A.S_Crtd_By,
			MIN(S_Form_No)+' - '+MAX(S_Form_No) As Range_Sold,
			COUNT(S_Form_No)as no_sold,
			Dt_Receipt_Date,
			COUNT(S_Form_No)*1000 as tot_collection,
			'DS' as Scholar
			
			FROM T_Enquiry_Regn_Detail A

INNER JOIN T_Receipt_Header B ON A.I_Enquiry_Regn_ID=B.I_Enquiry_Regn_ID AND B.I_Status=1

WHERE B.I_Centre_Id IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList)  AND S_Form_No LIKE '082%' 
 AND DATEDIFF(dd,@dtStart,Dt_Receipt_Date)>=0 AND DATEDIFF(dd,@dtEnd,Dt_Receipt_Date)<=0

GROUP BY A.S_Crtd_By,Dt_Receipt_Date







UPDATE  T 

SET T.SOLD_BY= V.S_First_Name+' '+V.S_Last_Name

FROM

#Result T 

INNER JOIN (


SELECT S_Login_ID,S_First_Name,S_Last_Name from T_User_Master)  V 

ON V.S_Login_ID=T.LOGIN_ID












select * from #Result order by DATE_SOLD,SCHOLAR



END
