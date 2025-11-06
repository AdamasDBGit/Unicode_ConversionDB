CREATE TABLE [dbo].[T_Subject_Type] (
    [I_Subject_Type_ID] INT           IDENTITY (1, 1) NOT NULL,
    [S_Subject_Type]    NVARCHAR (50) NULL,
    [I_Status]          INT           NULL,
    [I_CreatedBy]       INT           NULL,
    [Dt_CreatedAt]      DATETIME      NULL,
    [I_UpdatedBy]       INT           NULL,
    [Dt_UpdatedAt]      DATETIME      NULL
);

