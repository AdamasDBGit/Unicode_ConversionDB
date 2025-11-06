CREATE TYPE [dbo].[UT_Student_Buzzed] AS TABLE (
    [student_erp_id]    VARCHAR (20) NOT NULL,
    [buzzed_student_id] INT          NULL,
    [erp_parent_id]     INT          NULL,
    [buzzed_parent_id]  INT          NULL);

