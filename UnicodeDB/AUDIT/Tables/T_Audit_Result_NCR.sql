CREATE TABLE [AUDIT].[T_Audit_Result_NCR] (
    [I_Audit_Report_NCR_ID]      INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Audit_Result_ID]          INT            NULL,
    [S_NCR_Number]               VARCHAR (50)   NULL,
    [S_NCR_Desc]                 VARCHAR (2000) NULL,
    [I_NCR_Type_ID]              INT            NOT NULL,
    [I_Audit_Functional_Type_ID] INT            NULL,
    [I_Is_Acknowledged]          BIT            CONSTRAINT [DF_T_Audit_Result_NCR_I_Is_Acknowledged] DEFAULT ((0)) NOT NULL,
    [Dt_Acknowledged_On]         DATETIME       NULL,
    [S_Acknowledgement_Remarks]  VARCHAR (20)   NULL,
    [Dt_Target_Close]            DATETIME       NULL,
    [Dt_Actual_Close]            DATETIME       NULL,
    [I_Status_ID]                INT            NULL,
    CONSTRAINT [PK__T_Audit_Result_N__70D538E5] PRIMARY KEY CLUSTERED ([I_Audit_Report_NCR_ID] ASC)
);

