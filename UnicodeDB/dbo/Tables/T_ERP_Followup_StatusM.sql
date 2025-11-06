CREATE TABLE [dbo].[T_ERP_Followup_StatusM] (
    [I_FollowupStatus_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_FollowupStatus_Desc] NVARCHAR (MAX) NULL,
    [Is_Active]             BIT            CONSTRAINT [DF__T_ERP_Fol__Is_Ac__20248B1E] DEFAULT ((1)) NULL,
    [I_Seq]                 INT            NULL
);

