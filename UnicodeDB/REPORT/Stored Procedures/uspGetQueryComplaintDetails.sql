/*
-- =================================================================
-- Author: Shankha Roy
-- Create date: 10/07/2007 
-- Description: This sp used Query Detailed Reports of Customer care
-- Returns : DataSet
-- =================================================================
*/

CREATE PROCEDURE [REPORT].[uspGetQueryComplaintDetails]
(
	@iBrandID		INT		,
	@sHierarchyList 	varchar(MAX)	,
	@DtFrmDate		DATETIME=NULL	,
	@DtToDate		DATETIME=NULL

)
AS
BEGIN TRY

SELECT		DISTINCT
			CR.I_Complaint_Req_ID,
			CR.S_Complaint_Code	,
			CONVERT(VARCHAR(12),CR.Dt_Complaint_Date,106) AS Dt_Complaint_Date,
			CR.I_Complaint_Mode_ID,
			CM.S_Complaint_Mode_Value	,
			CT.S_Complaint_Desc	AS Category	,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain,
			TBM.S_Brand_Name AS Product,
			TBM.S_Brand_Code,
			--ISNULL(TUM.S_Login_ID,'') AS ProcessOwner,
			ISNULL(TUM.[S_Title],'') + ' ' + ISNULL(TUM.[S_First_Name],'') + ' ' + ISNULL(TUM.[S_Middle_Name],'') + ' ' + ISNULL(TUM.[S_Last_Name],'')AS ProcessOwner,
			ISNULL((TUM.S_Title + ' '+TUM.S_First_Name + ' '+TUM.S_Middle_Name+' '+TUM.S_Last_Name),'') AS UserName,
  			ISNULL(TUM.S_Email_ID, '') AS S_Email_ID,
			ISNULL((SD.S_Title + ' '+SD.S_First_Name + ' '+SD.S_Middle_Name+' '+SD.S_Last_Name),'') AS StudentName,
			CR.S_Complaint_Details		,
			ISNULL(([REPORT].fnGetCycleTimeForCustomerCare(2,CR.I_Status_ID,CR.I_Complaint_Req_ID)),0) AS CycleTimeNew,
			--ISNULL(CONVERT(INT,(DATEDIFF(DD,CR.Dt_Complaint_Date,GETDATE()))),0) AS Cycle	,
			SM.S_Status_Desc AS Status,
			TCAT1.S_Remarks AS Feedback1,
			TCAT2.S_Remarks AS Feedback2,
			TCAT3.S_Remarks AS Feedback3
			FROM [CUSTOMERCARE].T_Complaint_Request_Detail CR
				INNER JOIN 
			[CUSTOMERCARE].T_Complaint_Mode_Master CM
				ON CM.I_Complaint_Mode_ID = CR.I_Complaint_Mode_ID
				INNER JOIN 
			[CUSTOMERCARE].T_Complaint_Category_Master CT
			ON CT.I_Complaint_Category_ID = CR.I_Complaint_Category_ID
				LEFT OUTER JOIN
			[CUSTOMERCARE].T_Complaint_Feedback CF
				ON CF.I_Complaint_Req_ID = CR.I_Complaint_Req_ID
			INNER JOIN
			[dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
			ON CR.I_Center_Id=FN1.CenterID
			INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
			ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
   			INNER JOIN dbo.T_Brand_Center_Details BCD
			ON CR.I_Center_Id=BCD.I_Centre_Id			
			INNER JOIN dbo.T_Brand_Master TBM
			ON BCD.I_Brand_ID = TBM.I_Brand_ID
			--LEFT OUTER JOIN dbo.T_Employee_Dtls ED
			--ON ED.I_Employee_ID = CR.I_User_ID	
			LEFT OUTER JOIN dbo.T_User_Master TUM
			--ON TUM.I_Reference_ID = ED.I_Employee_ID
			ON TUM.I_User_ID = CR.I_User_ID
			LEFT OUTER JOIN CUSTOMERCARE.T_Complaint_Audit_Trail TCAT1
			ON TCAT1.I_Complaint_Req_ID = CR.I_Complaint_Req_ID
			AND TCAT1.I_Complaint_Audit_ID = (SELECT MIN(T1.I_Complaint_Audit_ID) FROM 
			CUSTOMERCARE.T_Complaint_Audit_Trail T1 WHERE T1.I_Complaint_Req_ID = CR.I_Complaint_Req_ID
			AND T1.I_Status_ID IN(4,12)
			AND T1.S_Remarks IS NOT NULL
			)
			LEFT OUTER JOIN CUSTOMERCARE.T_Complaint_Audit_Trail TCAT2
			ON TCAT2.I_Complaint_Req_ID = CR.I_Complaint_Req_ID
			AND TCAT2.I_Complaint_Audit_ID = (SELECT (MIN(T2.I_Complaint_Audit_ID)+1) FROM 
			CUSTOMERCARE.T_Complaint_Audit_Trail T2 WHERE T2.I_Complaint_Req_ID = CR.I_Complaint_Req_ID
			AND T2.I_Status_ID IN (4,5,10,12)
			AND T2.S_Remarks IS NOT NULL)
			LEFT OUTER JOIN CUSTOMERCARE.T_Complaint_Audit_Trail TCAT3
			ON TCAT3.I_Complaint_Req_ID = CR.I_Complaint_Req_ID
			AND TCAT3.I_Complaint_Audit_ID = (SELECT (MIN(T3.I_Complaint_Audit_ID)+2) FROM 
			CUSTOMERCARE.T_Complaint_Audit_Trail T3 WHERE T3.I_Complaint_Req_ID = CR.I_Complaint_Req_ID
			AND T3.I_Status_ID IN (5,10,12)
			AND T3.S_Remarks IS NOT NULL 
			)	
			INNER JOIN dbo.T_Student_Detail SD
			ON SD.I_Student_Detail_ID = CR.I_Student_Detail_ID
			INNER JOIN dbo.T_Status_Master SM
			ON SM.I_Status_Value = CR.I_Status_ID
			AND SM.S_Status_Type = 'CustomerCareStatus'
			
		   WHERE CR.Dt_Complaint_Date BETWEEN COALESCE(@DtFrmDate,CR.Dt_Complaint_Date) 
		   AND COALESCE(DATEADD(dd,1,@DtToDate),CR.Dt_Complaint_Date) 


      
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
