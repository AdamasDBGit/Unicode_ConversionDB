/*******************************************************
Author	:     Arindam Roy
Date	:	  06/28/2007
Description : This SP retrieves the EProject Report Detail
				
*********************************************************/


CREATE PROCEDURE [REPORT].[uspGetEProjectReport] --68,1,'2006-01-01','2008-01-01'
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@dtStartDate datetime,
	@dtEndDate datetime,
	@iCourseID int=null,
	@sCourseName varchar(250) = null,
	@iTermID int=null,
	@sTermName varchar(250) = null,
	@iModuleID int=null,
	@sModuleName varchar(250) = null,
	@sStatus varchar(20)=null
)
AS
BEGIN TRY

DECLARE @EProjectRpt TABLE
	(
		I_Center_Id INT,
		I_Course_ID INT,
		I_Term_ID INT,
		I_Module_ID INT,
		I_Student_Detail_ID INT,
		I_Status INT,
		Status VARCHAR(50)
	)

	---- insert records having status as Allocation
	INSERT INTO @EProjectRpt
	 SELECT CEM.I_Center_ID,
			CEM.I_Course_ID,
			CEM.I_Term_ID,
			CEM.I_Module_ID,
			CEM.I_Student_Detail_ID,
			CEM.I_Status,
			Status = 'Allocation'
	   FROM ACADEMICS.T_Center_E_Project_Manual CEM
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON CEM.I_Center_ID=FN1.CenterID
			INNER JOIN ACADEMICS.T_E_Project_Group EPG
			ON EPG.I_E_Project_Group_ID = CEM.I_E_Project_Group_ID
			AND EPG.Dt_Project_Start_Date >= @dtStartDate 
			AND EPG.Dt_Project_Start_Date <= @dtEndDate
	  WHERE CEM.I_Course_ID=ISNULL(@iCourseID,CEM.I_Course_ID)
		AND	CEM.I_Term_ID=ISNULL(@iTermID,CEM.I_Term_ID)
		AND	CEM.I_Module_ID=ISNULL(@iModuleID,CEM.I_Module_ID)
		AND CEM.I_Status = 1
		
	-- Insert Record having status as Completion
	 INSERT INTO @EProjectRpt
	 SELECT CEM.I_Center_ID,
			CEM.I_Course_ID,
			CEM.I_Term_ID,
			CEM.I_Module_ID,
			CEM.I_Student_Detail_ID,
			CEM.I_Status,
			Status = 'Completion'
	   FROM ACADEMICS.T_Center_E_Project_Manual CEM
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON CEM.I_Center_ID=FN1.CenterID
	  WHERE CEM.I_Course_ID=ISNULL(@iCourseID,CEM.I_Course_ID)
		AND	CEM.I_Term_ID=ISNULL(@iTermID,CEM.I_Term_ID)
		AND	CEM.I_Module_ID=ISNULL(@iModuleID,CEM.I_Module_ID)
		AND CEM.I_Status = 2
		AND CEM.Dt_Upd_On >= @dtStartDate 
        AND CEM.Dt_Upd_On <= @dtEndDate

	-- Insert Record having status as Cancellation
	 INSERT INTO @EProjectRpt
	 SELECT CEM.I_Center_ID,
			CEM.I_Course_ID,
			CEM.I_Term_ID,
			CEM.I_Module_ID,
			CEM.I_Student_Detail_ID,
			CEM.I_Status,
			Status = 'Cancellation'
	   FROM ACADEMICS.T_Center_E_Project_Manual CEM
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON CEM.I_Center_ID=FN1.CenterID
	  WHERE CEM.I_Course_ID=ISNULL(@iCourseID,CEM.I_Course_ID)
		AND	CEM.I_Term_ID=ISNULL(@iTermID,CEM.I_Term_ID)
		AND	CEM.I_Module_ID=ISNULL(@iModuleID,CEM.I_Module_ID)
		AND CEM.I_Status = 3
		AND CEM.Dt_Upd_On >= @dtStartDate 
        AND CEM.Dt_Upd_On <= @dtEndDate

	-- Insert Record having status other than Allocation, Completion and Cancellation
	INSERT INTO @EProjectRpt
	 SELECT CEM.I_Center_ID,
			CEM.I_Course_ID,
			CEM.I_Term_ID,
			CEM.I_Module_ID,
			CEM.I_Student_Detail_ID,
			CEM.I_Status,
			Status = 'Registration'
	   FROM ACADEMICS.T_Center_E_Project_Manual CEM
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON CEM.I_Center_ID=FN1.CenterID
	  WHERE CEM.I_Course_ID=ISNULL(@iCourseID,CEM.I_Course_ID)
		AND	CEM.I_Term_ID=ISNULL(@iTermID,CEM.I_Term_ID)
		AND	CEM.I_Module_ID=ISNULL(@iModuleID,CEM.I_Module_ID)
		AND CEM.I_Status = 1
		AND CEM.Dt_Crtd_On >= @dtStartDate 
	    AND CEM.Dt_Crtd_On <= @dtEndDate

	-- Insert Record having status Registration
--	INSERT INTO @EProjectRpt
--	 SELECT I_Center_ID,
--			I_Course_ID,
--			I_Term_ID,
--			I_Module_ID,
--			I_Student_Detail_ID,
--			I_Status,
--			'Registration'
--	   FROM @EProjectRpt
--	  WHERE Status IN ('Completion','Allocation','Cancellation')

	 SELECT TMP.I_Center_ID,
			TMP.I_Course_ID,
			CM.S_Course_Code,
			CM.S_Course_Name,
			TMP.I_Term_ID,
			TM.S_Term_Code,
			TM.S_Term_Name,
			TMP.I_Module_ID,
			MM.S_Module_Code,
			MM.S_Module_Name,
			TCM.I_Sequence AS Term_Sequence,
			MTM.I_Sequence AS Module_Sequence,
			TMP.Status,
			COUNT(TMP.I_Student_Detail_ID) AS Student_Count,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain
	   FROM @EProjectRpt TMP
			INNER JOIN dbo.T_Course_Master CM
				ON TMP.I_Course_ID=CM.I_Course_ID
			INNER JOIN dbo.T_Term_Master TM
				ON TMP.I_Term_ID=TM.I_Term_ID
			INNER JOIN dbo.T_Module_Master MM
				ON TMP.I_Module_ID=MM.I_Module_ID
			INNER JOIN dbo.T_Term_Course_Map TCM
				ON TMP.I_Course_ID=TCM.I_Course_ID
				AND TMP.I_Term_ID=TCM.I_Term_ID
			INNER JOIN dbo.T_Module_Term_Map MTM
				ON TMP.I_Term_ID=MTM.I_Term_ID
				AND TMP.I_Module_ID=MTM.I_Module_ID
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON TMP.I_Center_ID=FN1.CenterID
			INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
	  WHERE Status LIKE ISNULL(@sStatus,Status)+'%'
   GROUP BY TMP.I_Center_ID,
			TMP.I_Course_ID,
			CM.S_Course_Code,
			CM.S_Course_Name,
			TMP.I_Term_ID,
			TM.S_Term_Code,
			TM.S_Term_Name,
			TMP.I_Module_ID,
			MM.S_Module_Code,
			MM.S_Module_Name,
			TCM.I_Sequence,
			MTM.I_Sequence,
			TMP.Status,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain
   ORDER BY FN2.InstanceChain,
			FN1.CenterName,
			CM.S_Course_Code,
			CM.S_Course_Name,
			TCM.I_Sequence,
			MTM.I_Sequence,
			TMP.Status

--	DROP TABLE #tmpEProjectRpt2
	
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
