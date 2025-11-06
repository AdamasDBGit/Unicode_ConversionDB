CREATE TABLE [dbo].[T_Result_Rule_Dtl] (
    [I_Result_Rule_Dtl_ID]               INT             IDENTITY (1, 1) NOT NULL,
    [I_Result_Exam_Schedule_ID]          INT             NOT NULL,
    [I_Previous_Result_Exam_Schedule_ID] INT             NOT NULL,
    [I_Percentage_Val]                   DECIMAL (10, 2) NOT NULL,
    CONSTRAINT [PK__T_Result__F57E9A5FAA19A4A0] PRIMARY KEY CLUSTERED ([I_Result_Rule_Dtl_ID] ASC)
);

