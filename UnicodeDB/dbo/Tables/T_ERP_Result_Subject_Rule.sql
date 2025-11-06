CREATE TABLE [dbo].[T_ERP_Result_Subject_Rule] (
    [I_Result_Subject_Rule_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [I_Result_Exam_Schedule_ID] INT            NOT NULL,
    [I_Subject_ID]              INT            NULL,
    [S_Subject_Name]            NVARCHAR (MAX) NULL,
    [I_Slot_ID]                 INT            NULL,
    [I_Subject_Sequence]        INT            NULL
);

