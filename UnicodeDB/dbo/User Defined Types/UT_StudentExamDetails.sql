CREATE TYPE [dbo].[UT_StudentExamDetails] AS TABLE (
    [ExamScheduleSubjectAttendanceMarksId] INT            NULL,
    [StudentDetailId]                      INT            NOT NULL,
    [Status]                               INT            NOT NULL,
    [Remark]                               NVARCHAR (MAX) NULL,
    [PaperStatus]                          INT            NOT NULL);

