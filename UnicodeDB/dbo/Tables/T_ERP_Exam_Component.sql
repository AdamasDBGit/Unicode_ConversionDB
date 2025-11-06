CREATE TABLE [dbo].[T_ERP_Exam_Component] (
    [I_Exam_Component_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Component_Name]    NVARCHAR (MAX) NULL,
    [Dtt_Created_At]      DATETIME       CONSTRAINT [DF__T_ERP_Exa__Dtt_C__49A5C39E] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]     DATETIME       NULL,
    [I_Created_By]        INT            NULL,
    [I_Modified_By]       INT            NULL,
    [Is_Active]           BIT            CONSTRAINT [DF__T_ERP_Exa__Is_Ac__4A99E7D7] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Ex__A8204D8DFBCC7CB2] PRIMARY KEY CLUSTERED ([I_Exam_Component_ID] ASC)
);

