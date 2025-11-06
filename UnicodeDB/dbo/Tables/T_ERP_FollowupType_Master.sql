CREATE TABLE [dbo].[T_ERP_FollowupType_Master] (
    [I_FollowupType_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Followup_Name]   NVARCHAR (MAX) NULL,
    [Dtt_Created_At]    DATETIME       CONSTRAINT [DF__T_ERP_Fol__Dtt_C__59A7213D] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]   DATETIME       NULL,
    [I_Created_By]      INT            NULL,
    [I_Modified_By]     INT            NULL,
    [Is_Active]         BIT            CONSTRAINT [DF__T_ERP_Fol__Is_Ac__5A9B4576] DEFAULT ((1)) NULL
);

