CREATE TABLE [dbo].[T_Exam_Type_Master] (
    [I_Exam_Type_Master_ID] INT            NOT NULL,
    [S_Exam_Type_Name]      NVARCHAR (MAX) NULL,
    [I_TYPE]                INT            NULL,
    CONSTRAINT [PK_T_Exam_Type_Master] PRIMARY KEY CLUSTERED ([I_Exam_Type_Master_ID] ASC)
);

