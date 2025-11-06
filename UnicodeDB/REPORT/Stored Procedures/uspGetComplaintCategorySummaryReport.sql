/*
-- =================================================================
-- Author: Shankha Roy
-- Create date: 13/07/2007 
-- Description: This sp used Query Detailed Reports for Category Customer care
-- Returns : DataSet
-- =================================================================
*/

CREATE PROCEDURE [REPORT].[uspGetComplaintCategorySummaryReport]
(
	@iBrandID		INT		,
	@sHierarchyList 	varchar(100)	,
	@DtFrmDate		DATETIME=NULL	
	--@DtToDate		DATETIME=NULL	

)
AS
BEGIN TRY
	
	-- Datatable for Category complaint summary 
		
	SELECT 
	COUNT(CRD.I_Complaint_Req_ID)AS Total,
	CCM.S_Complaint_Desc
	FROM CUSTOMERCARE.T_Complaint_Request_Detail CRD
	INNER JOIN CUSTOMERCARE.T_Complaint_Category_Master CCM
	ON CCM.I_Complaint_Category_ID = CRD.I_Complaint_Category_ID
	WHERE (DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate))<= 7
	GROUP BY CCM.I_Complaint_Category_ID,CCM.S_Complaint_Desc
		

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
