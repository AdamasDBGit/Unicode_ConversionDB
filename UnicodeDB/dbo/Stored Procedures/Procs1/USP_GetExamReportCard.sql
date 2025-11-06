CREATE PROCEDURE [dbo].[USP_GetExamReportCard]  
(  
    @inExamScheduleDetailId INT = NULL,  
    @inStudentId INT = NULL  
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    SELECT   
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' ' + TSD.S_Last_Name AS StudentName,  
  TSD.S_Student_ID StudentID,  
  TSG.S_School_Group_Code SchoolGroupCode,  
        TEESA.inExamScheduleDetailId,  
        TEESA.inStudentId StudentId,  
        TEESA.inSubjectId SubjectId,  
        TSM.S_Subject_Name AS SubjectName,  
        TEESA.dcObtainedMarks ObtainedMarks,  
  TEESSD.dcFullMarks,  
        TEESSD.inSubjectComponentID,  
        TESC.S_Subject_Component_Name AS SubjectComponentName,  
        TEESSD.inSubjectTypeID,  
        TST.S_Subject_Type AS SubjectType,  
        TS.S_Section_Name AS Section,  
        TSS.S_Stream AS Stream,  
        TEES.stExamName AS ExamName,  
        TSASM.S_Label AS SessionName,  
        TBM.S_Brand_Name AS BrandName,  
        TESPCH.N_Value AS BrandLogo,  
  TC.S_Class_Name Class,  
  TEESA.sReportCardUrl,  
  TEES.inReportCardTemplateId,  
  TEACACT.stTemplatePath  
    FROM T_ERP_Exam_ScheduleSubjectAttendanceMarks TEESA  
    INNER JOIN T_Subject_Master TSM ON TSM.I_Subject_ID = TEESA.inSubjectId  
    INNER JOIN T_ERP_Exam_ScheduleSubjectDetails TEESSD ON TEESSD.inExamScheduleSubjectDetailId = TEESA.inExamScheduleSubjectDetailId  
    INNER JOIN T_ERP_Exam_SchedulesDetails TEES ON TEES.inExamScheduleDetailId = TEESSD.inExamScheduleDetailId  
    INNER JOIN T_Brand_Master TBM ON TBM.I_Brand_ID = TEES.inBrandId  
    INNER JOIN T_School_Academic_Session_Master TSASM ON TSASM.I_School_Session_ID = TEES.inAcademicSessionId  
 LEFT JOIN T_ERP_AdmitCardAndReportCardTemplate TEACACT ON TEACACT.inAdmitCardAndReportCardTemplateId=TEES.inReportCardTemplateId  
    LEFT JOIN T_ERP_Subject_Component TESC ON TESC.I_Subject_Component_ID = TEESSD.inSubjectComponentID  
    LEFT JOIN T_Subject_Type TST ON TST.I_Subject_Type_ID = TEESSD.inSubjectTypeID  
    LEFT JOIN T_Student_Detail TSD ON TSD.I_Student_Detail_ID = TEESA.inStudentId  
    LEFT JOIN T_Section TS ON TS.I_Section_ID = TEESSD.inSectionId  
    LEFT JOIN T_Stream TSS ON TSS.I_Stream_ID = TEESSD.inStreamId  
 LEFT JOIN T_Class TC ON TC.I_Class_ID=TEESSD.inClassId  
    INNER JOIN T_ERP_Saas_Pattern_Header TESPH ON TESPH.I_Brand_ID = TEES.inBrandId AND TESPH.S_Property_Name = 'BRAND_LOGO'  
    INNER JOIN T_ERP_Saas_Pattern_Child_Header TESPCH ON TESPCH.I_Pattern_HeaderID = TESPH.I_Pattern_HeaderID  
 INNER JOIN T_School_Group TSG ON TSG.I_School_Group_ID=TEES.inSchoolProgramId  
    WHERE TEESA.inExamScheduleDetailId = ISNULL(@inExamScheduleDetailId, TEESA.inExamScheduleDetailId)  
      AND TEESA.inStudentId = ISNULL(@inStudentId, TEESA.inStudentId);  
END;  