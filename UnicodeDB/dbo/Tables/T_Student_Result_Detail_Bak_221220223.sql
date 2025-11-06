CREATE TABLE [dbo].[T_Student_Result_Detail_Bak_221220223] (
    [I_Student_Result_Detail_ID]    BIGINT          IDENTITY (1, 1) NOT NULL,
    [I_Student_Result_ID]           BIGINT          NULL,
    [I_Result_Subject_Rule_ID]      INT             NOT NULL,
    [I_Full_Marks]                  DECIMAL (18, 2) NOT NULL,
    [I_Pass_Marks]                  DECIMAL (18, 2) NULL,
    [I_Obtained_Marks]              DECIMAL (18, 2) NULL,
    [I_Highest_Obtained_Marks]      DECIMAL (18, 2) NULL,
    [I_Cumulative_Marks]            DECIMAL (18, 2) NULL,
    [I_Cumulative_Percentage]       DECIMAL (18, 2) NULL,
    [S_Overall_Exam_Sub_Attendance] NVARCHAR (50)   NULL,
    [I_Sequnce_No]                  INT             NULL,
    [S_CreatedBy]                   NVARCHAR (50)   NULL,
    [Dt_CreatedAt]                  DATETIME        NULL
);

