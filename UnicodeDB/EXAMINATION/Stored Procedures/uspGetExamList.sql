/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP will retrieve all the Exam details subject to some search criteria
Parameters  : CenterId,CourseId,TermId,ModuleId
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspGetExamList]
	(
		@iCenterID INT=NULL,
		@iCourseID INT=NULL,
		@iTermID INT=NULL,
		@iModuleID INT=NULL,
		@dtFromDate DATETIME = NULL,
		@dtToDate DATETIME = NULL,
		@dtCurrentDate DATETIME = NULL
	)
AS

BEGIN
	SET NOCOUNT ON;	
	
	SELECT TED.I_Exam_ID,
		   TED.I_Exam_Component_ID,
		   TECM.S_Component_Name,		   
		   TED.I_Centre_Id,
		   TCEM.S_Center_Name,
		   TCEM.S_Center_Code,
		   TED.Dt_Exam_Date,
		   TED.Dt_Exam_Start_Time,
		   TED.Dt_Exam_End_Time,
		   EXAMINATION.fnGetNoOfStudents(TED.I_Exam_ID)AS I_No_Of_Students,
		   TED.I_Course_ID,
		   TCRM.S_Course_Code,
		   TCRM.S_Course_Name,
		   TED.I_Term_ID,
		   TTM.S_Term_Code,
		   TTM.S_Term_Name,
		   ISNULL(TED.I_Module_ID,0) AS I_Module_ID ,
		   ISNULL(TMM.S_Module_Code,'NA')AS S_Module_Code,
		   ISNULL(TMM.S_Module_Name,'NA') AS S_Module_Name,
		   TED.S_Exam_Venue,
		   TED.Dt_Registration_Date,
		   TED.S_Registration_No,
		   TED.I_Agency_ID,
		   TED.S_Invigilator_Name,
		   TED.S_Identification_Doc_Type,
		   ISNULL(TED.S_Reason,'NA') AS S_Reason,
		   TED.I_Status_ID,
		   TED.Dt_Crtd_On,
		   TED.S_Crtd_By,
		   TED.Dt_Upd_On,
		   TED.S_Upd_By
	FROM EXAMINATION.T_Examination_Detail TED
	INNER JOIN dbo.T_Exam_Component_Master TECM
	ON TED.I_Exam_Component_ID=TECM.I_Exam_Component_ID
	INNER JOIN dbo.T_Centre_Master TCEM
	ON TED.I_Centre_Id=TCEM.I_Centre_Id
	INNER JOIN dbo.T_Course_Master TCRM
	ON TED.I_Course_ID=TCRM.I_Course_ID
	INNER JOIN dbo.T_Term_Master TTM
	ON TED.I_Term_ID=TTM.I_Term_ID
	LEFT OUTER JOIN dbo.T_Module_Master TMM
	ON TED.I_Module_ID=TMM.I_Module_ID
	 --TED.I_Status_ID<>3 --retrieve only for status not cancelled
    WHERE TED.I_Centre_Id=ISNULL(@iCenterID,TED.I_Centre_Id)
	AND TED.I_Course_ID=ISNULL(@iCourseID,TED.I_Course_ID)
	AND TED.I_Term_ID=ISNULL(@iTermID,TED.I_Term_ID)
	AND TED.I_Module_ID=ISNULL(@iModuleID,TED.I_Module_ID)
	AND DATEDIFF(dd, ISNULL(@dtFromDate,TED.Dt_Exam_Date), TED.Dt_Exam_Date) >= 0
	AND DATEDIFF(dd, ISNULL(@dtToDate,TED.Dt_Exam_Date), TED.Dt_Exam_Date) <= 0
	AND DATEDIFF(dd, ISNULL(@dtCurrentDate,TED.Dt_Exam_Date), TED.Dt_Exam_Date) >= 0
END
