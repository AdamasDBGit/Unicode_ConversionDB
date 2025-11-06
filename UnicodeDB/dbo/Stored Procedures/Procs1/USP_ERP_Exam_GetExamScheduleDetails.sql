CREATE PROCEDURE [dbo].[USP_ERP_Exam_GetExamScheduleDetails]
(
	@unExamScheduleDetailId UNIQUEIDENTIFIER
)
AS
BEGIN
	SELECT 
		SD.inExamScheduleDetailId,
		SD.unExamScheduleDetailId,
		SD.stExamName,
		SC.I_School_Group_ID AS  inSchoolGroupID,
		SC.S_School_Group_Name AS stSchoolProgram,
		SD.inAcademicSessionId AS inSessionID,
		SD.inExamTypeId,
		ETM.stExamTypeName,
		ETM.IsMainExam,
		SD.inExamCategoryId,
		ECM.stExamCategoryName,
		SD.inExamGradeID,
		EGM.stGradeHederName AS stExamGradeName,
		SD.inMarksEntryStartAfterExamDays,
		SD.inMarksEntryCloseDays,
		SD.inSaveType,
		SD.inInternalExamWeightage,
		SD.inMainInternalExamWeightage,
		SD.inTotalWeightage
	FROM T_ERP_Exam_SchedulesDetails SD
		LEFT JOIN T_School_Group SC ON SC.I_School_Group_ID = SD.inSchoolProgramId
		LEFT JOIN T_ERP_Exam_Type_Master ETM ON ETM.inExamTypeID = SD.inExamTypeId
		LEFT JOIN T_ERP_Exam_Category ECM ON ECM.inExamCategoryId = SD.inExamCategoryId
		LEFT JOIN T_ERP_Exam_Grade_Master_Header EGM ON EGM.inExamGradeHederId = SD.inGradingSchemeId 
	WHERE
		SD.unExamScheduleDetailId = @unExamScheduleDetailId		
END