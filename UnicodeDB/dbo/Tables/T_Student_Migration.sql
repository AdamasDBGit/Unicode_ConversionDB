CREATE TABLE [dbo].[T_Student_Migration] (
    [I_Student_Migration_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Student_Detail_ID]    INT            NULL,
    [I_Prev_Course_ID]       INT            NULL,
    [I_Present_Course_ID]    INT            NULL,
    [S_Crtd_By]              NVARCHAR (MAX) NULL,
    [S_Upd_By]               NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]             DATETIME       NULL,
    [Dt_Upd_On]              DATETIME       NULL,
    CONSTRAINT [PK_T_Student_Migration] PRIMARY KEY CLUSTERED ([I_Student_Migration_ID] ASC)
);

