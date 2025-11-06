CREATE TABLE [dbo].[T_ERP_User_Religion] (
    [I_Religion_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Religion_Name] NVARCHAR (MAX) NULL,
    [Dtt_Created_At]  DATETIME       CONSTRAINT [DF__T_ERP_Use__Dtt_C__2256EC53] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At] DATETIME       NULL,
    [I_Created_By]    INT            NULL,
    [I_Modified_By]   INT            NULL,
    [Is_Active]       BIT            CONSTRAINT [DF__T_ERP_Use__Is_Ac__234B108C] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Us__3F7F77DB2F042FE2] PRIMARY KEY CLUSTERED ([I_Religion_ID] ASC)
);

