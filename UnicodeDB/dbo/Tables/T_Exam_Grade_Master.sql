CREATE TABLE [dbo].[T_Exam_Grade_Master] (
    [I_Exam_Grade_Master_ID]        INT            IDENTITY (1, 1) NOT NULL,
    [I_Exam_Grade_Master_Header_ID] INT            NULL,
    [S_Symbol]                      NVARCHAR (MAX) NOT NULL,
    [S_Name]                        NVARCHAR (MAX) NULL,
    [I_Lower_Limit]                 INT            NOT NULL,
    [I_Upper_Limit]                 INT            NOT NULL,
    [Dt_CreatedBy]                  INT            NULL,
    [Dt_CreatedAt]                  DATETIME       NULL
);

