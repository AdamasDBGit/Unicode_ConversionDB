CREATE TABLE [dbo].[T_ERP_Subject_Template] (
    [I_Subject_Template_ID]        INT           IDENTITY (1, 1) NOT NULL,
    [I_Subject_Template_Header_ID] INT           NOT NULL,
    [S_Structure_Name]             NVARCHAR (50) NULL,
    [I_Sequence_Number]            INT           NULL,
    [I_IsLeaf_Node]                INT           NULL
);

