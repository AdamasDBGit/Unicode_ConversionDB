CREATE PROCEDURE [REPORT].[uspGetStudentListingsDetailsReport]
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@sStatus varchar(50),
	@iCenterID int
)
AS
BEGIN TRY

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
				MIN(RH.Dt_Receipt_Date) as First_Payment_DT,
				MAX(RH.Dt_Receipt_Date) as Last_Payment_DT,				
				@sStatus
				
		   FROM dbo.T_Student_Detail SD
				INNER JOIN dbo.T_Student_Center_Detail SCEN
				ON SD.I_Student_Detail_ID=SCEN.I_Student_Detail_ID
				
				INNER JOIN dbo.T_Receipt_Header RH
				ON RH.I_Student_Detail_ID=SD.I_Student_Detail_ID

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
		  WHERE [REPORT].[fnGetStudentStatusForReports](SD.I_Student_Detail_ID,SCEN.I_Centre_Id,GETDATE()) = @sStatus
			AND SCEN.I_Centre_Id=@iCenterID
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
				MIN(RH.Dt_Receipt_Date) as First_Payment_DT,
				MAX(RH.Dt_Receipt_Date) as Last_Payment_DT,
				@sStatus
		   FROM dbo.T_Student_Detail SD
				INNER JOIN dbo.T_Student_Center_Detail SCEN
				ON SD.I_Student_Detail_ID=SCEN.I_Student_Detail_ID

				INNER JOIN dbo.T_Receipt_Header RH
				ON RH.I_Student_Detail_ID=SD.I_Student_Detail_ID

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
		  WHERE [REPORT].[fnGetStudentStatusForDefaulterReports](SD.I_Student_Detail_ID,SCEN.I_Centre_Id,GETDATE()) like '%'+ Replace(@sStatus,'DROPOUT','') +'%'
			AND SCEN.I_Centre_Id=@iCenterID
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
				

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
