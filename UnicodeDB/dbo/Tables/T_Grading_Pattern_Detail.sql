CREATE TABLE [dbo].[T_Grading_Pattern_Detail] (
    [I_Grading_Pattern_Detail_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Grading_Pattern_ID]        INT            NULL,
    [S_Grade_Type]                NVARCHAR (MAX) NULL,
    [S_Grade_Description]         NVARCHAR (MAX) NULL,
    [I_MinMarks]                  INT            NULL,
    [I_MaxMarks]                  INT            NULL,
    CONSTRAINT [PK__T_Grading_Patter__625B65AE] PRIMARY KEY CLUSTERED ([I_Grading_Pattern_Detail_ID] ASC)
);

