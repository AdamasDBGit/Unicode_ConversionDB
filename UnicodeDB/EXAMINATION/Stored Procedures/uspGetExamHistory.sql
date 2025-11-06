/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP will retrieve the last cancellation date for an exam pertaining to some search criteria
Parameters  : CenterId,CourseId,TermId,ModuleId
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspGetExamHistory]
	(
		@iCenterID INT=NULL,
		@iCourseID INT=NULL,
		@iTermID INT=NULL,
		@iModuleID INT=NULL		
	)
AS

BEGIN
	SET NOCOUNT ON;	
	SELECT TEA.I_Exam_ID,
		   TEA.I_Centre_Id,
		   TCEM.S_Center_Name,
		   TCEM.S_Center_Code,
		   TEA.Dt_Exam_Date,
		   TEA.Dt_Exam_Start_Time,
		   TEA.Dt_Exam_End_Time,
		   EXAMINATION.fnGetNoOfStudents(TEA.I_Exam_ID)AS I_No_Of_Students,
		   TEA.I_Course_ID,
		   TCRM.S_Course_Code,
		   TCRM.S_Course_Name,
		   TEA.I_Term_ID,
		   TTM.S_Term_Code,
		   TTM.S_Term_Name,
		   ISNULL(TEA.I_Module_ID,0) AS I_Module_ID ,
		   ISNULL(TMM.S_Module_Code,'NA')AS S_Module_Code,
		   ISNULL(TMM.S_Module_Name,'NA') AS S_Module_Name,
		   TEA.S_Exam_Venue,
		   TEA.I_Status_ID,		   
		   TEA.I_Exam_Component_ID,
		   TEA.Dt_Registration_Date,
		   TEA.S_Registration_No,
		   TEA.I_Agency_ID,
		   TEA.S_Invigilator_Name,
		   TEA.S_Identification_Doc_Type,
		   ISNULL(TEA.S_Reason,'NA') AS S_Reason,
		   TEA.Dt_Crtd_On,
		   TEA.S_Crtd_By,
		   TEA.Dt_Upd_On,
		   TEA.S_Upd_By
	FROM EXAMINATION.T_Examination_Audit TEA WITH(NOLOCK)
	INNER JOIN dbo.T_Centre_Master TCEM
	ON TEA.I_Centre_Id=TCEM.I_Centre_Id
	INNER JOIN dbo.T_Course_Master TCRM
	ON TEA.I_Course_ID=TCRM.I_Course_ID
	INNER JOIN dbo.T_Term_Master TTM
	ON TEA.I_Term_ID=TTM.I_Term_ID
	LEFT OUTER JOIN dbo.T_Module_Master TMM
	ON TEA.I_Module_ID=TMM.I_Module_ID
	WHERE  TEA.I_Centre_Id=ISNULL(@iCenterID,TEA.I_Centre_Id)
	AND TEA.I_Course_ID=ISNULL(@iCourseID,TEA.I_Course_ID)
	AND TEA.I_Term_ID=ISNULL(@iTermID,TEA.I_Term_ID)
	AND TEA.I_Module_ID=ISNULL(@iModuleID,TEA.I_Module_ID)		
		
	UNION
	
	SELECT TED.I_Exam_ID,
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
		   TED.I_Status_ID,
		   TED.I_Exam_Component_ID,
		   TED.Dt_Registration_Date,
		   TED.S_Registration_No,
		   TED.I_Agency_ID,
		   TED.S_Invigilator_Name,
		   TED.S_Identification_Doc_Type,
		   ISNULL(TED.S_Reason,'NA') AS S_Reason,
		   TED.Dt_Crtd_On,
		   TED.S_Crtd_By,
		   TED.Dt_Upd_On,
		   TED.S_Upd_By
	FROM EXAMINATION.T_Examination_Detail TED WITH(NOLOCK)		
	INNER JOIN dbo.T_Centre_Master TCEM
	ON TED.I_Centre_Id=TCEM.I_Centre_Id
	INNER JOIN dbo.T_Course_Master TCRM
	ON TED.I_Course_ID=TCRM.I_Course_ID
	INNER JOIN dbo.T_Term_Master TTM
	ON TED.I_Term_ID=TTM.I_Term_ID
	LEFT OUTER JOIN dbo.T_Module_Master TMM
	ON TED.I_Module_ID=TMM.I_Module_ID
	WHERE  TED.I_Centre_Id=ISNULL(@iCenterID,TED.I_Centre_Id)
	AND TED.I_Course_ID=ISNULL(@iCourseID,TED.I_Course_ID)
	AND TED.I_Term_ID=ISNULL(@iTermID,TED.I_Term_ID)
	AND TED.I_Module_ID=ISNULL(@iModuleID,TED.I_Module_ID)	
	AND TED.I_Status_ID<>3 --Retrieve only not cancelled status

	ORDER BY Dt_Upd_On
END
