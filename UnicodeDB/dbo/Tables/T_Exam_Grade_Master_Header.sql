CREATE TABLE [dbo].[T_Exam_Grade_Master_Header] (
    [I_Exam_Grade_Master_Header_ID] INT           IDENTITY (1, 1) NOT NULL,
    [I_School_Group_ID]             INT           NOT NULL,
    [I_School_Session_ID]           INT           NOT NULL,
    [I_Class_ID]                    INT           NULL,
    [Dt_CreatedAt]                  DATETIME      NULL,
    [S_CreatedBy]                   NVARCHAR (50) NULL
);

