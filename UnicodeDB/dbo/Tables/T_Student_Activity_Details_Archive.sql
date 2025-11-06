CREATE TABLE [dbo].[T_Student_Activity_Details_Archive] (
    [I_Student_Activity_ID] INT            NOT NULL,
    [I_Student_Detail_ID]   INT            NOT NULL,
    [I_Batch_ID]            INT            NOT NULL,
    [I_Activity_ID]         INT            NOT NULL,
    [I_Status]              INT            NULL,
    [S_Crtd_By]             NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]            DATETIME       NULL,
    [S_Updt_By]             NVARCHAR (MAX) NULL,
    [Dt_Updt_On]            DATETIME       NULL,
    [I_Employee_ID]         INT            NULL
);

