CREATE TABLE [dbo].[T_ERP_User_Nationality] (
    [I_Nationality_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Nationality]    NVARCHAR (MAX) NULL,
    [Dtt_Created_At]   DATETIME       CONSTRAINT [DF__T_ERP_Use__Dtt_C__1E865B6F] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]  DATETIME       NULL,
    [I_Created_By]     INT            NULL,
    [I_Modified_By]    INT            NULL,
    [Is_Active]        BIT            CONSTRAINT [DF__T_ERP_Use__Is_Ac__1F7A7FA8] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Us__3727CE15A4EFE1BC] PRIMARY KEY CLUSTERED ([I_Nationality_ID] ASC)
);

