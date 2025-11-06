CREATE TABLE [dbo].[T_Enquiry_Regn_Followup] (
    [I_Followup_ID]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Followup_Closure_ID]   INT            NULL,
    [I_Employee_ID]           INT            NULL,
    [I_Enquiry_Regn_ID]       INT            NULL,
    [Dt_Followup_Date]        DATETIME       NULL,
    [Dt_Next_Followup_Date]   DATETIME       NULL,
    [S_Followup_Remarks]      NVARCHAR (MAX) NULL,
    [S_Followup_Type]         CHAR (1)       NULL,
    [S_Followup_Status]       CHAR (1)       NULL,
    [ERP_R_I_FollowupType_ID] INT            NULL,
    [ERP_R_I_Enquiry_Type_ID] INT            NULL,
    [I_User_ID]               INT            NULL,
    [I_Brand_ID]              INT            NULL,
    CONSTRAINT [PK__T_Enquiry_Regn_F__7909C0DC] PRIMARY KEY CLUSTERED ([I_Followup_ID] ASC)
);

