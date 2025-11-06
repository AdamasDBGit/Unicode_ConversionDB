/*
-- =================================================================
-- Author:Babin SAha
-- Create date:07/28/2007 
-- Description: SP For Audit NC Report
NCRRaised = 1,
NCRAcknowledge = 2,
NCRRequesteForClose = 3,
NCRApprovedRequestForClose = 4,
NCRRejected = 5,
***NCRClosed = 6,[@iStatusID]
NCRBreachNotice = 7

-- =================================================================
*/
CREATE PROCEDURE [REPORT].[uspAuditNCRReport]
(
	@iBrandID INT = NULL,
	@sHierarchyList VARCHAR(MAX) = NULL,
	@dtStartDate DATETIME,
	@dtEndDate DATETIME,
	@iStatusID INT
)
AS
BEGIN TRY
DECLARE @TotalNCR INT 
SELECT	
		--DISTINCT(RES.I_Audit_Result_ID) AS I_Audit_Result_ID,
		FN1.CenterCode AS CenterCode 
		,FN1.CenterName AS CenterName
		,FN2.InstanceChain AS InstanceChain
		,CONVERT(VARCHAR,ADT.Dt_Audit_On,101) AS AuditDate
		--,(SUBSTRING(REPLACE((REPLACE(FN2.InstanceChain,' ','')),' ',''),(CHARINDEX('n-',(REPLACE(FN2.InstanceChain,' ','')),0) + 2),(CHARINDEX(';C',(REPLACE(FN2.InstanceChain,' ','')),0) - (CHARINDEX('n-',(REPLACE(FN2.InstanceChain,' ','')),0)+2)))) AS RegionName
		,COUNT(NCRTotal.I_Audit_Report_NCR_ID) AS TotalNCR
		,COUNT(NCRCritical.I_Audit_Report_NCR_ID) AS CriticalNCR
		,COUNT(NCROpenCritical.I_Audit_Report_NCR_ID) AS OpenCriticalNCR
		,COUNT(NCROpen.I_Audit_Report_NCR_ID) AS OpenNCR
		,[RES].[I_Audit_Result_ID]
		FROM AUDIT.T_Audit_Schedule ADT
		
		INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
		ON ADT.I_Center_Id=FN1.CenterID
		LEFT OUTER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,@iBrandID) FN2
		ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
		
		LEFT OUTER JOIN AUDIT.T_Audit_Result RES
		ON ADT.I_Audit_Schedule_ID= RES.I_Audit_Schedule_ID
		LEFT OUTER JOIN AUDIT.T_Audit_Result_NCR NCRTotal
		ON RES.I_Audit_Result_ID = NCRTotal.I_Audit_Result_ID 
		
		LEFT OUTER JOIN AUDIT.T_Audit_Result_NCR NCRCritical
		ON NCRTotal.I_Audit_Report_NCR_ID = NCRCritical.I_Audit_Report_NCR_ID AND NCRCritical.I_NCR_Type_ID=1 
		
		LEFT OUTER JOIN AUDIT.T_Audit_Result_NCR NCROpenCritical
		ON NCRTotal.I_Audit_Report_NCR_ID = NCROpenCritical.I_Audit_Report_NCR_ID AND NCROpenCritical.I_NCR_Type_ID=1 AND NCROpenCritical.I_Status_ID <> @iStatusID

		LEFT OUTER JOIN AUDIT.T_Audit_Result_NCR NCROpen
		ON NCRTotal.I_Audit_Report_NCR_ID = NCROpen.I_Audit_Report_NCR_ID AND NCROpen.I_NCR_Type_ID=0 AND NCROpen.I_Status_ID <> @iStatusID
        
		WHERE 
		DATEDIFF(dd,ADT.Dt_Audit_On,@dtStartDate) <= 0
		AND DATEDIFF(dd,ADT.Dt_Audit_On,@dtEndDate) >= 0
		
		GROUP BY
		 NCRTotal.I_Audit_Result_ID
		,FN1.CenterCode
		,FN1.CenterName
		,FN2.InstanceChain
		,ADT.Dt_Audit_On
		,RES.I_Audit_Result_ID		

		ORDER BY ADT.Dt_Audit_On ASC

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
