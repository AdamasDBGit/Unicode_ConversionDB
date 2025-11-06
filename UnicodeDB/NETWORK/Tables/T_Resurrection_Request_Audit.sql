CREATE TABLE [NETWORK].[T_Resurrection_Request_Audit] (
    [I_Center_Resurrection_Audit_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Center_Resurrection_ID]       INT            NULL,
    [I_Centre_Id]                    INT            NULL,
    [S_Reason]                       VARCHAR (200)  NULL,
    [S_Remarks]                      VARCHAR (1000) NULL,
    [I_Status]                       INT            NULL,
    [S_Crtd_By]                      VARCHAR (20)   NULL,
    [S_Upd_By]                       VARCHAR (20)   NULL,
    [Dt_Crtd_On]                     DATETIME       NULL,
    [Dt_Upd_On]                      DATETIME       NULL,
    CONSTRAINT [PK__T_Resurrection_R__595C0B59] PRIMARY KEY CLUSTERED ([I_Center_Resurrection_Audit_ID] ASC)
);

