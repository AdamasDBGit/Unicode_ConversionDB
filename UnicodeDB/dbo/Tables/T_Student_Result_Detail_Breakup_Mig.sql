CREATE TABLE [dbo].[T_Student_Result_Detail_Breakup_Mig] (
    [I_Student_Result_Detail_Breakup_ID] BIGINT          NOT NULL,
    [I_Student_Result_Detail_ID]         BIGINT          NOT NULL,
    [I_Result_Subject_Group_Rule_ID]     INT             NOT NULL,
    [I_Full_Marks]                       DECIMAL (18, 2) NOT NULL,
    [I_Pass_Marks]                       DECIMAL (18, 2) NULL,
    [I_Obtained_Marks]                   DECIMAL (18, 2) NULL,
    [S_Grade_Marks]                      NVARCHAR (100)  NULL,
    [I_Exam_Grade_Master_ID]             INT             NULL,
    [S_Exam_Attendance]                  NVARCHAR (50)   NULL
);

