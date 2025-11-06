/*******************************************************
Author	:     Arindam Roy
Date	:	  06/27/2007
Description : This SP retrieves the Student Marks Report Detail
				
*********************************************************/


CREATE PROCEDURE [REPORT].[uspGetStudentsMarksReport] 
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
	@iTopStudentNo int=null,
	@iMarksRangeFrom int,
	@iMarksRangeTo int
)
AS
BEGIN TRY
	IF (@iModuleID IS NULL OR @iModuleID=0)
	BEGIN
		 SELECT DISTINCT TOP(@iTopStudentNo)
				tscd.I_Centre_Id,
				tbem.I_Exam_Component_ID,
				ECM.S_Component_Name,
				SM.Dt_Exam_Date,
				tsbm.I_Course_ID,
				CM.S_Course_Code,
				CM.S_Course_Name,
				tbem.I_Term_ID,
				TM.S_Term_Code,
				TM.S_Term_Name,
				tbem.I_Module_ID,
				S_Module_Code='',
				S_Module_Name='',
				TCM.I_Sequence AS Term_Sequence,
				Module_Sequence=1,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain,
				SM.I_Student_Detail_ID,
				SM.I_Exam_Total,
				SD.S_Student_ID,
				SD.S_Title,
				SD.S_First_Name,
				SD.S_Middle_Name,
				SD.S_Last_Name

		   FROM	EXAMINATION.T_Batch_Exam_Map AS tbem
				INNER JOIN dbo.T_Exam_Component_Master ECM
					ON tbem.I_Exam_Component_ID=ECM.I_Exam_Component_ID
				INNER JOIN dbo.T_Student_Batch_Master AS tsbm
					ON tbem.I_Batch_ID = tsbm.I_Batch_ID
				INNER JOIN dbo.T_Course_Master CM
					ON tsbm.I_Course_ID=CM.I_Course_ID
				INNER JOIN dbo.T_Term_Master TM
					ON tbem.I_Term_ID=TM.I_Term_ID
				INNER JOIN dbo.T_Term_Course_Map TCM
					ON tsbm.I_Course_ID=TCM.I_Course_ID
					AND tbem.I_Term_ID=TCM.I_Term_ID
				INNER JOIN EXAMINATION.T_Student_Marks SM
					ON tbem.I_Batch_Exam_ID = SM.I_Batch_Exam_ID
				INNER JOIN dbo.T_Student_Detail SD
					ON SM.I_Student_Detail_ID=SD.I_Student_Detail_ID
				INNER JOIN dbo.T_Student_Center_Detail AS tscd
					ON SD.I_Student_Detail_ID = tscd.I_Student_Detail_ID
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
					ON tscd.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
					ON FN1.HierarchyDetailID=FN2.HierarchyDetailID				
		  WHERE SM.Dt_Exam_Date BETWEEN @dtStartDate AND @dtEndDate
			AND tsbm.I_Course_ID =ISNULL(@iCourseID,tsbm.I_Course_ID)    
			AND tbem.I_Term_ID =ISNULL(@iTermID,tbem.I_Term_ID)
			AND (tbem.I_Module_ID =0 OR tbem.I_Module_ID IS NULL)
			AND SM.I_Exam_Total>=@iMarksRangeFrom
			AND SM.I_Exam_Total<=@iMarksRangeTo

	   ORDER BY 
	            SD.S_Student_ID,
				SM.I_Exam_Total DESC,
				FN1.CenterName,
				CM.S_Course_Code,
				CM.S_Course_Name,
				TCM.I_Sequence,
				ECM.S_Component_Name,
				SM.Dt_Exam_Date
	END
	ELSE
	BEGIN
		 SELECT DISTINCT TOP(@iTopStudentNo)
				tscd.I_Centre_Id,
				tbem.I_Exam_Component_ID,
				ECM.S_Component_Name,
				SM.Dt_Exam_Date,
				tsbm.I_Course_ID,
				CM.S_Course_Code,
				CM.S_Course_Name,
				tbem.I_Term_ID,
				TM.S_Term_Code,
				TM.S_Term_Name,
				tbem.I_Module_ID,
				MM.S_Module_Code,
				MM.S_Module_Name,
				TCM.I_Sequence AS Term_Sequence,
				MTM.I_Sequence AS Module_Sequence,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain,
				SM.I_Student_Detail_ID,
				SM.I_Exam_Total,
				SD.S_Student_ID,
				SD.S_Title,
				SD.S_First_Name,
				SD.S_Middle_Name,
				SD.S_Last_Name
			FROM	EXAMINATION.T_Batch_Exam_Map AS tbem
				INNER JOIN dbo.T_Exam_Component_Master ECM
					ON tbem.I_Exam_Component_ID=ECM.I_Exam_Component_ID
				INNER JOIN dbo.T_Student_Batch_Master AS tsbm
					ON tbem.I_Batch_ID = tsbm.I_Batch_ID
				INNER JOIN dbo.T_Course_Master CM
					ON tsbm.I_Course_ID=CM.I_Course_ID
				INNER JOIN dbo.T_Term_Master TM
					ON tbem.I_Term_ID=TM.I_Term_ID
				INNER JOIN dbo.T_Term_Course_Map TCM
					ON tsbm.I_Course_ID=TCM.I_Course_ID
					AND tbem.I_Term_ID=TCM.I_Term_ID
				INNER JOIN dbo.T_Module_Term_Map MTM
					ON tbem.I_Term_ID=MTM.I_Term_ID
					AND tbem.I_Module_ID=MTM.I_Module_ID
				INNER JOIN dbo.T_Module_Master AS MM
					ON MTM.I_Module_ID = MM.I_Module_ID
				INNER JOIN EXAMINATION.T_Student_Marks SM
					ON tbem.I_Batch_Exam_ID = SM.I_Batch_Exam_ID
				INNER JOIN dbo.T_Student_Detail SD
					ON SM.I_Student_Detail_ID=SD.I_Student_Detail_ID
				INNER JOIN dbo.T_Student_Center_Detail AS tscd
					ON SD.I_Student_Detail_ID = tscd.I_Student_Detail_ID
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
					ON tscd.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
					ON FN1.HierarchyDetailID=FN2.HierarchyDetailID	
		  WHERE SM.Dt_Exam_Date BETWEEN @dtStartDate AND @dtEndDate
			AND tsbm.I_Course_ID =ISNULL(@iCourseID,tsbm.I_Course_ID)    
			AND tbem.I_Term_ID =ISNULL(@iTermID,tbem.I_Term_ID)
			AND tbem.I_Module_ID =ISNULL(@iModuleID,tbem.I_Module_ID)
			AND SM.I_Exam_Total>=@iMarksRangeFrom
			AND SM.I_Exam_Total<=@iMarksRangeTo

	   ORDER BY SM.I_Exam_Total DESC,
				FN1.CenterName,
				CM.S_Course_Code,
				CM.S_Course_Name,
				TCM.I_Sequence,
				MTM.I_Sequence,
				ECM.S_Component_Name,
				SM.Dt_Exam_Date
	END	
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
