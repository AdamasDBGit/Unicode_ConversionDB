/*******************************************************
Author	:     Arindam Roy
Date	:	  07/25/2007
Description : This SP retrieves the Employee Details
				
*********************************************************/


CREATE PROCEDURE [REPORT].[uspGetEmployeeDetailsReport]
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@sStatus varchar(30)=null
)
AS
BEGIN TRY

	 SELECT ED.I_Employee_ID,
			ED.S_Emp_ID,
			LTRIM(ISNULL(ED.S_Title,'') + ' ') + ED.S_First_Name + ' ' + LTRIM(ISNULL(ED.S_Middle_Name,'') + ' ' + ED.S_Last_Name) as EmpName,
			ED.S_Title,
			ED.S_First_Name,
			ED.S_Middle_Name,
			ED.S_Last_Name,
			ED.Dt_DOB,
			ED.S_Phone_No,
			ED.S_Email_ID,
			EA.S_Address_Line1 + ' '+ EA.S_Address_Line2 as Emp_Address,
			ED.Dt_Joining_Date,
			ED.Dt_Resignation_Date,
			ED.Dt_DeactivationDate,
			ED.I_Status,
			Status= CASE 
					WHEN ED.I_Status= 0 THEN 'Inactive'
					WHEN ED.I_Status= 1 THEN 'NewlyJoined'
					WHEN ED.I_Status= 2 THEN 'Registered'
					WHEN ED.I_Status= 3 THEN 'Activated'
					WHEN ED.I_Status= 4 THEN 'Deactivated'
					WHEN ED.I_Status= 5 THEN 'Resigned'
					WHEN ED.I_Status= 6 THEN 'AdditionalRolesAssigned'
					ELSE 'Others'
					END,
			ED.Dt_Registration_Date,
			ED.S_Remarks,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain
	   INTO #tmpEmpDtl
	   FROM dbo.T_Employee_Dtls ED
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON ED.I_Centre_Id=FN1.CenterID
			INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
			INNER JOIN EOS.T_Employee_Address EA
				ON ED.I_Employee_ID=EA.I_Employee_ID
	  WHERE ED.I_Status<>0

	 SELECT * FROM #tmpEmpDtl 
	  WHERE Status LIKE ISNULL(@sStatus,Status) + '%'
   ORDER BY InstanceChain,CenterName
	
	 DROP TABLE #tmpEmpDtl

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
