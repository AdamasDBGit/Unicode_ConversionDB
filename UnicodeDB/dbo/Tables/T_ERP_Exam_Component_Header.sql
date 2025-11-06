CREATE TABLE [dbo].[T_ERP_Exam_Component_Header] (
    [I_Exam_Comp_Header_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Exam_Component_Name] NVARCHAR (MAX) NULL,
    [I_School_Session_ID]   INT            NULL,
    [I_Brand_ID]            INT            NULL,
    [I_School_Group_ID]     INT            NULL,
    [I_Class_ID]            INT            NULL,
    [I_Stream_ID]           INT            NULL,
    [I_Section_ID]          INT            NULL,
    [Is_Active]             BIT            CONSTRAINT [DF__T_ERP_Exa__Is_Ac__3E540C83] DEFAULT ((1)) NULL,
    [Component_Status]      TINYINT        NULL,
    [Dt_Created_At]         DATETIME       CONSTRAINT [DF__T_ERP_Exa__Dt_Cr__3F4830BC] DEFAULT (getdate()) NULL,
    [Dt_Modified_At]        DATETIME       NULL,
    [I_Created_By]          INT            NULL,
    [I_Modified_By]         INT            NULL
);

