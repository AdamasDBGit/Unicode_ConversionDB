CREATE TABLE [AUDIT].[T_Breach_Notice_NCR] (
    [I_Audit_Report_NCR_ID] INT          NOT NULL,
    [I_Breach_Notice_ID]    INT          NOT NULL,
    [S_Crtd_By]             VARCHAR (20) NULL,
    [S_Updt_By]             VARCHAR (20) NULL,
    [Dt_Crtd_By]            DATETIME     NULL,
    [Dt_Upd_On]             DATETIME     NULL,
    CONSTRAINT [PK_T_Breach_Notice_NCR] PRIMARY KEY CLUSTERED ([I_Audit_Report_NCR_ID] ASC, [I_Breach_Notice_ID] ASC)
);

