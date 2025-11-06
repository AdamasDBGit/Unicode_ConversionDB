CREATE TABLE [dbo].[T_ERP_Occupation_Master] (
    [I_Occupation_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Occupation_Name] NVARCHAR (MAX) NULL,
    [Dtt_Created_At]    DATETIME       CONSTRAINT [DF__T_ERP_Occ__Dtt_C__3569C0C7] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]   DATETIME       NULL,
    [I_Created_By]      INT            NULL,
    [I_Modified_By]     INT            NULL,
    [Is_Active]         BIT            CONSTRAINT [DF__T_ERP_Occ__Is_Ac__365DE500] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Oc__7C6CF34144CFB87C] PRIMARY KEY CLUSTERED ([I_Occupation_ID] ASC)
);

