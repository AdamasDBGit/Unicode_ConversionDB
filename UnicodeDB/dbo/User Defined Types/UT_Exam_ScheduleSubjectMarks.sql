CREATE TYPE [dbo].[UT_Exam_ScheduleSubjectMarks] AS TABLE (
    [inExamScheduleSubjectAttendanceMarksId] INT             NULL,
    [inExamScheduleSubjectDetailId]          INT             NULL,
    [inExamScheduleDetailId]                 INT             NULL,
    [inSubjectId]                            INT             NULL,
    [inStudentId]                            INT             NULL,
    [inPaperStatus]                          INT             NULL,
    [dcStudentMarks]                         DECIMAL (10, 2) NULL,
    [inConduct]                              INT             NULL,
    [stRemarks]                              NVARCHAR (300)  NULL,
    [inCreatedBy]                            INT             NULL);

