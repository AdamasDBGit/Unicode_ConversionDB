CREATE TABLE [dbo].[T_Student_Center_Detail] (
    [I_Student_Detail_ID] INT            NOT NULL,
    [I_Centre_Id]         INT            NOT NULL,
    [Dt_Valid_From]       DATETIME       NULL,
    [Dt_Valid_To]         DATETIME       NULL,
    [I_Status]            INT            NULL,
    [S_Crtd_By]           NVARCHAR (MAX) NULL,
    [S_Upd_By]            NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]          DATETIME       NULL,
    [Dt_Upd_On]           DATETIME       NULL,
    [I_Brand_ID]          INT            NULL,
    CONSTRAINT [PK__T_Student_Center__1B5ED8E0] PRIMARY KEY CLUSTERED ([I_Student_Detail_ID] ASC, [I_Centre_Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_Center_ID_Student_Center]
    ON [dbo].[T_Student_Center_Detail]([I_Centre_Id] ASC);


GO
CREATE NONCLUSTERED INDEX [index_Student_ID_Student_Center]
    ON [dbo].[T_Student_Center_Detail]([I_Student_Detail_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [Idx_I_status_I_CentreID_I_Student_Detail_ID]
    ON [dbo].[T_Student_Center_Detail]([I_Status] ASC)
    INCLUDE([I_Student_Detail_ID], [I_Centre_Id]);


GO
CREATE NONCLUSTERED INDEX [Ix_I_Centre_Id_I_Status]
    ON [dbo].[T_Student_Center_Detail]([I_Centre_Id] ASC, [I_Status] ASC)
    INCLUDE([I_Student_Detail_ID]);

