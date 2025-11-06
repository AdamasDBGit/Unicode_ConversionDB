CREATE TABLE [dbo].[T_ERP_Exam_Component_Mapping] (
    [I_Exam_Comp_Map_ID]     INT      IDENTITY (1, 1) NOT NULL,
    [I_Exam_Comp_Header_ID]  INT      NULL,
    [I_Subject_ID]           INT      NULL,
    [I_Subject_Component_ID] INT      NULL,
    [N_Total_Marks]          INT      NULL,
    [N_Pass_Marks]           INT      NULL,
    [Is_PassMandatory]       BIT      NULL,
    [S_Weightage]            INT      NULL,
    [Is_Active]              BIT      CONSTRAINT [DF__T_ERP_Exa__Is_Ac__54434DA2] DEFAULT ((1)) NULL,
    [Dt_Created_At]          DATETIME CONSTRAINT [DF__T_ERP_Exa__Dt_Cr__553771DB] DEFAULT (getdate()) NULL,
    [Dt_Modified_At]         DATETIME NULL,
    [I_Created_By]           INT      NULL,
    [I_Modified_By]          INT      NULL,
    CONSTRAINT [PK__T_ERP_Ex__07816D1C1084F82B] PRIMARY KEY CLUSTERED ([I_Exam_Comp_Map_ID] ASC)
);

