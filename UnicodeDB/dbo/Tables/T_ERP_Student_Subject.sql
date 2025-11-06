CREATE TABLE [dbo].[T_ERP_Student_Subject] (
    [I_Student_Subject_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID]  INT      NOT NULL,
    [I_School_Session_ID]  INT      NOT NULL,
    [I_School_Group_ID]    INT      NULL,
    [I_Class_ID]           INT      NOT NULL,
    [I_Subject_ID]         INT      NOT NULL,
    [I_CreatedBy]          INT      NOT NULL,
    [Dt_CreatedAt]         DATETIME NULL
);


GO
CREATE NONCLUSTERED INDEX [nci_student_detail_id]
    ON [dbo].[T_ERP_Student_Subject]([I_Student_Detail_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [nci_i_subject_id]
    ON [dbo].[T_ERP_Student_Subject]([I_Subject_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [nci_school_group_id]
    ON [dbo].[T_ERP_Student_Subject]([I_School_Group_ID] ASC);

