CREATE TABLE [dbo].[T_Result_Rule_Dtl_Mig] (
    [I_Result_Rule_Dtl_ID]               INT             NOT NULL,
    [I_Result_Exam_Schedule_ID]          INT             NOT NULL,
    [I_Previous_Result_Exam_Schedule_ID] INT             NOT NULL,
    [I_Percentage_Val]                   DECIMAL (10, 2) NOT NULL
);

