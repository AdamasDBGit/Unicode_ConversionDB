CREATE TABLE [dbo].[T_ERP_Enquiry_Regn_Followup] (
    [I_Followup_ID]         INT            IDENTITY (1, 1) NOT NULL,
    [R_I_FollowupType_ID]   INT            NULL,
    [R_I_Enquiry_Regn_ID]   INT            NULL,
    [Dt_Followup_Date]      DATETIME       NULL,
    [Dt_Next_Followup_Date] DATETIME       NULL,
    [S_Followup_Remarks]    NVARCHAR (MAX) NULL,
    [R_I_Enquiry_Type_ID]   INT            NULL,
    [I_Followup_Status]     INT            NULL,
    [Dt_Created_At]         DATETIME       CONSTRAINT [DF__T_ERP_Enq__Dt_Cr__42C3BBE5] DEFAULT (getdate()) NULL,
    [Dt_Modified_At]        DATETIME       NULL,
    [I_Created_By]          INT            NULL,
    [I_Modified_By]         INT            NULL,
    [S_Followup_By]         NVARCHAR (MAX) NULL,
    [R_I_ModeFollowup_ID]   INT            NULL,
    [Is_Active]             BIT            CONSTRAINT [DF__T_ERP_Enq__Is_Ac__43B7E01E] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_En__9B77B738F4F0D796] PRIMARY KEY CLUSTERED ([I_Followup_ID] ASC)
);

