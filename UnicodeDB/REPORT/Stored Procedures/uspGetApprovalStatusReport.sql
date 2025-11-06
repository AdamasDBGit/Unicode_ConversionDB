CREATE PROCEDURE [REPORT].[uspGetApprovalStatusReport]
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@dtStartDate datetime,
	@dtEndDate datetime,
	@sStatus varchar(30) = null,
	@sRoleStatus varchar(30) = null
)
AS
BEGIN TRY

	IF (@dtEndDate IS NOT NULL)
	BEGIN
		SET @dtEndDate = DATEADD(dd,1,@dtEndDate)
	END

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
			ED.Dt_Joining_Date,
			ED.Dt_Resignation_Date,
			ED.Dt_DeactivationDate,
			ED.I_Status,
			Status= CASE 
					WHEN ED.I_Status=1 THEN 'NewlyJoined'
					--WHEN ED.I_Status IN(4,5) THEN 'Resigned'
					WHEN ED.I_Status=2 THEN 'Registered'
					WHEN ED.I_Status=3 THEN 'Active'
					WHEN ED.I_Status=6 THEN 'AdditionalRoleAssigned'
					WHEN ED.I_Status=4 THEN 'Deactivated'
					WHEN ED.I_Status=5 THEN 'Resigned'
					--ELSE 'JoinedButNotResigned'
					END,
			ED.Dt_Registration_Date,
			ED.S_Remarks,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain,
			RM.S_Role_Code,
			RM.S_Role_Desc,
			ERM.Dt_Crtd_On,
			URD.I_User_Role_Detail_ID,
			RoleStatus= CASE 
					WHEN URD.I_User_Role_Detail_ID IS NOT NULL THEN 'Approved'
					ELSE 'Pending'
					END,
			URD.Dt_Crtd_On AS Approval_Date
	   INTO #tmpApprovalStatus
	   FROM dbo.T_Employee_Dtls ED
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON ED.I_Centre_Id=FN1.CenterID
			INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
			INNER JOIN EOS.T_Employee_Role_Map ERM
				ON ED.I_Employee_ID=ERM.I_Employee_ID
			INNER JOIN dbo.T_Role_Master RM
				ON ERM.I_Role_ID=RM.I_Role_ID
			LEFT OUTER JOIN dbo.T_User_Master UM
				ON ED.I_Employee_ID=UM.I_Reference_ID
				AND UM.I_Status<>0
			LEFT OUTER JOIN dbo.T_User_Role_Details URD
				ON UM.I_User_ID=URD.I_User_ID
			   AND ERM.I_Role_ID=URD.I_Role_ID
	  WHERE ED.I_Status<>0
		AND ED.Dt_Joining_Date BETWEEN @dtStartDate AND @dtEndDate

	 SELECT * FROM #tmpApprovalStatus 
	  WHERE Status LIKE ISNULL(@sStatus,Status) + '%'
		AND RoleStatus LIKE ISNULL(@sRoleStatus,RoleStatus) + '%'
   ORDER BY InstanceChain,CenterName,S_First_Name,S_Middle_Name,S_Last_Name
	
	 DROP TABLE #tmpApprovalStatus

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
