CREATE PROCEDURE [REPORT].[uspGetStudentListingsReport] --'84',22,'ALL'
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@sStatus varchar(50)
)
AS
BEGIN TRY

DECLARE @CurrentDate DATETIME
SET @CurrentDate=CAST(SUBSTRING(CAST(GETDATE() AS VARCHAR),1,11) as datetime)

	IF @sStatus ='ALL'
	BEGIN
select t.*  into #TmpStudentListing from (
		 SELECT SD.I_Student_Detail_ID,
			    SD.S_Student_ID,
				SD.S_Title,
			    SD.S_First_Name,
			    SD.S_Middle_Name,
			    SD.S_Last_Name,
				CM.S_Course_Code,
				CM.S_Course_Name,
				SCEN.I_Centre_Id,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain,
				MIN(SAD.Dt_Attendance_Date) as First_Attendance_DT,
				MAX(SAD.Dt_Attendance_Date) as Last_Attendance_DT,
				[REPORT].[fnGetStudentStatusForReports](SD.I_Student_Detail_ID,SCEN.I_Centre_Id,@CurrentDate) AS Student_Status

		   FROM dbo.T_Student_Detail SD
				INNER JOIN dbo.T_Student_Center_Detail SCEN
				ON SD.I_Student_Detail_ID=SCEN.I_Student_Detail_ID
				INNER JOIN dbo.T_Student_Course_Detail SCRS
				ON SD.I_Student_Detail_ID=SCRS.I_Student_Detail_ID
				INNER JOIN dbo.T_Course_Master CM
				ON SCRS.I_Course_ID=CM.I_Course_ID
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON SCEN.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
				LEFT OUTER JOIN dbo.T_Student_Attendance_Details SAD
				ON SD.I_Student_Detail_ID=SAD.I_Student_Detail_ID
				AND SCEN.I_Centre_Id=SAD.I_Centre_Id
				AND SCRS.I_Course_ID=SAD.I_Course_ID
			WHERE [SD].[I_Student_Detail_ID] NOT IN 
			(SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM)
	   GROUP BY SD.I_Student_Detail_ID,
			    SD.S_Student_ID,
				SD.S_Title,
			    SD.S_First_Name,
			    SD.S_Middle_Name,
			    SD.S_Last_Name,
				CM.S_Course_Code,
				CM.S_Course_Name,
				SCEN.I_Centre_Id,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain
				--[REPORT].[fnGetStudentStatusForReports](SD.I_Student_Detail_ID,SCEN.I_Centre_Id,@CurrentDate)
union 

SELECT SD.I_Student_Detail_ID,
			    SD.S_Student_ID,
				SD.S_Title,
			    SD.S_First_Name,
			    SD.S_Middle_Name,
			    SD.S_Last_Name,
				CM.S_Course_Code,
				CM.S_Course_Name,
				SCEN.I_Centre_Id,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain,
				MIN(SAD.Dt_Attendance_Date) as First_Attendance_DT,
				MAX(SAD.Dt_Attendance_Date) as Last_Attendance_DT,
				--[REPORT].[fnGetStudentStatusForDefaulterReports](SD.I_Student_Detail_ID,SCEN.I_Centre_Id,@CurrentDate) AS Student_Status
		   'FINANCIALDROPOUT'
		   FROM dbo.T_Student_Detail SD
				INNER JOIN dbo.T_Student_Center_Detail SCEN
				ON SD.I_Student_Detail_ID=SCEN.I_Student_Detail_ID
				INNER JOIN dbo.T_Student_Course_Detail SCRS
				ON SD.I_Student_Detail_ID=SCRS.I_Student_Detail_ID
				INNER JOIN dbo.T_Course_Master CM
				ON SCRS.I_Course_ID=CM.I_Course_ID
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON SCEN.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
				LEFT OUTER JOIN dbo.T_Student_Attendance_Details SAD
				ON SD.I_Student_Detail_ID=SAD.I_Student_Detail_ID
				AND SCEN.I_Centre_Id=SAD.I_Centre_Id
				AND SCRS.I_Course_ID=SAD.I_Course_ID
WHERE [REPORT].[fnGetStudentStatusForDefaulterReports](SD.I_Student_Detail_ID,SCEN.I_Centre_Id,@CurrentDate) LIKE '%FINANCIAL%'
	   AND [SD].[I_Student_Detail_ID] NOT IN 
			(SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM)
	   GROUP BY SD.I_Student_Detail_ID,
			    SD.S_Student_ID,
				SD.S_Title,
			    SD.S_First_Name,
			    SD.S_Middle_Name,
			    SD.S_Last_Name,
				CM.S_Course_Code,
				CM.S_Course_Name,
				SCEN.I_Centre_Id,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain
				--[REPORT].[fnGetStudentStatusForReports](SD.I_Student_Detail_ID,SCEN.I_Centre_Id,@CurrentDate)

union 

