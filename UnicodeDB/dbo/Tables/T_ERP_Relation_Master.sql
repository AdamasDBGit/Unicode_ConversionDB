CREATE TABLE [dbo].[T_ERP_Relation_Master] (
    [I_Relation_Master_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Relation_Type]      NVARCHAR (MAX) NULL,
    [Dtt_Created_At]       DATETIME       CONSTRAINT [DF__T_ERP_Rel__Dtt_C__31992FE3] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]      DATETIME       NULL,
    [I_Created_By]         INT            NULL,
    [I_Modified_By]        INT            NULL,
    [Is_Active]            BIT            CONSTRAINT [DF__T_ERP_Rel__Is_Ac__328D541C] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Re__B7421F5D3577D961] PRIMARY KEY CLUSTERED ([I_Relation_Master_ID] ASC)
);

