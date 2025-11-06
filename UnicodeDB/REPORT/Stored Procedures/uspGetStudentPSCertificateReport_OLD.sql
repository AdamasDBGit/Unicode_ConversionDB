/*
-- =================================================================
-- Author: Ujjwal Sinha
-- Create date: 09/07/2007 
-- Description: List PS&Certificate Student 
-- =================================================================
*/

CREATE PROCEDURE [REPORT].[uspGetStudentPSCertificateReport_OLD]
(
	@iBrandID		INT		,
	@sHierarchyList VARCHAR(MAX)	,
	@iCourseID		INT=NULL	,
	@iModuleID		INT=NULL	,
	@iStatusID		INT=NULL	,	
	@DtFrmDate		DATETIME=NULL	,
	@DtToDate		DATETIME=NULL

)
AS
BEGIN TRY
   SELECT
	SC.I_Centre_Id		,
	FN1.CenterCode		,
	FN1.CenterName		,
	FN2.InstanceChain	, 
	CM.S_Course_Code	,
	CM.S_Course_Name	,
	MM.S_Module_Code	,
	MM.S_Module_Name	,
	SM.S_Status_Desc	,
	PC.B_PS_FLAG		,
	COUNT(*) NUMBER  
   FROM [PSCERTIFICATE].T_STUDENT_PS_CERTIFICATE PC
	INNER JOIN
	[PSCERTIFICATE].T_Certificate_Logistic CL
	ON CL.I_Student_Certificate_ID = PC.I_Student_Certificate_ID
	INNER JOIN
	[PSCERTIFICATE].T_Certificate_Despatch_Info DI
	ON DI.I_Logistic_ID = CL.I_Logistic_ID
        INNER JOIN 
	[dbo].T_Status_Master SM
        ON PC.I_STATUS = SM.I_Status_Value
        AND SM.S_Status_Type='PSCertificate'
        INNER JOIN 
	[dbo].T_Student_Course_Detail CD
        ON CD.I_Student_Detail_ID = PC.I_Student_Detail_ID
        INNER JOIN
	[dbo].T_Course_Master CM
        ON CM.I_Course_ID = CD.I_Course_ID
        INNER JOIN
	[dbo].T_Student_Module_Detail MD
        ON MD.I_Student_Detail_ID = PC.I_Student_Detail_ID
        INNER JOIN
	[dbo].T_Module_Master MM
        ON MM.I_Module_ID = MD.I_Module_ID
        INNER JOIN
	dbo.T_Student_Center_Detail SC
	ON SC.I_Student_Detail_ID = PC.I_Student_Detail_ID
	INNER JOIN
	[dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
	ON SC.I_Centre_Id=FN1.CenterID
	INNER JOIN
	[dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,@iBrandID) FN2
	ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
   WHERE 
	(    PC.I_Status = 1 -- (when Status for Print) 
	     AND CD.I_Course_ID = COALESCE(@iCourseID,CD.I_Course_ID)
	     AND PC.I_STATUS = COALESCE(@iStatusID,PC.I_STATUS)
	     AND MD.I_Module_ID = COALESCE(@iModuleID,MD.I_Module_ID)
	     AND PC.Dt_Certificate_Issue_Date BETWEEN COALESCE(@DtFrmDate,PC.Dt_Certificate_Issue_Date) AND COALESCE(@DtToDate,PC.Dt_Certificate_Issue_Date)
	)
	OR
	(    PC.I_Status = 2 -- (when Status for Despatch) 
	     AND CD.I_Course_ID = COALESCE(@iCourseID,CD.I_Course_ID)
	     AND PC.I_STATUS = COALESCE(@iStatusID,PC.I_STATUS)
	     AND MD.I_Module_ID = COALESCE(@iModuleID,MD.I_Module_ID)
	     AND DI.Dt_Dispatch_Date BETWEEN COALESCE(@DtFrmDate,DI.Dt_Dispatch_Date) AND COALESCE(@DtToDate,DI.Dt_Dispatch_Date)
	)
        GROUP BY SC.I_Centre_Id, FN1.CenterCode, FN1.CenterName, FN2.InstanceChain, CM.S_Course_Code, CM.S_Course_Name,
                 MM.S_Module_Code, MM.S_Module_Name, SM.S_Status_Desc, PC.B_PS_FLAG

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
