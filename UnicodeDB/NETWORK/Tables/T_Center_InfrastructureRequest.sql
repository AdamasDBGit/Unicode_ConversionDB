CREATE TABLE [NETWORK].[T_Center_InfrastructureRequest] (
    [I_Center_Infrastructure_Audit] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Centre_Id]                   INT            NULL,
    [I_Status]                      INT            NULL,
    [S_Reason]                      VARCHAR (1000) NULL,
    [S_Crtd_By]                     VARCHAR (20)   NULL,
    [S_Upd_By]                      VARCHAR (20)   NULL,
    [Dt_Crtd_On]                    DATETIME       NULL,
    [Dt_Upd_On]                     DATETIME       NULL,
    CONSTRAINT [PK__T_Center_Infrast__585DC57F] PRIMARY KEY CLUSTERED ([I_Center_Infrastructure_Audit] ASC)
);