SELECT SD.I_Student_Detail_ID,
			    SD.S_Student_ID,
				SD.S_Title,
			    SD.S_First_Name,
			    SD.S_Middle_Name,
			    SD.S_Last_Name,
				CM.S_Course_Code,
				CM.S_Course_Name,
				SCEN.I_Centre_Id,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain,
				MIN(SAD.Dt_Attendance_Date) as First_Attendance_DT,
				MAX(SAD.Dt_Attendance_Date) as Last_Attendance_DT,
				--[REPORT].[fnGetStudentStatusForDefaulterReports](SD.I_Student_Detail_ID,SCEN.I_Centre_Id,@CurrentDate) AS Student_Status
		   'OTHERDROPOUT'
		   FROM dbo.T_Student_Detail SD
				INNER JOIN dbo.T_Student_Center_Detail SCEN
				ON SD.I_Student_Detail_ID=SCEN.I_Student_Detail_ID
				INNER JOIN dbo.T_Student_Course_Detail SCRS
				ON SD.I_Student_Detail_ID=SCRS.I_Student_Detail_ID
				INNER JOIN dbo.T_Course_Master CM
				ON SCRS.I_Course_ID=CM.I_Course_ID
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON SCEN.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
				LEFT OUTER JOIN dbo.T_Student_Attendance_Details SAD
				ON SD.I_Student_Detail_ID=SAD.I_Student_Detail_ID
				AND SCEN.I_Centre_Id=SAD.I_Centre_Id
				AND SCRS.I_Course_ID=SAD.I_Course_ID
WHERE [REPORT].[fnGetStudentStatusForDefaulterReports](SD.I_Student_Detail_ID,SCEN.I_Centre_Id,@CurrentDate) LIKE '%OTHER%'
	   AND [SD].[I_Student_Detail_ID] NOT IN 
			(SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM)
	   GROUP BY SD.I_Student_Detail_ID,
			    SD.S_Student_ID,
				SD.S_Title,
			    SD.S_First_Name,
			    SD.S_Middle_Name,
			    SD.S_Last_Name,
				CM.S_Course_Code,
				CM.S_Course_Name,
				SCEN.I_Centre_Id,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain
				--[REPORT].[fnGetStudentStatusForReports](SD.I_Student_Detail_ID,SCEN.I_Centre_Id,@CurrentDate)

) T

		 SELECT I_Centre_Id,
				CenterCode,
				CenterName,
				InstanceChain,
				Student_Status,
				COUNT(DISTINCT I_Student_Detail_ID) AS Student_Number
		   FROM #TmpStudentListing
	   GROUP BY I_Centre_Id,
				CenterCode,
				CenterName,
				InstanceChain,
				Student_Status
	   ORDER BY InstanceChain,CenterName,Student_Status
		DROP TABLE #TmpStudentListing	


	END
	ELSE
	BEGIN
		 SELECT SD.I_Student_Detail_ID,
			    SD.S_Student_ID,
				SD.S_Title,
			    SD.S_First_Name,
			    SD.S_Middle_Name,
			    SD.S_Last_Name,
				CM.S_Course_Code,
				CM.S_Course_Name,
				SCEN.I_Centre_Id,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain,
				MIN(SAD.Dt_Attendance_Date) as First_Attendance_DT,
				MAX(SAD.Dt_Attendance_Date) as Last_Attendance_DT,
				[REPORT].[fnGetStudentStatusForReports](SD.I_Student_Detail_ID,SCEN.I_Centre_Id,@CurrentDate) AS Student_Status
		   INTO #TmpStudentListing1
		   FROM dbo.T_Student_Detail SD
				INNER JOIN dbo.T_Student_Center_Detail SCEN
				ON SD.I_Student_Detail_ID=SCEN.I_Student_Detail_ID
				INNER JOIN dbo.T_Student_Course_Detail SCRS
				ON SD.I_Student_Detail_ID=SCRS.I_Student_Detail_ID
				INNER JOIN dbo.T_Course_Master CM
				ON SCRS.I_Course_ID=CM.I_Course_ID
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON SCEN.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
				LEFT OUTER JOIN dbo.T_Student_Attendance_Details SAD
				ON SD.I_Student_Detail_ID=SAD.I_Student_Detail_ID
				AND SCEN.I_Centre_Id=SAD.I_Centre_Id
				AND SCRS.I_Course_ID=SAD.I_Course_ID
		  WHERE [REPORT].[fnGetStudentStatusForReports](SD.I_Student_Detail_ID,SCEN.I_Centre_Id,@CurrentDate) = @sStatus
		  AND [SD].[I_Student_Detail_ID] NOT IN 
			(SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM)
	   GROUP BY SD.I_Student_Detail_ID,
			    SD.S_Student_ID,
				SD.S_Title,
			    SD.S_First_Name,
			    SD.S_Middle_Name,
			    SD.S_Last_Name,
				CM.S_Course_Code,
				CM.S_Course_Name,
				SCEN.I_Centre_Id,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain
				--[REPORT].[fnGetStudentStatusForReports](SD.I_Student_Detail_ID,SCEN.I_Centre_Id,@CurrentDate)


		 SELECT I_Centre_Id,
				CenterCode,
				CenterName,
				InstanceChain,
				Student_Status,
				COUNT(DISTINCT I_Student_Detail_ID) AS Student_Number
		   FROM #TmpStudentListing1
	   GROUP BY I_Centre_Id,
				CenterCode,
				CenterName,
				InstanceChain,
				Student_Status
	   ORDER BY InstanceChain,CenterName,Student_Status
	
		DROP TABLE #TmpStudentListing1	


	END 

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
