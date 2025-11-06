CREATE TABLE [dbo].[T_Student_Parent_Maps_Before_delete_12042025] (
    [I_Student_Parent_Maps_ID] INT           IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]               INT           NULL,
    [S_Student_ID]             NVARCHAR (50) NULL,
    [I_Student_Detail_ID]      INT           NULL,
    [I_Parent_Master_ID]       INT           NULL,
    [Dt_CreatedAt]             DATETIME      NULL,
    [Dt_UpdatedAt]             DATETIME      NULL,
    [I_Status]                 INT           NULL
);

