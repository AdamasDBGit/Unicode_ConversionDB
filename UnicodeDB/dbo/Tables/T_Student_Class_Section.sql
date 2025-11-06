CREATE TABLE [dbo].[T_Student_Class_Section] (
    [I_Student_Class_Section_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID]        INT            NOT NULL,
    [S_Student_ID]               NVARCHAR (100) NULL,
    [I_Brand_ID]                 INT            NULL,
    [I_School_Session_ID]        NCHAR (10)     NOT NULL,
    [I_School_Group_Class_ID]    INT            NULL,
    [I_Section_ID]               INT            NULL,
    [I_Stream_ID]                INT            NULL,
    [I_Student_Type_ID]          INT            NULL,
    [S_Class_Roll_No]            NVARCHAR (50)  NULL,
    [I_Status]                   INT            CONSTRAINT [DF_Table_1_I_Current_Class] DEFAULT ((1)) NULL,
    [dt_Created_dt]              DATETIME       DEFAULT (getdate()) NULL,
    [dt_modify_dt]               DATETIME       DEFAULT (getdate()) NULL,
    [s_remarks]                  NVARCHAR (MAX) NULL
);


GO
CREATE NONCLUSTERED INDEX [idx_I_Student_Detail_ID_status]
    ON [dbo].[T_Student_Class_Section]([I_Student_Detail_ID] ASC, [I_Status] ASC)
    INCLUDE([I_School_Group_Class_ID]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 is just enrolled , 1 is current class, 2 is complete class, 3 is debarred, 4 is TC, 5 is discontinue without inform
only 1 is active student', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'T_Student_Class_Section', @level2type = N'COLUMN', @level2name = N'I_Status';

