/*
-- =================================================================
-- Author: Shankha Roy
-- Create date: 13/07/2007 
-- Description: This sp used Query Detailed Reports for Mode Customer care
-- Returns : DataSet
-- =================================================================
*/

CREATE PROCEDURE [REPORT].[uspGetComplaintModeSummaryReport]
(
	@iBrandID		INT		,
	@sHierarchyList 	varchar(100)	,
	@DtFrmDate		DATETIME=NULL	
	--@DtToDate		DATETIME=NULL	

)
AS
BEGIN TRY
	


-- Datatable for Mode complaint summary 
	SELECT
	COUNT(CRD.I_Complaint_Req_ID)AS Mode1,
	CMM.S_Complaint_Mode_Value
	FROM CUSTOMERCARE.T_Complaint_Request_Detail CRD
	INNER JOIN CUSTOMERCARE.T_Complaint_Mode_Master CMM
	ON CMM.I_Complaint_Mode_ID = CRD.I_Complaint_Mode_ID
	WHERE (DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate))<= 7
	GROUP BY CMM.S_Complaint_Mode_Value 	
	

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
