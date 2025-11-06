CREATE TABLE [dbo].[T_Subject_Master_bak_28052025] (
    [I_Subject_ID]       INT           IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]         INT           NOT NULL,
    [I_School_Group_ID]  INT           NULL,
    [I_Class_ID]         INT           NOT NULL,
    [S_Subject_Code]     NVARCHAR (50) NOT NULL,
    [S_Subject_Name]     NVARCHAR (50) NOT NULL,
    [I_Subject_Type]     INT           NULL,
    [I_TotalNoOfClasses] INT           NULL,
    [I_Status]           INT           NULL,
    [I_CreatedBy]        INT           NULL,
    [Dt_CreatedAt]       DATETIME      NULL,
    [I_UpdatedBy]        INT           NULL,
    [Dt_UpdatedAt]       DATETIME      NULL,
    [I_Stream_ID]        INT           NULL,
    [I_Class_Stream_ID]  INT           NULL,
    [SubjectGroupID]     INT           NULL
);

