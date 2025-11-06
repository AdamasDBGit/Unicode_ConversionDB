CREATE TABLE [dbo].[T_ERP_Followup_ReasonType] (
    [I_FollowupReasonType_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Reson_Desc]            NVARCHAR (MAX) NULL,
    [R_I_FollowupType_ID]     INT            NULL,
    [Dtt_Created_At]          DATETIME       CONSTRAINT [DF__T_ERP_Fol__Dtt_C__4970B974] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]         DATETIME       NULL,
    [I_Created_By]            INT            NULL,
    [I_Modified_By]           INT            NULL,
    [Is_Active]               BIT            NULL,
    CONSTRAINT [PK__T_ERP_Fo__DE0E3F3217597282] PRIMARY KEY CLUSTERED ([I_FollowupReasonType_ID] ASC)
);

