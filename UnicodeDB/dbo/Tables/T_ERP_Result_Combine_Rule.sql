CREATE TABLE [dbo].[T_ERP_Result_Combine_Rule] (
    [Result_Combine_RuleID]           INT            IDENTITY (1, 1) NOT NULL,
    [Main_I_Result_Exam_Schedule_ID]  INT            NULL,
    [Child_I_Result_Exam_Schedule_ID] INT            NULL,
    [Exam_name]                       NVARCHAR (MAX) NULL,
    [Is_Active]                       BIT            NULL
);

