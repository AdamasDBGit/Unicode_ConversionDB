CREATE TABLE [dbo].[T_Result_Subject_Rule_Bak_221220223] (
    [I_Result_Subject_Rule_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [I_Result_Exam_Schedule_ID] INT            NOT NULL,
    [I_Exam_Component_ID]       INT            NULL,
    [I_Module_ID]               INT            NULL,
    [S_Subject_Code]            NVARCHAR (50)  NULL,
    [S_Subject_Name]            NVARCHAR (255) NULL
);

