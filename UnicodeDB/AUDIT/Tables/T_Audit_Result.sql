CREATE TABLE [AUDIT].[T_Audit_Result] (
    [I_Audit_Result_ID]          INT            IDENTITY (1, 1) NOT NULL,
    [I_Audit_Schedule_ID]        INT            NULL,
    [Dt_Report_Date]             DATETIME       NULL,
    [F_Par_Score]                DECIMAL (4, 2) CONSTRAINT [DF_T_Audit_Result_F_Par_Score] DEFAULT ((0)) NULL,
    [I_Part_A_Score]             INT            NULL,
    [I_Part_B_Score]             INT            NULL,
    [I_Part_C_Score]             INT            NULL,
    [I_Part_D_Score]             INT            NULL,
    [I_Total_No_NC]              INT            NOT NULL,
    [I_Total_No_Repeated_NC]     INT            NOT NULL,
    [I_Total_No_New_NC]          INT            NOT NULL,
    [S_Audited_By]               VARCHAR (20)   NULL,
    [S_Report_Escalated_To]      VARCHAR (20)   NULL,
    [I_Visit_Report_Document_ID] INT            NULL,
    [I_NCR_Status]               INT            NOT NULL,
    [S_Crtd_By]                  VARCHAR (20)   NULL,
    [S_Upd_By]                   VARCHAR (20)   NULL,
    [Dt_Crtd_On]                 DATETIME       NULL,
    [Dt_Upd_On]                  DATETIME       NULL,
    [S_File_Name]                VARCHAR (100)  NULL,
    CONSTRAINT [PK__T_Audit_Result__6EECF073] PRIMARY KEY CLUSTERED ([I_Audit_Result_ID] ASC)
);

