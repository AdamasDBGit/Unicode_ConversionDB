CREATE TABLE [dbo].[T_Result_Subject_Module] (
    [I_Result_Subject_Module_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [I_Result_Subject_Rule_ID]       INT            NULL,
    [I_Result_Subject_Group_Rule_ID] INT            NULL,
    [I_Module_ID]                    INT            NULL,
    [I_Exam_Component_ID]            INT            NULL,
    [S_Module_Name]                  NVARCHAR (100) NULL,
    [dmid]                           NVARCHAR (50)  NULL
);

