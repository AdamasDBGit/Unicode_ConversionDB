/*
-- =================================================================
-- Author: Ujjwal Sinha
-- Create date: 09/07/2007 
-- Description:  This sp for Customer care query status report ,
--				this return dataset of Customer Care Complaints
-- =================================================================
*/

CREATE PROCEDURE [REPORT].[uspGetQueryStatusReport]
(
	@iBrandID		INT		,
	@sHierarchyList 	varchar(MAX)	,
	@iStatusID		INT = NULL	,	
	@DtFrmDate		DATETIME = NULL	,
	@DtToDate		DATETIME = NULL	,
	@iRootCauseID		INT = NULL,
	@sStatusName varchar(50)= NULL,
	@sRootCauseName varchar(20) = NULL

)
AS
BEGIN TRY
   SELECT
	SM.S_Status_Desc	,
	(CM.S_Root_Cause_Code +' - '+ CM.S_Root_Cause_Desc) AS S_Root_Cause_Desc 	,
    COUNT(*) AS NUMBER,
	FN1.CenterCode,
	FN1.CenterName,
	FN2.InstanceChain
   FROM [CUSTOMERCARE].T_Complaint_Request_Detail CR
        INNER JOIN 
	[CUSTOMERCARE].T_Root_Cause_Master CM
        ON CR.I_Root_Cause_ID = CM.I_Root_Cause_ID
	INNER JOIN 
	[dbo].T_Status_Master SM
        ON CR.I_STATUS_ID = SM.I_Status_Value
        AND SM.S_Status_Type='CustomerCareStatus'
	INNER JOIN
	[dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
	ON CR.I_Center_Id=FN1.CenterID
	INNER JOIN
	[dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
	ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
   WHERE CR.I_Root_Cause_ID = COALESCE(@iRootCauseID,CR.I_Root_Cause_ID)
     AND CR.I_STATUS_ID = COALESCE(@iStatusID,CR.I_STATUS_ID)
     AND CR.Dt_Complaint_Date 
	 BETWEEN COALESCE(@DtFrmDate,CR.Dt_Complaint_Date) 
     AND DATEADD(dd,1,COALESCE(@DtToDate,CR.Dt_Complaint_Date))
   GROUP BY CR.I_Center_Id, FN1.CenterCode, FN1.CenterName, FN2.InstanceChain, SM.S_Status_Desc,
            CM.S_Root_Cause_Desc,S_Root_Cause_Code
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
