CREATE TABLE [dbo].[T_Student_Parent_Maps] (
    [I_Student_Parent_Maps_ID] INT           IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]               INT           NULL,
    [S_Student_ID]             NVARCHAR (50) NULL,
    [I_Student_Detail_ID]      INT           NULL,
    [I_Parent_Master_ID]       INT           NULL,
    [Dt_CreatedAt]             DATETIME      NULL,
    [Dt_UpdatedAt]             DATETIME      NULL,
    [I_Status]                 INT           NULL
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20230612-125155]
    ON [dbo].[T_Student_Parent_Maps]([S_Student_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20230612-125217]
    ON [dbo].[T_Student_Parent_Maps]([I_Parent_Master_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_I_Brand_ID]
    ON [dbo].[T_Student_Parent_Maps]([I_Brand_ID] ASC)
    INCLUDE([S_Student_ID], [I_Parent_Master_ID]);

