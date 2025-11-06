CREATE TABLE [dbo].[T_Student_Paper_Marks] (
    [I_Student_Result_Detail_ID] INT             IDENTITY (1, 1) NOT NULL,
    [S_Student_ID]               NVARCHAR (50)   NOT NULL,
    [I_Batch_Exam_ID]            INT             NULL,
    [I_Course_ID]                INT             NOT NULL,
    [I_Batch_ID]                 INT             NOT NULL,
    [I_Term_ID]                  INT             NOT NULL,
    [I_Exam_Component_ID]        INT             NOT NULL,
    [I_Full_Marks]               DECIMAL (18, 2) NOT NULL,
    [I_Pass_Marks]               DECIMAL (18, 2) NULL,
    [I_Obtained_Marks]           DECIMAL (18, 2) NOT NULL,
    [I_Highest_Obtained_Marks]   DECIMAL (18, 2) NOT NULL,
    [I_Cumulative_Marks]         DECIMAL (18, 2) NULL,
    [I_Cumulative_Percentage]    DECIMAL (18, 2) NULL,
    [S_CreatedBy]                NVARCHAR (50)   NULL,
    [Dt_CreatedAt]               DATETIME        NULL
);

