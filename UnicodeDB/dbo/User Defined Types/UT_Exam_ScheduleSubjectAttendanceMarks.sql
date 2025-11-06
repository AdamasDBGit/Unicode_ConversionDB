CREATE TYPE [dbo].[UT_Exam_ScheduleSubjectAttendanceMarks] AS TABLE (
    [inExamScheduleSubjectAttendanceMarksId] INT            NULL,
    [inExamScheduleSubjectDetailId]          INT            NULL,
    [inExamScheduleDetailId]                 INT            NULL,
    [inPresent]                              INT            NULL,
    [inSubjectId]                            INT            NULL,
    [inCreatedBy]                            INT            NULL,
    [inStudentId]                            INT            NULL,
    [inPaperStatus]                          INT            NULL,
    [stRemarks]                              NVARCHAR (MAX) NULL);

