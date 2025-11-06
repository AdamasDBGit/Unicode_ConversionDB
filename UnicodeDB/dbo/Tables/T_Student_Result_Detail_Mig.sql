CREATE TABLE [dbo].[T_Student_Result_Detail_Mig] (
    [I_Student_Result_Detail_ID]     BIGINT          NOT NULL,
    [I_Student_Result_ID]            BIGINT          NULL,
    [I_Result_Subject_Rule_ID]       INT             NOT NULL,
    [I_Full_Marks]                   DECIMAL (18, 2) NOT NULL,
    [I_Pass_Marks]                   DECIMAL (18, 2) NULL,
    [I_Obtained_Marks]               DECIMAL (18, 2) NULL,
    [I_Highest_Obtained_Marks]       DECIMAL (18, 2) NULL,
    [S_Grade_Marks]                  NVARCHAR (100)  NULL,
    [I_Exam_Grade_Master_ID]         INT             NULL,
    [S_Highest_Grade_Marks]          NVARCHAR (100)  NULL,
    [I_Highest_Exam_Grade_Master_ID] INT             NULL,
    [I_Cumulative_Marks]             DECIMAL (18, 2) NULL,
    [I_Cumulative_Percentage]        DECIMAL (18, 2) NULL,
    [S_Overall_Exam_Sub_Attendance]  NVARCHAR (50)   NULL,
    [I_Sequnce_No]                   INT             NULL,
    [S_CreatedBy]                    NVARCHAR (50)   NULL,
    [Dt_CreatedAt]                   DATETIME        NULL
);

