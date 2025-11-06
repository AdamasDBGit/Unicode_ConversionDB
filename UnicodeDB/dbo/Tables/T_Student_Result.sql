CREATE TABLE [dbo].[T_Student_Result] (
    [I_Student_Result_ID]                    INT             IDENTITY (1, 1) NOT NULL,
    [I_Result_Exam_Schedule_ID]              INT             NULL,
    [S_Student_ID]                           NVARCHAR (50)   NOT NULL,
    [I_Student_Detail_ID]                    INT             NULL,
    [S_Student_Name]                         NVARCHAR (200)  NULL,
    [S_Guardian_FM_Name]                     NVARCHAR (200)  NULL,
    [S_DOB]                                  DATE            NULL,
    [I_Total_Attendance]                     INT             NULL,
    [I_Total_Class]                          INT             NULL,
    [D_Attendance_Pecentage]                 DECIMAL (18, 2) NULL,
    [S_CT_Remarks]                           NVARCHAR (MAX)  NULL,
    [I_Stream_ID]                            INT             NULL,
    [I_Section_ID]                           INT             NULL,
    [I_Batch_ID]                             INT             NULL,
    [I_Course_ID]                            INT             NULL,
    [I_Term_ID]                              INT             NULL,
    [I_Aggregate_Full_Marks]                 DECIMAL (18, 2) NULL,
    [I_Aggregate_Pass_Marks]                 DECIMAL (18, 2) NULL,
    [I_Aggregate_Obtained_Marks]             DECIMAL (18, 2) NULL,
    [I_Aggregate_Percentage]                 DECIMAL (18, 2) NULL,
    [I_Aggregrate_Class_Average_Percentage]  DECIMAL (18, 2) NULL,
    [I_Aggregate_Class_Highest_Percentage]   DECIMAL (18, 2) NULL,
    [I_Aggregate_Section_Highest_Percentage] DECIMAL (18, 2) NULL,
    [I_Attendance_Percentage]                DECIMAL (18, 2) NULL,
    [I_School_Class_Teacher_ID]              INT             NULL,
    [I_IsPromoted]                           INT             NULL,
    [I_Promoted_Course_ID]                   INT             NULL,
    [I_User_ID]                              INT             NULL,
    [S_Overall_Exam_Attendance]              NVARCHAR (50)   NULL,
    [Dt_ResultDate]                          DATETIME        NULL,
    [I_Student_Rank]                         INT             NULL,
    [I_Total_Students]                       INT             NULL,
    [I_IsHold]                               INT             CONSTRAINT [DF_T_Student_Result_I_IsHold] DEFAULT ((0)) NOT NULL,
    [I_IsReportCardGenerate]                 INT             NULL
);


GO
CREATE NONCLUSTERED INDEX [NCI_S_Student_ID-20230801-103211]
    ON [dbo].[T_Student_Result]([S_Student_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [NCI-I_Result_Exam_Schedule_Id_20230801-103001]
    ON [dbo].[T_Student_Result]([I_Result_Exam_Schedule_ID] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Class wise', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'T_Student_Result', @level2type = N'COLUMN', @level2name = N'I_Aggregrate_Class_Average_Percentage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Class wise', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'T_Student_Result', @level2type = N'COLUMN', @level2name = N'I_Aggregate_Class_Highest_Percentage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Class Teacher', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'T_Student_Result', @level2type = N'COLUMN', @level2name = N'I_User_ID';

