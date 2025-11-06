CREATE TABLE [dbo].[T_ERP_Subject_Component] (
    [I_Subject_Component_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Subject_Component_Name] NVARCHAR (MAX) NULL,
    [Dt_Created_At]            DATETIME       CONSTRAINT [DF__T_ERP_Sub__Dt_Cr__4536143C] DEFAULT (getdate()) NULL,
    [Dt_Modified_At]           DATETIME       NULL,
    [I_Created_By]             INT            NULL,
    [I_Modified_By]            INT            NULL,
    [Is_Active]                BIT            CONSTRAINT [DF__T_ERP_Sub__Is_Ac__462A3875] DEFAULT ((1)) NULL,
    [I_Brand_ID]               INT            NULL
);

