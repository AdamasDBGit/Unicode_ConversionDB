CREATE TABLE [PLACEMENT].[T_Intnal_Certificate_Master] (
    [I_International_Certificate_ID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Certificate_Name]             VARCHAR (100) NOT NULL,
    [S_Certificate_Vender_Name]      VARCHAR (200) NULL,
    [I_Status]                       INT           NULL,
    [S_Crtd_By]                      VARCHAR (20)  NULL,
    [S_Upd_By]                       VARCHAR (20)  NULL,
    [Dt_Crtd_By]                     DATETIME      NULL,
    [Dt_Upd_By]                      DATETIME      NULL,
    CONSTRAINT [PK__T_Intnal_Certifi__78758F56] PRIMARY KEY CLUSTERED ([I_International_Certificate_ID] ASC)
);

