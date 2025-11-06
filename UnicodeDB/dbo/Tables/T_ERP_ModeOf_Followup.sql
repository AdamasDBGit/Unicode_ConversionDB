CREATE TABLE [dbo].[T_ERP_ModeOf_Followup] (
    [I_ModeFollowup_ID]      INT            IDENTITY (1, 1) NOT NULL,
    [S_ModeOf_Followup_Desc] NVARCHAR (MAX) NULL,
    [Dtt_Created_At]         DATETIME       CONSTRAINT [DF__T_ERP_Mod__Dtt_C__46944CC9] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]        DATETIME       NULL,
    [I_Created_By]           INT            NULL,
    [I_Modified_By]          INT            NULL,
    [Is_Active]              BIT            NULL,
    CONSTRAINT [PK__T_ERP_Mo__216719B612DD6F4B] PRIMARY KEY CLUSTERED ([I_ModeFollowup_ID] ASC)
);

